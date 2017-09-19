cd E:\Sandbox\linux_scripts
git add .
git commit -m "%date% %time%"
git remote add origin https://github.com/ichibsah/linux_scripts.git
git push -u origin master


git remote add upstream https://github.com/tiiiecherle/linux_scripts.git
git fetch upstream
git pull upstream master

pause
