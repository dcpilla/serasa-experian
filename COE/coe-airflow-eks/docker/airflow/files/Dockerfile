# This file is appended to Dockerfile used by Airflow, this way we have a chance to change what is needed
FROM main

ARG POST_SCRIPT_FUNCATION_TO_CALL=""

USER root

COPY scripts/post-script.sh post-script.sh
RUN bash post-script.sh -f ${POST_SCRIPT_FUNCATION_TO_CALL}
