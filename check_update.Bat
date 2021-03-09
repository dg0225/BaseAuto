@REM git reset --hard
git update-index --assume-unchanged Config/main.ini
git fetch
git rebase
git pull
git log --max-count=3
pause