#!/bin/bash

CONVERTER=./elasticsearch-tsv-converter
GENERATOR=./generate-raw-data
SAMPLE_PATH=`cd $(dirname $0) && pwd`/benchmark
SAMPLE_SIZE=$1
HOST=localhost:9200
INDEX=wat-$RANDOM
TYPE=taco
PARENT=beans

if [ -z "$SAMPLE_SIZE" ]; then
  echo "Usage: $0 <sample-size>"
  exit 1
fi

function reset() {
  rm -rf $SAMPLE_PATH/sample
  mkdir -p $SAMPLE_PATH/sample
  curl -s -o /dev/null -XPUT $HOST/$INDEX -d"{
    settings : {
      index : {
        refresh_interval : -1
      }
    },
    mappings : {
      $PARENT: {},
      $TYPE: {
        _parent: {
          type: \"$PARENT\"
        },
        _timestamp: {
          enabled: true,
          path: \"created_at\"
        }
      }
    }
  }"
}

function makeSample() {
  local TOTAL_SIZE=$(($1 * 10))
  echo "Generating $TOTAL_SIZE entries"
  $GENERATOR $TOTAL_SIZE > $2
}

function cleanup () {
  curl -s -o /dev/null -XDELETE $HOST/$INDEX
}

reset
makeSample $SAMPLE_SIZE $SAMPLE_PATH/sample.tsv
PATH="$PATH:." ./upload.sh $INDEX $TYPE $SAMPLE_SIZE $SAMPLE_PATH/sample.tsv $SAMPLE_PATH/sample
cleanup
echo "       ----------         ---------         --------"
