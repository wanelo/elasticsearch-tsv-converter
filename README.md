elasticsearch-tsv-converter
===========================

Converts from TSV to ElasticSearch's not-JSON Bulk API format.

The format of the TSV is assumed to be:

    parentId userId collectionId timeStamp.timeStampMilliseconds

The SQL command to extact these could be (for example):

    psql -c "COPY (SELECT parent_id, user_id, collection_id, extract(epoch from date_trunc('milliseconds', created_at)) * 1000 FROM table_name)"

## Usage

To build the tool:

    $ make

To convert TSV data and upload it to a local elasticsearch instance:

    $ cat <file> | ./elasticsearch-tsv-converter <index-name> <type-name> | curl -XPOST localhost:9200/_bulk --data-binary @-

## Installation

To install it on SmartOS:

    $ make install

## Benchmarking

    $ make benchmark

## Contributing

1. Fork it ( https://github.com/raedoc/elasticsearch-tsv-converter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
