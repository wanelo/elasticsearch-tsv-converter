#!/bin/bash

CONVERT=./elasticsearch-tsv-converter

function assert_equal() {
  if [[ "$1" != "$2" ]]
  then
    echo "expected $1 to equal $2, but did not"
  else
    echo "passed"
  fi
}

function test() {
  local actual=`cat test.tsv | $CONVERT wat taco`
  read -r -d '' expected <<EOF
{"index":{"_index":"wat","_type":"taco","_id":"2-3-4","_parent":"2"}}
{"user_id":"3","collection_id":"4","created_at":"1401887869000"}
{"index":{"_index":"wat","_type":"taco","_id":"Gccl-HvCm-17MnC","_parent":"3961723"}}
{"user_id":"4271476","collection_id":"16532250","created_at":"1401887869000"}
EOF
  assert_equal "$actual" "$expected"
}

test
