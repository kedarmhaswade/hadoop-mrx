#!/bin/bash
# This script sets up hadoop so that the word count example can be run without hassles.
# 1. Set up Maven to produce the correct jar file with appropriate entries.
# 2. Makes sure hadoop commands can be run.
# 3. Sees if there are some files in the input folder.
# 4. Invokes the WordCount2 program to do its job.
set -o nounset
#set -o errexit

# All scripts assume functions in ${HOME}/scripts/bash_functions.sh
source ${HOME}/scripts/bash_functions.sh

# our input directory is going to be txtbooks
MY_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
INPUT_DIR=${MY_DIR}/txtbooks
OUTPUT_DIR=${MY_DIR}/wordcount
HADOOP_JAR=${MY_DIR}/target/hadoop-mr-ex-1.0-SNAPSHOT-jar-with-dependencies.jar
HDFS_INPUT_DIR=wordcount2
build_maven () {
  cd ${MY_DIR}
  mvn assembly:assembly -Dmain.class=org.kedar.mrx.WordCount2 > /dev/null 2>&1
  if [[ $? -ne 0 ]]
  then
    echo "Maven build failed, look into maven hell, exiting for now ..."
    exit 1
  fi
}

ensure_input_output () {
    if [[ ! -d ${INPUT_DIR} ]]
    then
      mkdir -p ${INPUT_DIR}
    fi
    NFILES=$(ls -laq ${INPUT_DIR} | wc -l)
    if [[ NFILES -ge 10 ]]
    then
        # no need to download the files
        echo "we have ${NFILES} files here, so no need to download"
    else
      echo "downloading gutenberg files ..."
      ${MY_DIR}/download-gutenberg.sh 0 1
    fi
    mkdir -p ${OUTPUT_DIR}
}
run_hadoop_jar () {
  if [[ -d ${OUTPUT_DIR} ]]
  then
    \rm -rf ${OUTPUT_DIR}
  fi
  # ensure that the input files are there in hdfs
  hdfs dfs -ls ${HDFS_INPUT_DIR}
  if [[ $? -ne 0 ]]
  then
    echo "hdfs does not recognize the input directory yet, running hdfs dfs -mkdir"
    hdfs dfs -mkdir ${HDFS_INPUT_DIR}
  fi
  echo "copying input files into HDFS"
  hdfs dfs -copyFromLocal ${INPUT_DIR} ${HDFS_INPUT_DIR}
  mkdir -p ${OUTPUT_DIR}
  hadoop jar ${HADOOP_JAR} input output
}

build_maven
ensure_input_output
run_hadoop_jar