from botocore.exceptions import ClientError
from cockpit_common.common import *
from helpers.common import auth, verify_boto3
from pprint import pprint
import boto3
import re
import subprocess
import sys

# Variaveis de parametros
REGION = "@@AWS_REGION@@"
ACCOUNTID = "@@AWS_ACCOUNT_ID@@"
BU = "@@BU@@"
ENV = "@@ENV@@"
CERTIFICATE = """@@CERTIFICATE_BODY@@"""
PRIVATE_KEY = """@@PRIVATE_KEY@@"""
CHAIN = """@@CERTIFICATE_CHAIN@@"""

BASE_PATH = "/tmp"
TAG_ENV = {
    "dev": "dev",
    "test": "tst",
    "staging": "stg",
    "uat": "uat",
    "sandbox": "sbx",
    "prod": "prd"
}
TAGS = [{"Key": "Environment",
         "Value" : TAG_ENV[ENV.lower()]
        },
        {"Key": "Terraform-managed",
         "Value": "False"
        },
        {"Key": "BU",
         "Value": BU
        }
       ]


def save_cert_file(filename, body):
    """ Create a file"""
    with open(f"{BASE_PATH}/{filename}", "w") as fp:
        pprint(body.replace("\n","").replace("\r", ""), stream=fp)

    with open(f"{BASE_PATH}/{filename}", "r") as fp_read:
        _fp = fp_read.read().replace("(","").replace(")","").replace("'","").replace("'","").replace(" -----END CERTIFICATE-----","\n-----END CERTIFICATE-----").replace(" -----END PRIVATE KEY-----", "\n-----END PRIVATE KEY-----").replace("\n-----END CERTIFICATE----- \n -----BEGIN CERTIFICATE----- \n ", "\n-----END CERTIFICATE-----\n-----BEGIN CERTIFICATE----- \n ").replace("\n ", "\n").replace(" \n", "\n").replace("\n\n-----END CERTIFICATE-----", "\n-----END CERTIFICATE-----").replace(" -----END\nCERTIFICATE-----", "\n-----END CERTIFICATE-----").replace(" -----END\nPRIVATE\nKEY-----", "\n-----END PRIVATE KEY-----").replace(" -----END\nCERTIFICATE----------BEGIN\nCERTIFICATE-----", "\n-----END CERTIFICATE-----\n-----BEGIN CERTIFICATE-----\n").replace("\n-----END CERTIFICATE----------BEGIN\nCERTIFICATE-----\n","\n-----END CERTIFICATE-----\n-----BEGIN CERTIFICATE-----\n")

    with open(f"{BASE_PATH}/{filename}", "w") as new_fp:
        new_fp.write(_fp)
        log_msg(f"{filename} has been salved", "INFO")


def extract_crt(cert_files):
    """ Extract Common Name """
    cert         = cert_files.get("cert", "")
    priv         = cert_files.get("priv", "")
    chain        = cert_files.get("chain", "")
    cert_arn     = ""
    subject_info = ""

    try:
        openssl_cmd = ["openssl", "x509", "-noout", "-subject", "-in", cert]
        rs = subprocess.run(openssl_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)

        if rs.returncode == 0:
            subject_info = re.search(r"CN\s*=\s*([^,]+)", rs.stdout.strip()).group(1)

            try:
                cert_list = acm_client.list_certificates(
                                CertificateStatuses=["ISSUED"]
                )

                for crt in cert_list["CertificateSummaryList"]:
                    if crt["DomainName"] == subject_info:
                        cert_arn = crt["CertificateArn"]
                    elif f"*.{crt['DomainName']}" == subject_info:
                        # WildCard
                        cert_arn = crt["CertificateArn"]
            except ClientError as client_error:
                print_err_msg(client_error)
                log_msg("Couldn't import certiticate.", "FAILED")
                sys.exit(1)

            log_msg(f"CN: {subject_info}", "INFO")


            for crts in cert_files.items():
                with open(f"{crts[1]}", "r") as crt_read:
                    if crts[0] == "cert":
                        cert = crt_read.read()
                    elif crts[0] == "priv": 
                        priv = crt_read.read()
                    elif crts[0] == "chain":
                        chain = crt_read.read()

            return {"cert": cert, "priv": priv, "chain": chain, "arn": cert_arn, "subject": subject_info}
        else:
            log_msg(f"Error: {rs.stderr}", "FAILED")
            sys.exit(1)
    except Exception as err:
        print_err_msg(err)
        log_msg("Couldn't import certiticate.", "FAILED")
        sys.exit(1)


