#!/bin/sh

set -e
set -x

if [ -z "$INPUT_SOURCE_FOLDER" ]
then
  echo "Source folder must be defined"
  return -1
fi

if [ $INPUT_DESTINATION_HEAD_BRANCH == "main" ] || [ $INPUT_DESTINATION_HEAD_BRANCH == "master" ]
then
  echo "Destination head branch cannot be 'main' nor 'master'"
  return -1
fi

if [ -z "$INPUT_PULL_REQUEST_REVIEWERS" ]
then
  PULL_REQUEST_REVIEWERS=$INPUT_PULL_REQUEST_REVIEWERS
else
  PULL_REQUEST_REVIEWERS='-r '$INPUT_PULL_REQUEST_REVIEWERS
fi

if [ "$INPUT_RECURSIVE" == "true" ]
then
  echo "Recursive copy is enabled"
  CP_OPTION="-r"
else
  CP_OPTION=""
fi

if [ "$INPUT_ALLOW_FORCE_PUSH" == "true" ]
then
  echo "Force push is enabled"
  FORCE_PUSH="f"
else
  FORCE_PUSH=""
fi

if [ "$INPUT_CREATE_AS_DRAFT" == "true" ]
then
  echo "Create as draft is enabled"
  CREATE_AS_DRAFT=' -d '
else
  CREATE_AS_DRAFT=''
fi

PR_TITLE=$INPUT_PR_TITLE
if [ -z $INPUT_PR_TITLE ]
then
    echo "PR title not defined, using destination head branch as PR title"
    PR_TITLE=$INPUT_DESTINATION_HEAD_BRANCH
fi

PR_BODY=$INPUT_PR_BODY
if [ -z $INPUT_PR_BODY ]
then
    echo "PR body not defined, using destination head branch as PR body"
    PR_BODY=$INPUT_DESTINATION_HEAD_BRANCH
fi

COMMIT_MSG=$INPUT_COMMIT_MSG
if [ -z $INPUT_COMMIT_MSG ]
then
    echo "Commit message not defined, using default commit message"
    COMMIT_MSG="Update from https://$INPUT_GITHUB_SERVER/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
fi

if [ "$INPUT_CLONE_FROM_DESTINATION_BASE" == "true" ]
then
  echo "Cloning from destination base branch"
  CLONE_FROM_BRANCH="-b $INPUT_DESTINATION_BASE_BRANCH"
else
  CLONE_FROM_BRANCH=''
fi

CLONE_DIR=$(mktemp -d)

echo "Setting git variables"
export API_TOKEN_GITHUB=${API_TOKEN_GITHUB//$'\n'}
export GITHUB_TOKEN=$API_TOKEN_GITHUB
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"

echo "Cloning destination git repository"
git clone $CLONE_FROM_BRANCH "https://$API_TOKEN_GITHUB@$INPUT_GITHUB_SERVER/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"

echo "Copying contents to git repo"
mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
cp $CP_OPTION "$INPUT_SOURCE_FOLDER/." "$CLONE_DIR/$INPUT_DESTINATION_FOLDER/"
cd "$CLONE_DIR"
git checkout -b "$INPUT_DESTINATION_HEAD_BRANCH"

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$COMMIT_MSG"
  echo "Pushing git commit"
  git push -u$FORCE_PUSH origin HEAD:$INPUT_DESTINATION_HEAD_BRANCH
  echo "Creating a pull request"
  gh pr create -t "$PR_TITLE" \
               -b "$PR_BODY" \
               -B $INPUT_DESTINATION_BASE_BRANCH \
               -H $INPUT_DESTINATION_HEAD_BRANCH \
                  $PULL_REQUEST_REVIEWERS \
                  $CREATE_AS_DRAFT
else
  echo "No changes detected"
fi
