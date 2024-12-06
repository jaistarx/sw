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
set /a repoCount=3

:: Output Header
echo ============================================
echo       Cloning Repositories and Switching Branches
echo ============================================
echo.

:: Show all repository names to be cloned with numbering (starting from 1)
echo Repositories to be cloned:
echo --------------------------------------------
for /L %%i in (0,1,%repoCount%-1) do (
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

:: Loop through the array and construct full URLs, then clone each repository
for /L %%i in (0,1,%repoCount%-1) do (
    set "repoName=!repoNames[%%i]!"
    set "repoUrl=%baseUrl%!repoName!%suffix%"
    echo Cloning repository: !repoName!...
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
        echo Switching to 'dev' branch in directory !repoDir!...
        cd !repoDir!
        
        :: Switch to 'dev' branch
        git switch dev
        
        if errorlevel 1 (
            echo [ERROR] Failed to switch to 'dev' branch in !repoDir! >> error.log
            echo [ERROR] Failed to switch to 'dev' branch in !repoDir!
        ) else (
            echo [SUCCESS] Successfully switched to 'dev' branch in !repoDir!
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
