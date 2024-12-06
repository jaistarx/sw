:: Git Clone Script
@echo off
:: Enable delayed variable expansion for array indexing
setlocal enabledelayedexpansion

:: Define the common parts of the repository URL
set "baseUrl=git@github.com:Advantasure-RAQ/"
set "suffix=.git"

:: Define repository names directly in the script (dynamic list)
set repoNames[0]=member-services
set repoNames[1]=mri
set repoNames[2]=mrr-processor
set repoNames[3]=mrr-services
set repoNames[4]=radv-app
set repoNames[5]=rightfax
set repoNames[6]=tepalert-db
set repoNames[7]=tepops-db
:: Add or remove repositories as needed
set /a repoCount=8

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
