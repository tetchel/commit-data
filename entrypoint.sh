#!/bin/sh

commit_sha=$(git rev-parse HEAD)
echo "HEAD commit SHA is $commit_sha"

short_sha=$(echo $commit_sha | cut -c -7)
echo "Short commit SHA is $short_sha"

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

echo
echo "::set-output name=short_sha::$short_sha"
echo "::set-output name=tag::$tag"
echo "::set-output name=tags::$tags"
echo "::set-output name=tag_count:$tags_count"
