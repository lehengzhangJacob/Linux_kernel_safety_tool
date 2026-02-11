#!/bin/bash
# Auto batch push: push N commits at a time
export http_proxy=http://127.0.0.1:7897
export https_proxy=http://127.0.0.1:7897
BATCH=5
REMOTE=origin
BRANCH=main

commits=$(git log --oneline --reverse ${REMOTE}/${BRANCH}..HEAD | awk '{print $1}')
total=$(echo "$commits" | wc -l)
echo "Total commits to push: $total"

count=0
for sha in $commits; do
    count=$((count + 1))
    if [ $((count % BATCH)) -eq 0 ] || [ $count -eq $total ]; then
        echo "=== Pushing up to commit $count/$total : $sha ==="
        for retry in 1 2 3 4 5; do
            git push ${REMOTE} ${sha}:refs/heads/${BRANCH} && break
            echo "Retry $retry failed, waiting 30s..."
            sleep 30
        done
    fi
done

echo "=== All done! ==="
