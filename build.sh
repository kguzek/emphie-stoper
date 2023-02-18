# Terminate after the first failed command
set -e

git branch -D prod && echo "Deleted production branch."
git switch --orphan prod && echo "Created new production branch."
mv build/* . && echo "Moved build files."
git checkout main .gitignore

git add .
git commit -m "build latest app version"
git push origin prod && echo "Successfully pushed new commit."
git switch main
rmdir build
