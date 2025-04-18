#!/bin/sh

path=drivers/net/wireless/mediatek/mt76/


set -e
if [ -z "$1" ] || [ -z "$2" ]; then
    exit 1
fi
from=$1
to=$2
start=$(git merge-base $from $to)
refs=$(git log --reverse --pretty=%H $start..$to -- $path)
nrefs=$(echo "$refs" | wc -w)

echo "Starting from: $(git show --oneline --no-patch $start)"
echo "Processing $nrefs commits"

for ref in $refs; do
    title=$(git show --pretty=%s --no-patch $ref)
    applied=$(git log --pretty=%s $start..$from -- $path | grep -F "$title" || true)
    if [ -n "$applied" ]; then
        echo "Already applied, skipping: $title"
        continue
    fi

    applied=$(git log --pretty=%s -- $path | grep -F "$title" || true)
    if [ -n "$applied" ]; then
        echo "Already applied, skipping: $title"
        continue
    fi

    git show --oneline --no-patch $ref
    while true; do
        read -p 'Apply? [Y/n/d/D/i]: ' apply
        if [ "$apply" = "n" ]; then
            break
        elif [ "$apply" = "d" ]; then
            git show $ref || true
        elif [ "$apply" = "D" ]; then
            git show --oneline  $ref -- $path || true
        elif [ "$apply" = "i" ]; then
            git show --oneline --no-patch $ref
            $SHELL || true
        elif [ "$apply" = "y" ] || [ -z "$apply" ]; then
            echo Applying...
            git cherry-pick -x $ref || $SHELL || true
            break
        fi
    done
done
