# Airflow 2.7.2 with Python 3.11-bookworm

## Docker build
```bash
$ docker build --progress plain . \
     --build-arg PYTHON_BASE_IMAGE=${COE_IMAGE_BASE} \
     --build-arg AIRFLOW_VERSION="${AIRFLOW_VERSION}" \
     --build-arg INSTALL_PACKAGES_FROM_CONTEXT="${INSTALL_PACKAGES_FROM_CONTEXT}" \
     --build-arg DOCKER_CONTEXT_FILES="${DOCKER_CONTEXT_FILES}" \
     --build-arg AIRFLOW_CONSTRAINTS_LOCATION="${AIRFLOW_CONSTRAINTS_LOCATION}" \
     --build-arg INSTALL_MSSQL_CLIENT="${INSTALL_MSSQL_CLIENT}" \
     --build-arg INSTALL_MYSQL_CLIENT="${INSTALL_MYSQL_CLIENT}" \
     --build-arg ADDITIONAL_PIP_INSTALL_FLAGS="${ADDITIONAL_PIP_INSTALL_FLAGS}" \
     --build-arg RUNTIME_APT_DEPS="${RUNTIME_APT_DEPS}" \
     --build-arg DEV_APT_DEPS="${DEV_APT_DEPS}" \
     --build-arg ADDITIONAL_PYTHON_DEPS="${ADDITIONAL_PYTHON_DEPS}" \
     --build-arg ADDITIONAL_RUNTIME_APT_COMMAND="${ADDITIONAL_RUNTIME_APT_COMMAND}" \
     --build-arg POST_SCRIPT_FUNCATION_TO_CALL="${POST_SCRIPT_FUNCATION_TO_CALL}" \
     --tag "${TAG}"
```