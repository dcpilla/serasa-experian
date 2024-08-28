# Airflow 2.6.3 with Python 3.8-bookworm

## Docker build
docker build --progress plain .      --build-arg PYTHON_BASE_IMAGE=837714169011.dkr.ecr.sa-east-1.amazonaws.com/python:3.8-bookworm      --build-arg AIRFLOW_VERSION="2.6.3"      --build-arg INSTALL_PACKAGES_FROM_CONTEXT="false"      --build-arg DOCKER_CONTEXT_FILES="docker-context-files"      --build-arg AIRFLOW_CONSTRAINTS_LOCATION=""      --build-arg INSTALL_MSSQL_CLIENT="false"      --build-arg INSTALL_MYSQL_CLIENT="false"      --build-arg ADDITIONAL_PIP_INSTALL_FLAGS="--trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org"      --build-arg RUNTIME_APT_DEPS="build-essential libsasl2-dev vim libsasl2-dev python-dev-is-python3 libldap2-dev libssl-dev apt-transport-https apt-utils ca-certificates curl dumb-init freetds-bin gosu krb5-user ldap-utils libldap-common libsasl2-2 libsasl2-modules  locales lsb-release netcat-openbsd openssh-client python3-selinux rsync sasl2-bin sqlite3 sudo unixodbc default-mysql-client"      --build-arg DEV_APT_DEPS="build-essential libsasl2-dev vim libsasl2-dev python-dev-is-python3 libldap2-dev libssl-dev"      --build-arg ADDITIONAL_PYTHON_DEPS="apache-airflow-providers-cncf-kubernetes apache-airflow-providers-apache-spark apache-airflow-providers-common-sql apache-airflow-providers-apache-hive apache-airflow-providers-apache-cassandra apache-airflow-providers-mysql"      --build-arg ADDITIONAL_RUNTIME_APT_COMMAND="ls -lap"      --build-arg POST_SCRIPT_FUNCATION_TO_CALL="fix_zookeeper"      --tag "airflow:v2.6.3-p3.8-bookworm-Fx_28aFKTY6gKpXF4Qo8uQ"
## Wiz Result

