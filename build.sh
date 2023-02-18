function create_prod_branch() {
  git switch --orphan prod && echo "Created new production branch."
}

git switch prod || create_prod_branch

# Remove all previously tracked files
git ls-files | xargs -r rm

# But restore .gitignore from main branch
git checkout main .gitignore

mv build/* . && rmdir build && echo "Moved build files."

git add . && git commit -m "build latest app version" || exit 1
git push origin prod && echo "Successfully pushed new commit."
git switch main
