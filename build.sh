#!/usr/bin/env bash
DIR_BASE=${PWD}
DIR_TC="TrinityCore"
DIR_TOOLS="tc_tools"
DIR_BUILD_DB="build_db"
DIR_DB="db"
DIR_EXTRACT="extractor"
DIR_AUTHSERVER="authserver"
DIR_WORLDSERVER="worldserver"
DIR_ARTIFACTS="artifacts"
URL_TC="https://github.com/TrinityCore/TrinityCore.git"
URL_TDB="http://www.trinitycore.org/f/files/getdownload/1266-legacy-tdb-335-full/"
VERSION="3.3.5"
CONTAINER_BUILD="dockerwow:temp"
CONTAINER_MARIADB_BUILD="dockerwow:mariadb_temp"
CONTAINER_MYSQL="dockerwow:db"
CONTAINER_EXTRACT="dockerwow:extractor"

print_section() {
  printf "\n# $1\n"
}

print_status () {
  printf "\n## $1\n\n"
}

print_usage() {
  printf "Usage: ./build.sh [OPTION]...\n"
  printf "Builds TrinityCore docker containers.\n\n"

  printf "Flags:\n"
  printf "  -v\tThe version of TrinityCore to build. (Default: 3.3.5)\n"
  printf "    \tNote: currently only 3.3.5 correctly builds worldserver and authserver"
  printf "  -l\tList the available TrinityCore Versions.\n"
  printf "  -h\tPrint this help message.\n"
}

list_versions() {
  printf "Available TrinityCore versions:\n\n"
  printf "  6.x\n"
  printf "  4.3.4\n"
  printf "  3.3.5 (default)\n"
}

set_version() {
  VERSION=$1
  case $1 in
    6.x)
      URL_TDB="http://www.trinitycore.org/f/files/getdownload/1306-tdb-6-full/"
      return 0
      ;;
    4.3.4)
      URL_TDB="http://www.trinitycore.org/f/files/getdownload/1305-legacy-tdb-full-434/"
      return 0
      ;;
    3.3.5)
      # Defaults already set
      return 0
      ;;
    *)
      printf "Invalid TrinityCore Version: $1\n"
      list_versions
      exit 1
  esac
}

# Get arguments
while getopts ":c:v:lh" opt; do
  case ${opt} in
    v)
      set_version $OPTARG
      ;;
    l)
      list_versions
      exit 0
      ;;
    h)
      print_usage
      exit 0
      ;;
    \?)
      printf "Invalid argument: -$OPTARG\n\n" >&2
      print_usage
      exit 1
      ;;
  esac
done

OUTPUT="${DIR_ARTIFACTS}/${VERSION}"
echo $OUTPUT
mkdir -p ${OUTPUT}

print_section "GitHub"
  print_status "Cloning TrinityCore Repository"
    git clone -b ${VERSION} --depth 1 ${URL_TC} ${DIR_TC}
print_section "Building"
  print_status "Creating Docker Container"
    cp build/Dockerfile .
    docker build -t "${CONTAINER_BUILD}" .
    rm -rf Dockerfile
  print_status "Building TrinityCore"
    mkdir -p ${DIR_TOOLS}
    docker run -it --rm -v ${PWD}/${DIR_TOOLS}:/build ${CONTAINER_BUILD}
  print_status "Deleting Build Container"
    docker rmi "${CONTAINER_BUILD}"
print_section "Building Database files"
  print_status "Moving sql files into place"
    cp -R TrinityCore/sql ${DIR_BUILD_DB}
  print_status "Downloading TDB data"
    mkdir -p ${DIR_BUILD_DB}/sql
    wget ${URL_TDB} && \
      mv index.html ${DIR_BUILD_DB}/sql && \
      cd ${DIR_BUILD_DB}/sql && \
      7z x index.html && \
      rm index.html
    cd ${DIR_BASE}
  print_status "Building mariadb build container"
    cd ${DIR_BUILD_DB}
    docker build -t ${CONTAINER_MARIADB_BUILD} .
  print_status "Starting mariadb build container"
    mkdir -p data
    MARIA_DB=$(docker run -dP --name trinitycore_sql -v ${PWD}/data:/var/lib/mysql -e "MYSQL_ROOT_PASSWORD=GreatBeyond" ${CONTAINER_MARIADB_BUILD})
    sleep 15s #wait for DB to come up
    echo "Started ${MARIA_DB}"
  print_status "Setting up database"
    docker run -it --rm --link trinitycore_sql:mysql -v ${PWD}/data:/data ${CONTAINER_MARIADB_BUILD} ./build.sh
  print_status "Deleting mariadb build container"
    docker kill ${MARIA_DB}
    docker rm ${MARIA_DB}
    docker rmi ${CONTAINER_MARIADB_BUILD}
    rm -rf sql
    cd ${DIR_BASE}
  print_status "Cleaning up files"
    rm -rf ${DIR_BUILD_DB}/sql
print_section "Creating mysql container"
  print_status "Generating Artifact Directory"
    cp -R ${DIR_DB} ${OUTPUT}
  print_status "Moving generated sql data into place"
    mv ${DIR_BUILD_DB}/data ${OUTPUT}/${DIR_DB}/
print_section "Creating extractor container"
  print_status "Moving files into place"
    cp -R ${DIR_EXTRACT} ${OUTPUT}/${DIR_EXTRACT}
    cp ${DIR_TOOLS}/bin/mapextractor \
       ${DIR_TOOLS}/bin/vmap4extractor \
       ${DIR_TOOLS}/bin/vmap4assembler \
       ${DIR_TOOLS}/bin/mmaps_generator \
       ${OUTPUT}/${DIR_EXTRACT}
print_section "Creating authserver container"
  print_status "Moving files into place"
    cp -R ${DIR_AUTHSERVER} ${OUTPUT}/${DIR_AUTHSERVER}
    cp ${DIR_TOOLS}/bin/authserver ${OUTPUT}/${DIR_AUTHSERVER}
print_section "Creating worldserver container"
  print_status "Moving files into place"
    cp -R ${DIR_WORLDSERVER} ${OUTPUT}/${DIR_WORLDSERVER}
    cp ${DIR_TOOLS}/bin/worldserver ${OUTPUT}/${DIR_WORLDSERVER}
print_section "Cleanup"
  print_status "Deleting TrinityCore Repository"
    rm -rf ${DIR_TC}
  print_status "Cleaning up generated tools"
    rm -rf ${DIR_TOOLS}
    rm ${DIR_AUTHSERVER}/authserver
    rm ${DIR_WORLDSERVER}/worldserver