OS Package vulnerabilities:
    Name: apt, Version: 2.6.1
        CVE-2011-3374, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-3374
            CVSS score: 3.7, CVSS exploitability score: 2.2
    Name: apt-transport-https, Version: 2.6.1
        CVE-2011-3374, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-3374
            CVSS score: 3.7, CVSS exploitability score: 2.2
    Name: apt-utils, Version: 2.6.1
        CVE-2011-3374, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-3374
            CVSS score: 3.7, CVSS exploitability score: 2.2
    Name: binutils, Version: 2.40-2
        CVE-2018-20673, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20673
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-20712, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20712
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2018-9996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-9996
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-32256, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-32256
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-1972, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1972
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-13716, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-13716
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18483, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18483
            CVSS score: 7.8, CVSS exploitability score: 1.8
    Name: binutils-common, Version: 2.40-2
        CVE-2018-9996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-9996
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-32256, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-32256
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-1972, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1972
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-13716, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-13716
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18483, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18483
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2018-20673, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20673
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-20712, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20712
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: binutils-x86-64-linux-gnu, Version: 2.40-2
        CVE-2017-13716, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-13716
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18483, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18483
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2018-20673, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20673
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-20712, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20712
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2018-9996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-9996
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-32256, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-32256
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-1972, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1972
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: bsdutils, Version: 1:2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: coreutils, Version: 9.1-1
        CVE-2016-2781, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-2781
            CVSS score: 6.5, CVSS exploitability score: 2
        CVE-2017-18018, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-18018
            CVSS score: 4.7, CVSS exploitability score: 1
    Name: cpp-12, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: dirmngr, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: g++-12, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: gcc-12, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: gcc-12-base, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: git, Version: 1:2.39.2-1.1
        CVE-2023-25652, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-25652
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-25815, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-25815
            CVSS score: 2.2, CVSS exploitability score: 0.8
        CVE-2023-29007, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-29007
            CVSS score: 7.8, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2018-1000021, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-1000021
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2022-24975, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-24975
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
    Name: git-man, Version: 1:2.39.2-1.1
        CVE-2023-25652, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-25652
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-25815, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-25815
            CVSS score: 2.2, CVSS exploitability score: 0.8
        CVE-2023-29007, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-29007
            CVSS score: 7.8, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2018-1000021, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-1000021
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2022-24975, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-24975
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
    Name: gnupg, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gnupg2, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gnupg-l10n, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gnupg-utils, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gpg, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gpg-agent, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gpg-wks-client, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gpg-wks-server, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gpgconf, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gpgsm, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: gpgv, Version: 2.2.40-1.1
        CVE-2022-3219, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-3219
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: imagemagick, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: imagemagick-6-common, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: imagemagick-6.q16, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: krb5-multidev, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: krb5-user, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: ldap-utils, Version: 2.5.13+dfsg-5
        CVE-2023-2953, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2953
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-17740, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17740
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2020-15719, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2020-15719
            CVSS score: 4.2, CVSS exploitability score: 1.6
        CVE-2015-3276, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2015-3276
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-14159, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-14159
            CVSS score: 4.7, CVSS exploitability score: 1
    Name: libaom3, Version: 3.6.0-1
        CVE-2023-39616, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-39616
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libapt-pkg6.0, Version: 2.6.1
        CVE-2011-3374, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-3374
            CVSS score: 3.7, CVSS exploitability score: 2.2
    Name: libasan8, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libatomic1, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libbinutils, Version: 2.40-2
        CVE-2023-1972, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1972
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-13716, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-13716
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18483, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18483
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2018-20673, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20673
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-20712, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20712
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2018-9996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-9996
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-32256, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-32256
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libblkid1, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libblkid-dev, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libbluetooth3, Version: 5.66-1
        CVE-2016-9918, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9918
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2016-9797, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9797
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9798, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9798
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9801, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9801
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9802, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9802
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9803, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9803
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9917, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9917
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2016-9799, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9799
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9800, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9800
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9804, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9804
            CVSS score: 5.3, CVSS exploitability score: 3.9
    Name: libbluetooth-dev, Version: 5.66-1
        CVE-2016-9797, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9797
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9799, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9799
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9800, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9800
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9801, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9801
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9802, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9802
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9917, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9917
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2016-9918, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9918
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2016-9798, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9798
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9803, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9803
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2016-9804, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9804
            CVSS score: 5.3, CVSS exploitability score: 3.9
    Name: libc6, Version: 2.36-9+deb12u3
        CVE-2010-4756, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-4756
            CVSS score: 4, CVSS exploitability score: 8
        CVE-2018-20796, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20796
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2019-1010022, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010022
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2019-1010023, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010023
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2019-1010024, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010024
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-1010025, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010025
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-9192, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-9192
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libc6-dev, Version: 2.36-9+deb12u3
        CVE-2018-20796, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20796
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2019-1010022, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010022
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2019-1010023, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010023
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2019-1010024, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010024
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-1010025, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010025
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-9192, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-9192
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2010-4756, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-4756
            CVSS score: 4, CVSS exploitability score: 8
    Name: libc-bin, Version: 2.36-9+deb12u3
        CVE-2010-4756, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-4756
            CVSS score: 4, CVSS exploitability score: 8
        CVE-2018-20796, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20796
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2019-1010022, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010022
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2019-1010023, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010023
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2019-1010024, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010024
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-1010025, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010025
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-9192, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-9192
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libc-dev-bin, Version: 2.36-9+deb12u3
        CVE-2019-9192, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-9192
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2010-4756, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-4756
            CVSS score: 4, CVSS exploitability score: 8
        CVE-2018-20796, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20796
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2019-1010022, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010022
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2019-1010023, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010023
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2019-1010024, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010024
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-1010025, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010025
            CVSS score: 5.3, CVSS exploitability score: 3.9
    Name: libc-l10n, Version: 2.36-9+deb12u3
        CVE-2010-4756, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-4756
            CVSS score: 4, CVSS exploitability score: 8
        CVE-2018-20796, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20796
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2019-1010022, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010022
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2019-1010023, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010023
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2019-1010024, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010024
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-1010025, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010025
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-9192, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-9192
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libcairo2, Version: 1.16.0-7
        CVE-2019-6461, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6461
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2019-6462, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6462
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7475, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7475
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18064, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18064
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libcairo2-dev, Version: 1.16.0-7
        CVE-2019-6461, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6461
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2019-6462, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6462
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7475, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7475
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18064, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18064
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libcairo-gobject2, Version: 1.16.0-7
        CVE-2017-7475, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7475
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18064, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18064
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2019-6461, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6461
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2019-6462, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6462
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libcairo-script-interpreter2, Version: 1.16.0-7
        CVE-2019-6461, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6461
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2019-6462, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6462
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7475, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7475
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18064, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18064
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libcc1-0, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libctf0, Version: 2.40-2
        CVE-2018-20673, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20673
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-20712, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20712
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2018-9996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-9996
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-32256, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-32256
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-1972, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1972
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-13716, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-13716
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18483, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18483
            CVSS score: 7.8, CVSS exploitability score: 1.8
    Name: libctf-nobfd0, Version: 2.40-2
        CVE-2018-9996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-9996
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-32256, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-32256
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-1972, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1972
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-13716, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-13716
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18483, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18483
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2018-20673, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20673
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-20712, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20712
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libdav1d6, Version: 1.0.0-2
        CVE-2023-32570, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-32570
            CVSS score: 5.9, CVSS exploitability score: 2.2
    Name: libde265-0, Version: 1.0.11-1
        CVE-2023-27102, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27102
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2023-27103, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27103
            CVSS score: 8.8, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2023-47471, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-47471
        CVE-2023-43887, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-43887
    Name: libdjvulibre21, Version: 3.5.28-2+b1
        CVE-2021-46310, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-46310
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2021-46312, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-46312
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libdjvulibre-dev, Version: 3.5.28-2+b1
        CVE-2021-46310, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-46310
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2021-46312, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-46312
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libdjvulibre-text, Version: 3.5.28-2
        CVE-2021-46310, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-46310
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2021-46312, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-46312
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libgcc-12-dev, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libgcc-s1, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libgcrypt20, Version: 1.10.1-3
        CVE-2018-6829, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-6829
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
    Name: libglib2.0-0, Version: 2.74.6-2
        CVE-2012-0039, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2012-0039
            CVSS score: 5, CVSS exploitability score: 10
    Name: libglib2.0-bin, Version: 2.74.6-2
        CVE-2012-0039, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2012-0039
            CVSS score: 5, CVSS exploitability score: 10
    Name: libglib2.0-data, Version: 2.74.6-2
        CVE-2012-0039, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2012-0039
            CVSS score: 5, CVSS exploitability score: 10
    Name: libglib2.0-dev, Version: 2.74.6-2
        CVE-2012-0039, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2012-0039
            CVSS score: 5, CVSS exploitability score: 10
    Name: libglib2.0-dev-bin, Version: 2.74.6-2
        CVE-2012-0039, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2012-0039
            CVSS score: 5, CVSS exploitability score: 10
    Name: libgnutls30, Version: 3.7.9-2
        CVE-2023-5981, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-5981
        CVE-2011-3389, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-3389
            CVSS score: 4.3, CVSS exploitability score: 8.6
    Name: libgomp1, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libgprofng0, Version: 2.40-2
        CVE-2018-20712, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20712
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2018-9996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-9996
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-32256, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-32256
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-1972, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1972
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-13716, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-13716
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-18483, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-18483
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2018-20673, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20673
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libgssapi-krb5-2, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libgssrpc4, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libharfbuzz0b, Version: 6.0.0+dfsg-3
        CVE-2023-25193, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-25193
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libheif1, Version: 1.15.1-1
        CVE-2023-29659, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-29659
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
    Name: libitm1, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libjansson4, Version: 2.14-2
        CVE-2020-36325, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2020-36325
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
    Name: libjbig0, Version: 2.1-6.1
        CVE-2017-9937, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-9937
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libjbig-dev, Version: 2.1-6.1
        CVE-2017-9937, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-9937
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libk5crypto3, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libkadm5clnt-mit12, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libkadm5srv-mit12, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libkdb5-10, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libkrb5-3, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libkrb5-dev, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libkrb5support0, Version: 1.20.1-2+deb12u1
        CVE-2018-5709, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-5709
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libldap2-dev, Version: 2.5.13+dfsg-5
        CVE-2023-2953, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2953
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2020-15719, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2020-15719
            CVSS score: 4.2, CVSS exploitability score: 1.6
        CVE-2015-3276, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2015-3276
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-14159, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-14159
            CVSS score: 4.7, CVSS exploitability score: 1
        CVE-2017-17740, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17740
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libldap-2.5-0, Version: 2.5.13+dfsg-5
        CVE-2023-2953, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2953
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-17740, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17740
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2020-15719, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2020-15719
            CVSS score: 4.2, CVSS exploitability score: 1.6
        CVE-2015-3276, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2015-3276
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-14159, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-14159
            CVSS score: 4.7, CVSS exploitability score: 1
    Name: libldap-common, Version: 2.5.13+dfsg-5
        CVE-2023-2953, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2953
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2015-3276, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2015-3276
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-14159, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-14159
            CVSS score: 4.7, CVSS exploitability score: 1
        CVE-2017-17740, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17740
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2020-15719, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2020-15719
            CVSS score: 4.2, CVSS exploitability score: 1.6
    Name: libldap-dev, Version: 2.5.13+dfsg-5
        CVE-2023-2953, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2953
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2020-15719, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2020-15719
            CVSS score: 4.2, CVSS exploitability score: 1.6
        CVE-2015-3276, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2015-3276
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-14159, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-14159
            CVSS score: 4.7, CVSS exploitability score: 1
        CVE-2017-17740, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17740
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: liblsan0, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libmagickcore-6-arch-config, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickcore-6-headers, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickcore-6.q16-6, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickcore-6.q16-6-extra, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickcore-6.q16-dev, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickcore-dev, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickwand-6-headers, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickwand-6.q16-6, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickwand-6.q16-dev, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmagickwand-dev, Version: 8:6.9.11.60+dfsg-1.6
        CVE-2021-3610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3610
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-2157, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2157
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1906, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1906
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2022-1115, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-1115
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-1289, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-1289
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-3428, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3428
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2022-3213, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2022-3213
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3195, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3195
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-34151, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-34151
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-11754, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11754
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-7275, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-7275
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2018-15607, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15607
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-8678, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-8678
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-20311, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-20311
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2005-0406, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-0406
            CVSS score: 2.1, CVSS exploitability score: 3.9
        CVE-2008-3134, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3134
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2017-11755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-11755
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-34152, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-34152
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2023-5341, Severity: INFORMATIONAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-5341
    Name: libmount1, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libmount-dev, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libnghttp2-14, Version: 1.52.0-1
        CVE-2023-44487, Severity: HIGH, Source: https://security-tracker.debian.org/tracker/CVE-2023-44487
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit, Has CISA KEV exploit
    Name: libopenexr-3-1-30, Version: 3.1.5-5
        CVE-2017-14988, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-14988
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-26945, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-26945
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libopenexr-dev, Version: 3.1.5-5
        CVE-2017-14988, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-14988
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2021-26945, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-26945
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libopenjp2-7, Version: 2.5.0-2
        CVE-2021-3575, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3575
            CVSS score: 7.8, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2018-16376, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-16376
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2018-20846, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20846
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2019-6988, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6988
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-9114, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9114
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2016-9113, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9113
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2016-9117, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9117
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-9580, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9580
            CVSS score: 8.8, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2018-16375, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-16375
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2016-10505, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-10505
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2016-9115, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9115
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2017-17479, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17479
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2016-10506, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-10506
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2016-9581, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9581
            CVSS score: 8.8, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-9116, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9116
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
    Name: libopenjp2-7-dev, Version: 2.5.0-2
        CVE-2021-3575, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-3575
            CVSS score: 7.8, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2019-6988, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6988
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-10506, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-10506
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2016-9116, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9116
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2018-16376, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-16376
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2016-9581, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9581
            CVSS score: 8.8, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2018-16375, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-16375
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2016-9115, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9115
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-9117, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9117
            CVSS score: 6.5, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-9580, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9580
            CVSS score: 8.8, CVSS exploitability score: 2.8
            Has public exploit
        CVE-2016-10505, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-10505
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2016-9114, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9114
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2018-20846, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20846
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2016-9113, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-9113
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2017-17479, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17479
            CVSS score: 9.8, CVSS exploitability score: 3.9
    Name: libperl5.36, Version: 5.36.0-7
        CVE-2023-31484, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-31484
            CVSS score: 8.1, CVSS exploitability score: 2.2
            Has public exploit
        CVE-2011-4116, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-4116
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-31486, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31486
            CVSS score: 8.1, CVSS exploitability score: 2.2
    Name: libpixman-1-0, Version: 0.42.2-1
        CVE-2023-37769, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-37769
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libpixman-1-dev, Version: 0.42.2-1
        CVE-2023-37769, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-37769
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libpng16-16, Version: 1.6.39-2
        CVE-2021-4214, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-4214
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
    Name: libpng-dev, Version: 1.6.39-2
        CVE-2021-4214, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-4214
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
    Name: libproc2-0, Version: 2:4.0.2-3
        CVE-2023-4016, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4016
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libpython3.11, Version: 3.11.2-6
        CVE-2023-24329, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-24329
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-27043, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27043
            CVSS score: 5.3, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-40217, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40217
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-41105, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41105
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-24535
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libpython3.11-dev, Version: 3.11.2-6
        CVE-2023-27043, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27043
            CVSS score: 5.3, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-40217, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40217
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-41105, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41105
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24329, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-24329
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-24535
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libpython3.11-minimal, Version: 3.11.2-6
        CVE-2023-24329, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-24329
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-27043, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27043
            CVSS score: 5.3, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-40217, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40217
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-41105, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41105
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-24535
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libpython3.11-stdlib, Version: 3.11.2-6
        CVE-2023-27043, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27043
            CVSS score: 5.3, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-40217, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40217
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-41105, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41105
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24329, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-24329
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-24535
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: libquadmath0, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libsmartcols1, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libsqlite3-0, Version: 3.40.1-2
        CVE-2021-45346, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-45346
            CVSS score: 4.3, CVSS exploitability score: 2.8
            Has public exploit
    Name: libsqlite3-dev, Version: 3.40.1-2
        CVE-2021-45346, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-45346
            CVSS score: 4.3, CVSS exploitability score: 2.8
            Has public exploit
    Name: libssl3, Version: 3.0.11-1~deb12u2
        CVE-2023-5678, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-5678
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2010-0928, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-0928
            CVSS score: 4, CVSS exploitability score: 1.9
        CVE-2007-6755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-6755
            CVSS score: 5.8, CVSS exploitability score: 8.6
    Name: libssl-dev, Version: 3.0.11-1~deb12u2
        CVE-2023-5678, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-5678
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2007-6755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-6755
            CVSS score: 5.8, CVSS exploitability score: 8.6
        CVE-2010-0928, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-0928
            CVSS score: 4, CVSS exploitability score: 1.9
    Name: libstdc++6, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libstdc++-12-dev, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libsystemd0, Version: 252.17-1~deb12u1
        CVE-2013-4392, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2013-4392
            CVSS score: 3.3, CVSS exploitability score: 3.4
        CVE-2023-31437, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31437
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-31438, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31438
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-31439, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31439
            CVSS score: 5.3, CVSS exploitability score: 3.9
    Name: libtcl8.6, Version: 8.6.13+dfsg-2
        CVE-2021-35331, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-35331
            CVSS score: 7.8, CVSS exploitability score: 1.8
    Name: libtiff6, Version: 4.5.0-6
        CVE-2023-2908, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2908
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-26966, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-26966
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-41175, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41175
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-25433, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-25433
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3576, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3576
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3618, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3618
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-3316, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3316
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-26965, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-26965
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-40745, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40745
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-3164, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-3164
            CVSS score: 7.1, CVSS exploitability score: 1.8
        CVE-2022-1210, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-1210
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-6228, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-6228
        CVE-2018-10126, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-10126
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-5563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-5563
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2017-9117, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-9117
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2023-1916, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1916
            CVSS score: 6.1, CVSS exploitability score: 1.8
        CVE-2017-16232, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-16232
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-17973, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17973
            CVSS score: 8.8, CVSS exploitability score: 2.8
    Name: libtiff-dev, Version: 4.5.0-6
        CVE-2023-25433, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-25433
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-26965, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-26965
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-2908, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2908
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3316, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3316
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-40745, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40745
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-41175, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41175
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-26966, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-26966
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3576, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3576
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3618, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3618
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-17973, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17973
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2018-10126, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-10126
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2022-1210, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-1210
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-9117, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-9117
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2017-5563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-5563
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2023-6228, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-6228
        CVE-2017-16232, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-16232
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-1916, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1916
            CVSS score: 6.1, CVSS exploitability score: 1.8
        CVE-2023-3164, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-3164
            CVSS score: 7.1, CVSS exploitability score: 1.8
    Name: libtiffxx6, Version: 4.5.0-6
        CVE-2023-25433, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-25433
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-2908, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2908
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-41175, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41175
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-3618, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3618
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-40745, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40745
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-26966, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-26966
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3316, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3316
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-26965, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-26965
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3576, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-3576
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2017-16232, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-16232
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2017-9117, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-9117
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2023-6228, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-6228
        CVE-2017-17973, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-17973
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2018-10126, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-10126
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2022-1210, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-1210
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2017-5563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-5563
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2023-1916, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1916
            CVSS score: 6.1, CVSS exploitability score: 1.8
        CVE-2023-3164, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-3164
            CVSS score: 7.1, CVSS exploitability score: 1.8
    Name: libtsan2, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libubsan1, Version: 12.2.0-14
        CVE-2023-4039, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4039
            CVSS score: 4.8, CVSS exploitability score: 2.2
        CVE-2022-27943, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-27943
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libudev1, Version: 252.17-1~deb12u1
        CVE-2013-4392, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2013-4392
            CVSS score: 3.3, CVSS exploitability score: 3.4
        CVE-2023-31437, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31437
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-31438, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31438
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-31439, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31439
            CVSS score: 5.3, CVSS exploitability score: 3.9
    Name: libuuid1, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: libwmf-0.2-7, Version: 0.2.12-5.1
        CVE-2007-3476, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3476
            CVSS score: 4.3, CVSS exploitability score: 8.6
        CVE-2007-3477, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3477
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2007-3996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3996
            CVSS score: 6.8, CVSS exploitability score: 8.6
        CVE-2009-3546, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2009-3546
            CVSS score: 9.3, CVSS exploitability score: 8.6
    Name: libwmf-dev, Version: 0.2.12-5.1
        CVE-2007-3476, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3476
            CVSS score: 4.3, CVSS exploitability score: 8.6
        CVE-2007-3477, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3477
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2007-3996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3996
            CVSS score: 6.8, CVSS exploitability score: 8.6
        CVE-2009-3546, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2009-3546
            CVSS score: 9.3, CVSS exploitability score: 8.6
    Name: libwmflite-0.2-7, Version: 0.2.12-5.1
        CVE-2007-3476, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3476
            CVSS score: 4.3, CVSS exploitability score: 8.6
        CVE-2007-3477, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3477
            CVSS score: 5, CVSS exploitability score: 10
        CVE-2007-3996, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-3996
            CVSS score: 6.8, CVSS exploitability score: 8.6
        CVE-2009-3546, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2009-3546
            CVSS score: 9.3, CVSS exploitability score: 8.6
    Name: libxml2, Version: 2.9.14+dfsg-1.3~deb12u1
        CVE-2023-39615, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-39615
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-45322, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-45322
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libxml2-dev, Version: 2.9.14+dfsg-1.3~deb12u1
        CVE-2023-39615, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-39615
            CVSS score: 6.5, CVSS exploitability score: 2.8
        CVE-2023-45322, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-45322
            CVSS score: 6.5, CVSS exploitability score: 2.8
    Name: libxslt1-dev, Version: 1.1.35-1
        CVE-2015-9019, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2015-9019
            CVSS score: 5.3, CVSS exploitability score: 3.9
    Name: libxslt1.1, Version: 1.1.35-1
        CVE-2015-9019, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2015-9019
            CVSS score: 5.3, CVSS exploitability score: 3.9
    Name: locales, Version: 2.36-9+deb12u3
        CVE-2018-20796, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-20796
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2019-1010022, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010022
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2019-1010023, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010023
            CVSS score: 8.8, CVSS exploitability score: 2.8
        CVE-2019-1010024, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010024
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-1010025, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-1010025
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2019-9192, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-9192
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2010-4756, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-4756
            CVSS score: 4, CVSS exploitability score: 8
    Name: login, Version: 1:4.13+dfsg1-1+b1
        CVE-2023-4641, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4641
        CVE-2023-29383, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-29383
            CVSS score: 3.3, CVSS exploitability score: 1.8
        CVE-2007-5686, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-5686
            CVSS score: 4.9, CVSS exploitability score: 3.9
        CVE-2019-19882, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-19882
            CVSS score: 7.8, CVSS exploitability score: 1.8
    Name: m4, Version: 1.4.19-3
        CVE-2008-1687, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-1687
            CVSS score: 7.5, CVSS exploitability score: 10
        CVE-2008-1688, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-1688
            CVSS score: 7.5, CVSS exploitability score: 10
    Name: mount, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: openssh-client, Version: 1:9.2p1-2+deb12u1
        CVE-2023-28531, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-28531
            CVSS score: 9.8, CVSS exploitability score: 3.9
        CVE-2007-2768, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-2768
            CVSS score: 4.3, CVSS exploitability score: 8.6
        CVE-2020-14145, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2020-14145
            CVSS score: 5.9, CVSS exploitability score: 2.2
        CVE-2019-6110, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-6110
            CVSS score: 6.8, CVSS exploitability score: 1.6
            Has public exploit
        CVE-2020-15778, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2020-15778
            CVSS score: 7.8, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2007-2243, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-2243
            CVSS score: 5, CVSS exploitability score: 10
            Has public exploit
        CVE-2008-3234, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-3234
            CVSS score: 6.5, CVSS exploitability score: 8
            Has public exploit
        CVE-2016-20012, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2016-20012
            CVSS score: 5.3, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2018-15919, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-15919
            CVSS score: 5.3, CVSS exploitability score: 3.9
    Name: openssl, Version: 3.0.11-1~deb12u2
        CVE-2023-5678, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-5678
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2007-6755, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-6755
            CVSS score: 5.8, CVSS exploitability score: 8.6
        CVE-2010-0928, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-0928
            CVSS score: 4, CVSS exploitability score: 1.9
    Name: passwd, Version: 1:4.13+dfsg1-1+b1
        CVE-2023-29383, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-29383
            CVSS score: 3.3, CVSS exploitability score: 1.8
        CVE-2023-4641, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4641
        CVE-2007-5686, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2007-5686
            CVSS score: 4.9, CVSS exploitability score: 3.9
        CVE-2019-19882, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2019-19882
            CVSS score: 7.8, CVSS exploitability score: 1.8
    Name: patch, Version: 2.7.6-7
        CVE-2018-6952, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-6952
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2021-45261, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-45261
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2010-4651, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2010-4651
            CVSS score: 5.8, CVSS exploitability score: 8.6
        CVE-2018-6951, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2018-6951
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: perl, Version: 5.36.0-7
        CVE-2023-31484, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-31484
            CVSS score: 8.1, CVSS exploitability score: 2.2
            Has public exploit
        CVE-2011-4116, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-4116
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-31486, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31486
            CVSS score: 8.1, CVSS exploitability score: 2.2
    Name: perl-base, Version: 5.36.0-7
        CVE-2023-31484, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-31484
            CVSS score: 8.1, CVSS exploitability score: 2.2
            Has public exploit
        CVE-2011-4116, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-4116
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-31486, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31486
            CVSS score: 8.1, CVSS exploitability score: 2.2
    Name: perl-modules-5.36, Version: 5.36.0-7
        CVE-2023-31484, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-31484
            CVSS score: 8.1, CVSS exploitability score: 2.2
            Has public exploit
        CVE-2011-4116, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2011-4116
            CVSS score: 7.5, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-31486, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-31486
            CVSS score: 8.1, CVSS exploitability score: 2.2
    Name: procps, Version: 2:4.0.2-3
        CVE-2023-4016, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4016
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: python3.11, Version: 3.11.2-6
        CVE-2023-24329, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-24329
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-27043, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27043
            CVSS score: 5.3, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-40217, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40217
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-41105, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41105
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-24535
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: python3.11-dev, Version: 3.11.2-6
        CVE-2023-24329, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-24329
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-27043, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27043
            CVSS score: 5.3, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-40217, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40217
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-41105, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41105
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-24535
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: python3.11-minimal, Version: 3.11.2-6
        CVE-2023-24329, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-24329
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-27043, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-27043
            CVSS score: 5.3, CVSS exploitability score: 3.9
            Has public exploit
        CVE-2023-40217, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-40217
            CVSS score: 5.3, CVSS exploitability score: 3.9
        CVE-2023-41105, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-41105
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-24535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-24535
            CVSS score: 7.5, CVSS exploitability score: 3.9
    Name: sqlite3, Version: 3.40.1-2
        CVE-2021-45346, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-45346
            CVSS score: 4.3, CVSS exploitability score: 2.8
            Has public exploit
    Name: sudo, Version: 1.9.13p3-1+deb12u1
        CVE-2005-1119, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-1119
            CVSS score: 2.1, CVSS exploitability score: 3.9
    Name: tar, Version: 1.34+dfsg-1.2
        CVE-2022-48303, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-48303
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2005-2541, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2005-2541
            CVSS score: 10, CVSS exploitability score: 10
    Name: tcl8.6, Version: 8.6.13+dfsg-2
        CVE-2021-35331, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-35331
            CVSS score: 7.8, CVSS exploitability score: 1.8
    Name: tcl8.6-dev, Version: 8.6.13+dfsg-2
        CVE-2021-35331, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-35331
            CVSS score: 7.8, CVSS exploitability score: 1.8
    Name: unzip, Version: 6.0-28
        CVE-2021-4217, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2021-4217
            CVSS score: 3.3, CVSS exploitability score: 1.8
    Name: util-linux, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: util-linux-extra, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: uuid-dev, Version: 2.38.1-5+b1
        CVE-2022-0563, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2022-0563
            CVSS score: 5.5, CVSS exploitability score: 1.8
    Name: vim, Version: 2:9.0.1378-2
        CVE-2023-4738, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4738
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4752, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4752
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4781, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4781
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-5344, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-5344
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-2610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2610
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-5441, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-5441
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1264, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1264
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-4734, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4734
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48231, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48231
        CVE-2023-48237, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48237
        CVE-2008-4677, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-4677
            CVSS score: 4.3, CVSS exploitability score: 8.6
        CVE-2017-1000382, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-1000382
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-48233, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48233
        CVE-2023-48236, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48236
        CVE-2023-1355, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1355
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-46246, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-46246
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-48235, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48235
        CVE-2023-2609, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-2609
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-48232, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48232
        CVE-2023-48706, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48706
        CVE-2023-48234, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48234
        CVE-2023-5535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-5535
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4735, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4735
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4750, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4750
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4751, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4751
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-3896, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-3896
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4733, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4733
            CVSS score: 7.8, CVSS exploitability score: 1.8
    Name: vim-common, Version: 2:9.0.1378-2
        CVE-2023-4781, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4781
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-5344, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-5344
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-2610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2610
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4752, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4752
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4738, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4738
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4734, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4734
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4735, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4735
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-5535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-5535
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-1264, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1264
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-2609, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-2609
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-5441, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-5441
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2008-4677, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-4677
            CVSS score: 4.3, CVSS exploitability score: 8.6
        CVE-2023-4733, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4733
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48231, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48231
        CVE-2023-48234, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48234
        CVE-2017-1000382, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-1000382
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-3896, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-3896
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48232, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48232
        CVE-2023-48706, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48706
        CVE-2023-46246, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-46246
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-4751, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4751
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48235, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48235
        CVE-2023-48236, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48236
        CVE-2023-48237, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48237
        CVE-2023-1355, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1355
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-4750, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4750
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48233, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48233
    Name: vim-runtime, Version: 2:9.0.1378-2
        CVE-2023-4738, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4738
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4752, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4752
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4781, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-4781
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-2610, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-2610
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-5344, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2023-5344
            CVSS score: 7.5, CVSS exploitability score: 3.9
        CVE-2023-4734, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4734
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48232, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48232
        CVE-2017-1000382, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2017-1000382
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-48233, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48233
        CVE-2023-3896, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-3896
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48237, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48237
        CVE-2008-4677, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2008-4677
            CVSS score: 4.3, CVSS exploitability score: 8.6
        CVE-2023-46246, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-46246
            CVSS score: 5.5, CVSS exploitability score: 1.8
            Has public exploit
        CVE-2023-4735, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4735
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48706, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48706
        CVE-2023-2609, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-2609
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-4750, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4750
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48236, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48236
        CVE-2023-5535, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-5535
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-5441, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-5441
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1264, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1264
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-1355, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-1355
            CVSS score: 5.5, CVSS exploitability score: 1.8
        CVE-2023-48234, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48234
        CVE-2023-48235, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48235
        CVE-2023-4733, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4733
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-4751, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-4751
            CVSS score: 7.8, CVSS exploitability score: 1.8
        CVE-2023-48231, Severity: LOW, Source: https://security-tracker.debian.org/tracker/CVE-2023-48231
    Name: wget, Version: 1.21.3-1+b2
        CVE-2021-31879, Severity: MEDIUM, Source: https://security-tracker.debian.org/tracker/CVE-2021-31879
            CVSS score: 6.1, CVSS exploitability score: 2.8
    Name: zlib1g, Version: 1:1.2.13.dfsg-1
        CVE-2023-45853, Severity: CRITICAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-45853
            CVSS score: 9.8, CVSS exploitability score: 3.9
    Name: zlib1g-dev, Version: 1:1.2.13.dfsg-1
        CVE-2023-45853, Severity: CRITICAL, Source: https://security-tracker.debian.org/tracker/CVE-2023-45853
            CVSS score: 9.8, CVSS exploitability score: 3.9

Evaluated policies: Default secrets policy, Default vulnerabilities policy
Vulnerable packages: CRITICAL: 2, HIGH: 1, MEDIUM: 76, LOW: 91, INFORMATIONAL: 0
    Total: 170
Vulnerabilities: CRITICAL: 2, HIGH: 1, MEDIUM: 250, LOW: 535, INFORMATIONAL: 14
    Total: 802, out of which 0 are fixable
Directories scanned: 8350, Files scanned: 62346
Scan results: PASSED. Container image meets policy requirements
Scan Report: (https://app.wiz.io/reports/cicd-scans#~(cicd_scan~'b65d9513-afc0-45d2-8f8c-69163ac54a77))
Using mount/mountWithLayers drivers is recommended to decrease image scan time. For more information - https://docs.wiz.io/wiz-docs/docs/wiz-cli-cont-img#scan-drivers

## Handle Result Wiz

ALLOW_VULNERABILITIES is set to yes

## ECR repository

837714169011.dkr.ecr.sa-east-1.amazonaws.com/airflow:v2.6.3-p3.8-bookworm-Fx_28aFKTY6gKpXF4Qo8uQ
