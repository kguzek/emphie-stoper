function create_prod_branch() {
  git switch --orphan prod && echo "Created new production branch."
}

if [ ! -d "./build" ]; then
  echo "No build files to move."
  exit 1
fi

git switch prod || create_prod_branch

exit 0

# Remove all previously tracked files
git ls-files | xargs -r rm

# But restore .gitignore from main branch
git checkout main .gitignore

mv build/* build/.[!.]* .
rmdir build && echo "Moved build files." || exit 1

git add . && git commit -m "build latest app version" || exit 1
git push origin prod && echo "Successfully pushed new commit."
git switch main
