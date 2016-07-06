#!/bin/bash
# inspired by https://gist.github.com/Stebalien/d4a32c4abc03376db903

git config --global user.name 'build-bot'
git config --global user.email 'alexhirschberg97@gmail.com'

# Check out to the pushed branch, since codeship checks out the latest commit
# in detached mode
git checkout $CI_BRANCH

# set-branches adds the gh-pages branch to the refs that git looks at when
# talking to the remote. This is necessary because codeship clones the repo
# with the --branch option, which specifies a specific branch to look at
git remote set-branches --add origin gh-pages
git remote update
git checkout gh-pages # initialize gh-pages branch
git checkout -

# not necessary anymore :P
set -e
[[ "$(git symbolic-ref --short HEAD)" == "master" ]] || exit 0

dir="$(pwd)"
tmp="$(mktemp -d)"
last_rev="$(git rev-parse HEAD)"
last_msg="$(git log -1 --pretty=%B)"

trap "cd \"$dir\"; rm -rf \"$tmp\"" EXIT

echo "Building project..."
pub build

echo "Cloning into a temporary directory..."
git clone $dir $tmp
cd "$tmp"
echo "Copying build files"
git checkout gh-pages

# Clean and replace build
git rm -q --ignore-unmatch -rf .
cp -a $dir/{build/web/*,build_json.rb,lessons,Gemfile} .
git checkout HEAD Makefile # regenerate Makefile from current head

# Build existing lesson files
mkdir 'static/'

# setup ruby
source "$HOME/.rvm/scripts/rvm"
rvm install ruby 2.3.1
rvm use 2.3.1
bundle install
GEM_PATH=~/cache/bundler:$GEM_PATH # this took far too long to figure out...
make lessons

git add .
echo `ls`
git commit -m "Built commit '$last_msg'" -m "commit: $last_rev"
git push -u origin gh-pages # pushes to original local repo
echo "Done."
cd $dir
git checkout gh-pages --force
git push -u origin gh-pages $FINAL_PAGES_PUSH_FLAGS # pushes to github
