@echo off
:: Define an array of repository URLs
setlocal enabledelayedexpansion
set "repos[0]=https://github.com/user/repo1.git"
set "repos[1]=https://github.com/user/repo2.git"
set "repos[2]=https://github.com/user/repo3.git"

:: Loop through the array and clone each repository
echo Cloning repositories and switching to 'dev' branch...
for /L %%i in (0,1,2) do (
    set "repo=!repos[%%i]!"
    echo Cloning !repo!
    git clone !repo!
    if errorlevel 1 (
        echo Failed to clone !repo!
    ) else (
        echo Successfully cloned !repo!
        :: Extract the repository name from the URL (last part before .git)
        for %%F in (!repo!) do set "repoDir=%%~nF"
        echo Switching to 'dev' branch in folder !repoDir!
        cd !repoDir!
        git switch dev
        if errorlevel 1 (
            echo Failed to switch to 'dev' branch. Ensure it exists.
        ) else (
            echo Successfully switched to 'dev' branch.
        )
        cd ..
    )
)
echo All repositories processed!
pause
