:: Git Clone Script
@echo off
:: Enable delayed variable expansion for array indexing
setlocal enabledelayedexpansion

:: Default values for the common parts of the repository URL
set "defaultBaseUrl=https://github.com/user/"
set "defaultSuffix=.git"

:: Ask the user for base URL and suffix
set /p userBaseUrl="Enter the base URL (press Enter for default '%defaultBaseUrl%'): "
if "!userBaseUrl!"=="" (
    set "baseUrl=%defaultBaseUrl%"
) else (
    set "baseUrl=!userBaseUrl!"
)

set /p userSuffix="Enter the suffix (press Enter for default '%defaultSuffix%'): "
if "!userSuffix!"=="" (
    set "suffix=%defaultSuffix%"
) else (
    set "suffix=!userSuffix!"
)

:: Ask the user for repository names (space-separated list)
set /p repoNamesInput="Enter repository names separated by space (e.g: repo1 repo2 repo3): "
set repoNames=%repoNamesInput%

:: Default branch to switch to
set "defaultBranch=dev"

:: Output Header
echo.
echo =======================================================
echo       Cloning Repositories and Switching Branches
echo =======================================================
echo.
echo Base URL: %baseUrl%
echo.
echo Suffix: %suffix%
echo.
:: Show all repository names to be cloned with numbering (starting from 1)
echo Repositories to be cloned:
echo -------------------------------------------------------
set /a repoNumber=1
for %%r in (%repoNames%) do (
    set "repoUrl=%baseUrl%%%r%suffix%"
    echo [!repoNumber!] %%r - !repoUrl!
    set /a repoNumber+=1
)
echo -------------------------------------------------------
echo.
echo =======================================================
echo.

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

echo.
echo -------------------------------------------------------
echo Branch to switch after cloning: !branchInput!
echo -------------------------------------------------------

:: Loop through the repoNames and clone repositories
set /a repoNumber=1
for %%r in (%repoNames%) do (
    set "repoName=%%r"
    set "repoUrl=%baseUrl%%%r%suffix%"
	echo.
    echo -------------------------------------------------------
    echo [!repoNumber!] Cloning repository: !repoName! - !repoUrl!
    echo -------------------------------------------------------

    git clone !repoUrl!
    
    :: Check if the clone was successful
    if errorlevel 1 (
        echo [ERROR] Failed to clone !repoUrl! >> error.log
        echo [ERROR] Failed to clone !repoUrl!
    ) else (
        echo [SUCCESS] Successfully cloned !repoUrl!
        echo Switching to branch '!branchInput!' in directory !repoName!
        cd !repoName!
        
        :: Switch to the specified branch
        git switch !branchInput!
        
        if errorlevel 1 (
            echo [ERROR] Failed to switch to branch '!branchInput!' in !repoName! >> error.log
            echo [ERROR] Failed to switch to branch '!branchInput!' in !repoName!
        ) else (
            echo [SUCCESS] Successfully switched to branch '!branchInput!' in !repoName!
        )
        echo -------------------------------------------------------
        cd ..
    )
    set /a repoNumber+=1
)

:: End output
echo =======================================================
echo       All repositories processed!
echo =======================================================
echo.
echo For error logs, check error.log.
pause
