#!/bin/bash

# Variables
AWS_REGION=${AWS_REGION}
BUILD_PROJECT_NAME=${BUILD_PROJECT_NAME}
GITHUB_TOKEN=${GITHUB_TOKEN}
GITHUB_OWNER=${GITHUB_OWNER}
GITHUB_REPO=${GITHUB_REPO}
GITHUB_COMMIT_SHA=${CODEBUILD_RESOLVED_SOURCE_VERSION}

# Get the latest build from AWS CodeBuild
BUILD_ID=$(aws codebuild list-builds-for-project --project-name $BUILD_PROJECT_NAME --sort-order DESCENDING --query 'ids[0]' --output text)

#Extract the build status
BUILD_STATUS=$(aws codebuild batch-get-builds --ids $BUILD_ID --query 'builds[0].buildStatus' --output text)

# Map the AWS CodeBuild status to GitHub status
case $BUILD_STATUS in
    "SUCCEEDED")
        GITHUB_STATE="success"
        DESCRIPTION="The build succeeded"
        ;;
    "FAILED")
        GITHUB_STATE="failure"
        DESCRIPTION="The build failed"
        ;;
    "IN_PROGRESS")
        GITHUB_STATE="success"
        DESCRIPTION="The build succeeded"
        ;;
    *)
        GITHUB_STATE="error"
        DESCRIPTION="The build status is unknown"
        ;;
esac

# Send the status to GitHub
curl -s -X POST https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/statuses/$GITHUB_COMMIT_SHA \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "state": "'"$GITHUB_STATE"'",
    "description": "'"$DESCRIPTION"'",
    "context": "continuous-integration/aws-codebuild"
  }'