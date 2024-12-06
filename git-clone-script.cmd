:: Git Clone Script
@echo off
:: Enable delayed variable expansion for array indexing
setlocal enabledelayedexpansion

:: Define the common parts of the repository URL
set "baseUrl=https://github.com/user/"
set "suffix=.git"

:: Define repository names directly in the script (dynamic list)
set repoNames[0]=repo1
set repoNames[1]=repo2
set repoNames[2]=repo3
:: Add or remove repositories as needed

:: Add total number of repositories
set /a repoCount=3

:: Default branch to switch to
set "defaultBranch=dev"

:: Calculate the last index of the repoNames array
set /a repoCountFromZero=!repoCount!-1

:: Output Header
echo ============================================
echo       Cloning Repositories and Switching Branches
echo ============================================
echo.

:: Show all repository names to be cloned with numbering (starting from 1)
echo Repositories to be cloned:
echo --------------------------------------------
for /L %%i in (0,1,!repoCountFromZero!) do (
    set "repoName=!repoNames[%%i]!"
    set /a repoNumber=%%i+1
    echo [!repoNumber!] !repoName!
)
echo --------------------------------------------

:: Ask for user confirmation before starting cloning
set /p userInput="Do you want to proceed with cloning these repositories? (Y/N): "
if /I not "!userInput!"=="Y" (
    echo Exiting script. No repositories will be cloned.
    exit /B
)

:: Ask for the branch to switch to, default is dev
set /p branchInput="Enter the branch to switch to after cloning (press Enter for default 'dev'): "
if "!branchInput!"=="" (
    set "branchInput=%defaultBranch%"
)

echo --------------------------------------------
echo Branch to switch to: !branchInput!

:: Loop through the array and construct full URLs, then clone each repository
for /L %%i in (0,1,!repoCountFromZero!) do (
    set "repoName=!repoNames[%%i]!"
    set "repoUrl=%baseUrl%!repoName!%suffix%"
    set /a repoNumber=%%i+1
	echo --------------------------------------------
    echo [!repoNumber!] Cloning repository: !repoName!...
    echo --------------------------------------------

    git clone !repoUrl!
    
    :: Check if the clone was successful
    if errorlevel 1 (
        echo [ERROR] Failed to clone !repoUrl! >> error.log
        echo [ERROR] Failed to clone !repoUrl!
    ) else (
        echo [SUCCESS] Successfully cloned !repoUrl!
        :: Extract the directory name (repo name in this case)
        set "repoDir=!repoName!"
        echo Switching to branch '!branchInput!' in directory !repoDir!...
        cd !repoDir!
        
        :: Switch to the specified branch
        git switch !branchInput!
        
        if errorlevel 1 (
            echo [ERROR] Failed to switch to branch '!branchInput!' in !repoDir! >> error.log
            echo [ERROR] Failed to switch to branch '!branchInput!' in !repoDir!
        ) else (
            echo [SUCCESS] Successfully switched to branch '!branchInput!' in !repoDir!
        )
        echo --------------------------------------------
        cd ..
    )
)

:: End output
echo ============================================
echo       All repositories processed!
echo ============================================
echo.
echo For error logs, check error.log.
pause