def update_certificate(acm_client, cert_files):
    """ Reimport certificate """
    arn = cert_files.get("arn", "")

    if arn:
        import_certificate(acm_client, cert_files, arn=arn)
    else:
        log_msg("Couldn't update certiticate. Invalid ARN", "FAILED")
        sys.exit(1)


def create_certificate(acm_client, cert_files):
    """ Create a new certificate """
    import_certificate(acm_client, cert_files)


def import_certificate(acm_client, cert_files, arn=""):
    """ Importing certificate """
    cert  = cert_files.get("cert", "")
    priv  = cert_files.get("priv", "")
    chain = cert_files.get("chain", "")

    try:
        if arn:
            # Update
            if chain:
                cert = acm_client.import_certificate(
                        CertificateArn=arn,
                        Certificate = cert,
                        PrivateKey = priv,
                        CertificateChain = chain
                )
            else:
                cert = acm_client.import_certificate(
                        CertificateArn=arn,
                        Certificate = cert,
                        PrivateKey = priv
                )
        else:
            # Create
            if chain:
                cert = acm_client.import_certificate(
                        Certificate = cert,
                        PrivateKey = priv,
                        CertificateChain = chain,
                        Tags=TAGS
                )
            else:
                cert = acm_client.import_certificate(
                        Certificate = cert,
                        PrivateKey = priv,
                        Tags=TAGS
                )

        log_msg(cert.get("CertificateArn", ""), "SUCCESS") 
        return cert.get("CertificateArn", "")

    except ClientError as client_error:
        print_err_msg(client_error)
        log_msg("Couldn't import certiticate.", "FAILED")
        sys.exit(1)


def print_err_msg(c_err):
    """short method to handle printing an error message if there is one"""
    print("Error Message: {}".format(c_err.response["Error"]["Message"]))
    print("Request ID: {}".format(c_err.response["ResponseMetadata"]["RequestId"]))
    print("Http code: {}".format(c_err.response["ResponseMetadata"]["HTTPStatusCode"]))


if __name__=="__main__":
    if sys.version_info[0] < 3:
        log_msg("python2 detected, please use python3. Will try to run anyway", "FAILED")
    if not verify_boto3(boto3.__version__):
        log_msg(f"boto3 version {boto3.__version__}, is not valid for this script. Need 1.16.25 or higher", "FAILED")
        log_msg("please run pip install boto3 --upgrade --user", "FAILED")
        sys.exit(1)

    # Session
    base_session = auth(ACCOUNTID, BU, REGION)
    acm_client = base_session.client("acm", region_name = REGION)

    log_msg("acm_manager.py : Initialize launch aws-certificate-import", "INFO")
    log_msg(f"Region: {REGION}", "INFO")
    log_msg(f"Account Id: {ACCOUNTID}", "INFO")
    log_msg(f"Bu: {BU}", "INFO")

    cer_file   = f"certificate_{ACCOUNTID}_{ENV}.cer"
    priv_file  = f"private_{ACCOUNTID}_{ENV}.key"
    chain_file = f"chain_{ACCOUNTID}_{ENV}.cert"
    
    # Save files
    save_cert_file(f"{cer_file}", CERTIFICATE)
    save_cert_file(f"{priv_file}", PRIVATE_KEY)

    cert_files = {}
    cert_files["cert"] = f"{BASE_PATH}/{cer_file}"
    cert_files["priv"] = f"{BASE_PATH}/{priv_file}"

    if CHAIN:
        save_cert_file(f"chain_{ACCOUNTID}_{ENV}.cert", CHAIN)
        cert_files["chain"] = f"{BASE_PATH}/{chain_file}"
    crts = extract_crt(cert_files)

    @@ACTION@@_certificate(acm_client, cert_files = crts)
