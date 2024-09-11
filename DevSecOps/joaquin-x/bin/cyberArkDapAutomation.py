#!/usr/bin/python3

# * Este arquivo é parte do projeto DevOps Serasa Experian 
# *
# * @package        
# * @name           cyberArkDap.py
# * @version        v1.0.0
# * @description    Getting cyberark credentials for aws accounts with dap module.
# * @author         DevSecOps PaaS Brazil
# * @contribution   Felipe Olivoto. <felipe.olivotto@br.experian.com>
# * @copyright      2022 &copy Serasa Experian

import requests

class CyberArkDap:
   
    token           = None
    safe            = None
    account         = None
    awsAccountId    = None

    def __init__(self, token, safe, account, awsAccountId):
        self.token        = token
        self.safe         = safe
        self.account      = account
        self.awsAccountId = awsAccountId

    @staticmethod
    def __lobValue(safe):
        import re

        lobValue = {
            "USCLD": "LOB_USCLD",
            "BR": "LOB_BR",
            "USMK": "LOB_USMK"
        }

        lob = re.search(r'(^[A-Za-z]+)', safe)
        
        return lobValue[lob.group(1)]


    def auth(self):
        """
        Authentication method.

        Returns the header with the constructed token.
        """
        import base64

        url = "https://awsfollower.us.experian.eeca/authn/Experian/host%2feits-devsecopspaas-cockpit-prd-br/authenticate"

        header = {
            'Content-Type': 'application/json'
        }

        authToken = requests.post(url, headers=header, data=self.token, verify="/etc/pki/ca-trust/source/anchors/dap-prod-follower.pem").text 
        encoded = str(base64.b64encode(authToken.encode("ascii"))).replace('b\'', '').replace('\'','')

        header = {
            'Authorization': 'Token token="{}"'.format(encoded)
        }

        return header


    def getCredentialsStatic(self, header):
        """
        Method for get Cyberark credentials with dap API for static accounts.

        Return a string object with usr and pwd separated by space. 
        """

        lobValue = CyberArkDap.__lobValue(self.safe)
    
        url = "https://awsfollower.us.experian.eeca/secrets/Experian/variable/VAULT%2F{}%2F{}%2F{}%2F".format(lobValue, self.safe, self.account)     

        usr = requests.get("{}{}".format(url, "username"), headers=header, verify="/etc/pki/ca-trust/source/anchors/dap-prod-follower.pem").text
        pwd = requests.get("{}{}".format(url, "password"), headers=header, verify="/etc/pki/ca-trust/source/anchors/dap-prod-follower.pem").text
        
        return "{} {}".format(usr, pwd)


    def getCredentialsAws(self, awsAccountId, header):
        """
        Method for get Cyberark credentials with dap API for AWS accounts.

        awsAccountId = Your AWS Account ID. 

        Return a string object with access key, pwd Key and aws account ID separated by space.
        """

        lobValue = CyberArkDap.__lobValue(self.safe)

        url = "https://awsfollower.us.experian.eeca/secrets/Experian/variable/VAULT%2F{}%2F{}%2F{}@{}%2F".format(lobValue, self.safe, self.account, self.awsAccountId)

        accessKey = requests.get("{}{}".format(url, "awsaccesskeyid"), headers=header, verify="/etc/pki/ca-trust/source/anchors/dap-prod-follower.pem").text
        pwdKey = requests.get("{}{}".format(url, "password"), headers=header, verify="/etc/pki/ca-trust/source/anchors/dap-prod-follower.pem").text
        awsAccountId = requests.get("{}{}".format(url, "awsaccountid"), headers=header, verify="/etc/pki/ca-trust/source/anchors/dap-prod-follower.pem").text

        return "{} {} {}".format(awsAccountId, accessKey, pwdKey)


def helper():
    import argparse

    data = "Get credentials from CyberArk Dap"

    parser = argparse.ArgumentParser(description=data)

    parser.add_argument("-r", "--runner", help="Runner (aws / static).")
    parser.add_argument("-t", "--token", help="Cyberark Token.")
    parser.add_argument("-s", "--safe", help="Safe name.")
    parser.add_argument("-c", "--cyberArkAccount", help="Cyberark account name.")
    parser.add_argument("-a", "--awsAccountId", help="AWS account ID. (Only aws runner).")

    return parser.parse_args()


def __logging(message):
    import time
    print("CyberArkDap.py - {} - {}".format(time.strftime('%c'), message))


def main(args):

    cyberark = CyberArkDap(args.token, args.safe, args.cyberArkAccount, args.awsAccountId)
       
    authHeader = cyberark.auth()

    if args.runner.lower() == "aws":
        if args.awsAccountId:
            print(cyberark.getCredentialsAws(args.awsAccountId, authHeader))
        else:
            __logging("Aws account ID not provided. Ending execution.")
            exit(1)
    elif args.runner.lower() == "static":
        print(cyberark.getCredentialsStatic(authHeader))
    else:
        __logging("The informed Runner does not exist. Ending execution.")
        exit(1)

if __name__ == "__main__":
    args = helper()
    main(args)
