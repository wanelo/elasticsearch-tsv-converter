#!/bin/bash

CONVERTER=`which elasticsearch-tsv-converter`

INDEX=$1
TYPE=$2
SAMPLE_SIZE=$3
SAMPLE_FILE=$4
SAMPLE_SPLIT_DIRECTORY=$5
HOST=localhost:9200

function splitSample() {
  split -a 10 -l $1 $2 $3/part-
}

function convertAndUpload() {
  for file in $1/part-*
  do
    cat $file | $CONVERTER $INDEX $TYPE | time curl -o /dev/null -s -XPOST $HOST/_bulk --data-binary @-
  done
}

splitSample $SAMPLE_SIZE $SAMPLE_FILE $SAMPLE_SPLIT_DIRECTORY
convertAndUpload $SAMPLE_SPLIT_DIRECTORY
