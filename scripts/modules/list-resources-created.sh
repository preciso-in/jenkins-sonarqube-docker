list_resources_created() {

    RESOURCE_NAMES="
    PROJECT_ID
    REGION
    BUCKET_ID
    NETWORK_NAME
    SUBNET_NAME
    INSTANCE_TEMPLATE_NAME
    JENKINS_INSTANCE_NAME
    DOCKER_INSTANCE_NAME
    SONARQUBE_INSTANCE_NAME
    JENKINS_NETWORK_TAG
    SONARQUBE_NETWORK_TAG
    DOCKER_NETWORK_TAG
"

    >./working/created-resource-names.sh

    for var in $RESOURCE_NAMES; do
        echo "export $var=${!var}" >>./working/created-resource-names.sh
    done
}
