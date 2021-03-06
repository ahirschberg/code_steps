#!/bin/bash

# Ensure there is a branch set to build to
if [ -z $TARGET_BRANCH ]
then
    >&2 echo -e "\e[31mERROR: TARGET_BRANCH env var must be set\e[39m"
    exit 1
fi

git config --global user.name 'build-bot'
git config --global user.email 'alexhirschberg97@gmail.com'

# Check out to the pushed branch, since codeship checks out the latest commit
# in detached mode
git checkout $CI_BRANCH


# install latest pub if not installed or version <1.18
if (! hash pub 2>/dev/null) \
    || dpkg --compare-versions \
            "$(pub --version | awk '{print $2}')" \
            'lt' \
            '1.18'
            then
    echo "Upgrading pub"
    wget https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip
    unzip -o -qq dartsdk-linux-x64-release.zip -d ~
fi

# set-branches adds the branch to the refs that git looks at when
# talking to the remote. This is necessary because codeship clones the repo
# with the --branch option, which specifies a specific branch to look at
initialize_branch() {
    if [ -z "$1" ]
    then
        echo "ERROR: branch name must not be zero length"
    else
        git remote set-branches --add origin $1
        git remote update
        git checkout -f $1 # initialize $TARGET_BRANCH on our remote
        git checkout -
    fi
}

initialize_branch $TARGET_BRANCH

set -e
[[ "$(git symbolic-ref --short HEAD)" == "master" ]] || exit 0

dir="$(pwd)"
tmp="$(mktemp -d)"
last_rev="$(git rev-parse HEAD)"
last_msg="$(git log -1 --pretty=%B)"

trap "cd \"$dir\"; rm -rf \"$tmp\"" EXIT

echo "Building project..."
pub get
pub build

echo "Cloning into a temporary directory..."
git clone $dir $tmp
cd "$tmp"

echo "Copying build files"
git checkout $TARGET_BRANCH
git status

# Clean and replace build
git rm -q --ignore-unmatch -rf .
cp -a $dir/build/web .
git checkout HEAD -- .gitignore # regenerate from current head

git add .
git commit -m "Commit '$last_rev' built to js" -m "Original commit: $last_msg" -m ":runner: *This commit was created automatically*" || true
git push -u origin $TARGET_BRANCH || true # pushes to original local repo
echo "Done and ready to push to github."
cd $dir
git checkout --force $TARGET_BRANCH || true
git push -u origin $TARGET_BRANCH $GH_PUSH_FLAGS || true # pushes to github

if [ "$MIRROR_TO_PAGES" == '1' ]
then # from http://stackoverflow.com/a/13102849/5927655
    initialize_branch gh-pages
    git branch -D gh-pages
    git checkout -f --orphan gh-pages
    git add -A  # Add all files and commit them
    git commit -m ":memo: Copy of latest master-js commit." -m "Original commit: $last_rev"
    git push -uf origin gh-pages $GH_PUSH_FLAGS
fi

