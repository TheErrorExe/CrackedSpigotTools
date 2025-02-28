#!/bin/bash

# TheErrorExe's Cracked Spigot Plugin Tools
# Automatic compilation of CoreProtect and PlotSquared

set -e

RED='\e[31m'
GREEN='\e[32m'
BLUE='\e[34m'
NC='\e[0m'

echo -e "${BLUE}========================================="
echo -e "${GREEN}   TheErrorExe's Cracked Spigot Tools   "
echo -e "${BLUE}=========================================${NC}\n"

echo -e "[TheErrorExe's Cracked Spigot Tools]: ${BLUE}Updating package lists and installing dependencies...${NC}"
sudo apt update && sudo apt install -y git openjdk-21-jdk maven gradle

echo -e "[TheErrorExe's Cracked Spigot Tools]: ${BLUE}Setting Java and Javac to JDK 21...${NC}"
sudo update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-21-openjdk-amd64/bin/javac

compile_coreprotect() {
    echo -e "[TheErrorExe's Cracked Spigot Tools]: ${BLUE}Compiling CoreProtect...${NC}"
    if [ ! -d "CoreProtect" ]; then
        git clone https://github.com/PlayPro/CoreProtect.git ./CoreProtect
    fi
    cd CoreProtect
    echo -e "[TheErrorExe's Cracked Spigot Tools]: ${BLUE}Patching CoreProtect...${NC}"
    sed -i '10s/22.4/23.2/' build.gradle
    sed -i '5s/22.4/23.2/' pom.xml
    sed -i '7s#<project.branch></project.branch>#<project.branch>master</project.branch>#' pom.xml
    echo -e "[TheErrorExe's Cracked Spigot Tools]: ${GREEN}CoreProtect patched successfully!${NC}"
    mvn clean package
    cd ..
    cp ./CoreProtect/target/CoreProtect-*.jar ./
    echo -e "[TheErrorExe's Cracked Spigot Tools]: ${GREEN}CoreProtect successfully compiled!${NC}"
}

compile_plotsquared() {
    echo -e "[TheErrorExe's Cracked Spigot Tools]: ${BLUE}Compiling PlotSquared...${NC}"
    if [ ! -d "PlotSquared" ]; then
        git clone https://github.com/IntellectualSites/PlotSquared.git ./PlotSquared
    fi
    cd PlotSquared
    gradle build
    cd ..
    cp ./PlotSquared/Bukkit/build/libs/plotsquared-bukkit-*-SNAPSHOT.jar ./
    echo -e "[TheErrorExe's Cracked Spigot Tools]: ${GREEN}PlotSquared successfully compiled!${NC}"
}

echo -e "[TheErrorExe's Cracked Spigot Tools]: ${BLUE}Select an option:${NC}"
echo -e "1) Compile CoreProtect"
echo -e "2) Compile PlotSquared"
echo -e "3) Compile both"
echo -e "4) Exit"
read -p "[TheErrorExe's Cracked Spigot Tools]: Enter your choice: " choice

case $choice in
    1) compile_coreprotect ;;
    2) compile_plotsquared ;;
    3) compile_coreprotect && compile_plotsquared ;;
    4) echo -e "[TheErrorExe's Cracked Spigot Tools]: ${RED}Exiting...${NC}"; exit 0 ;;
    *) echo -e "[TheErrorExe's Cracked Spigot Tools]: ${RED}Invalid option!${NC}" ;;
esac

echo -e "[TheErrorExe's Cracked Spigot Tools]: ${BLUE}Do you want to clean up the directories? (y/n)${NC}"
read -p "[TheErrorExe's Cracked Spigot Tools]: " cleanup_choice
if [[ "$cleanup_choice" == "y" || "$cleanup_choice" == "Y" ]]; then
    rm -rf CoreProtect PlotSquared
    echo -e "[TheErrorExe's Cracked Spigot Tools]: ${GREEN}Cleanup completed!${NC}"
else
    echo -e "[TheErrorExe's Cracked Spigot Tools]: ${BLUE}Skipping cleanup.${NC}"
fi

echo -e "[TheErrorExe's Cracked Spigot Tools]: ${GREEN}All selected plugins have been successfully compiled! JAR files are in the current directory.${NC}"
