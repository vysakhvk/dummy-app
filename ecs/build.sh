#!/usr/bin/env bash
if [ "$DEPLOY_ENVIRONMENT" != "production" ]; then
    echo -n "$CODEBUILD_BUILD_ID" | sed "s/.*:\([[:xdigit:]]\{7\}\).*/\1/" > build.id
    echo -n "RELEASE_VERSION-$BUILD_SCOPE-$(cat ./build.id)" > docker.tag
    docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_NAME:$(cat docker.tag) .
    TAG=$(cat docker.tag)
else
    TAG=$RELEASE_VERSION
fi

sed -i "s@ECS_CLUSTER_NAME@${ECS_CLUSTER_NAME}@g" ecs/service.yaml
sed -i "s@TAG@$TAG@g" ecs/service.yaml
sed -i "s@DOCKER_IMAGE_URI@$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_NAME:$TAG@g" ecs/service.yaml
sed -i "s@PUBLIC_SUBNET_AZ1@$PUBLIC_SUBNET_AZ1@g" ecs/service.yaml
sed -i "s@PUBLIC_SUBNET_AZ2@$PUBLIC_SUBNET_AZ2@g" ecs/service.yaml
sed -i "s@VPC_ID@$VPC_ID@g" ecs/service.yaml
