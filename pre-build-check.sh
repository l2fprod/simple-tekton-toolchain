#!/bin/bash
# uncomment to debug the script
set -x
# copy the script below into your app code repo (e.g. ./scripts/check_prebuild.sh) and 'source' it from your pipeline job
#    source ./scripts/check_prebuild.sh
# alternatively, you can source it from online script:
#    source <(curl -sSL "https://raw.githubusercontent.com/open-toolchain/commons/master/scripts/check_prebuild.sh")
# ------------------
# source: https://raw.githubusercontent.com/open-toolchain/commons/master/scripts/check_prebuild.sh
echo "REGISTRY_URL=${REGISTRY_URL}"
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}"
echo "IMAGE_NAME=${IMAGE_NAME}"
echo "ARCHIVE_DIR=${ARCHIVE_DIR}"
echo "DOCKER_ROOT=${DOCKER_ROOT}"
echo "DOCKER_FILE=${DOCKER_FILE}"

# View build properties
if [ -f build.properties ]; then 
  echo "build.properties:"
  cat build.properties
else 
  echo "build.properties : not found"
fi 
# also run 'env' command to find all available env variables
# or learn more about the available environment variables at:
# https://cloud.ibm.com/docs/ContinuousDelivery?topic=ContinuousDelivery-deliverypipeline_environment

echo "=========================================================="
echo "Checking for Dockerfile at the repository root"
if [ -z "${DOCKER_ROOT}" ]; then DOCKER_ROOT=. ; fi
if [ -z "${DOCKER_FILE}" ]; then DOCKER_FILE=Dockerfile ; fi
if [ -f ${DOCKER_ROOT}/${DOCKER_FILE} ]; then 
echo -e "Dockerfile found at: ${DOCKER_FILE}"
else
    echo "Dockerfile not found at: ${DOCKER_FILE}"
    exit 1
fi
echo "Linting Dockerfile"
npm install -g dockerlint
dockerlint -f ${DOCKER_ROOT}/${DOCKER_FILE}

echo "=========================================================="
echo "Checking registry namespace: ${REGISTRY_NAMESPACE}"
NS=$( ibmcloud cr namespaces | grep ${REGISTRY_NAMESPACE} ||: )
if [ -z "${NS}" ]; then
    echo "Registry namespace ${REGISTRY_NAMESPACE} not found, creating it."
    ibmcloud cr namespace-add ${REGISTRY_NAMESPACE}
    echo "Registry namespace ${REGISTRY_NAMESPACE} created."
else 
    echo "Registry namespace ${REGISTRY_NAMESPACE} found."
fi
