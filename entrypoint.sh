#!/bin/sh -l

set -e -o pipefail

commit_sha=$(git rev-parse HEAD)
echo "HEAD commit SHA is $commit_sha"

short_sha=$(echo $commit_sha | cut -c -7)
echo "Short commit SHA is $short_sha"

branch=$(git branch --show-current)
echo "HEAD branch is $branch"

# not set if not in an action workflow. https://docs.github.com/en/actions/reference/environment-variables
if [ -n "${GITHUB_HEAD_REF:-}" ]; then
    is_pr=true
    pr_head=${GITHUB_HEAD_REF}
    pr_base=${GITHUB_BASE_REF}

    echo "This workflow is a PR from ${GITHUB_HEAD_REF} targeting ${GITHUB_BASE_REF}"
else
    is_pr=false
    echo "Not a PR workflow"
fi

tags=$(git tag --points-at HEAD | xargs)
tag=$(echo $tags | awk '{ print $1 }')
tags_count=$(echo $tags | wc -w | xargs)

if [ -z "$tags" ]; then
    echo "No tags point to this commit"
elif [ 1 -eq "$tags_count" ]; then
    echo "Tag $tags points to this commit"
else
    echo "$tags_count tags point to this commit: $tags"
fi

echo "::set-output name=branch::${branch}"
echo "::set-output name=is_pr::${is_pr}"
echo "::set-output name=pr_head::${pr_head}"
echo "::set-output name=pr_base::${pr_base}"
echo "::set-output name=short_sha::$short_sha"
echo "::set-output name=tag::$tag"
echo "::set-output name=tags::$tags"
echo "::set-output name=tag_count::$tags_count"
