#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

cd public

git add .


msg="Rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

git push https://$USER_NAME:$PASSWORD@github.com/nreckle/nreckle.github.io.git --all
