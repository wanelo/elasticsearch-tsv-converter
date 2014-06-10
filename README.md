elasticsearch-tsv-converter
===========================

Converts from TSV to ElasticSearch's not-JSON Bulk API format.

The format of the TSV is assumed to be:

    parentId userId collectionId timeStamp.timeStampMilliseconds

The SQL command to extact these could be (for example):

    psql -c "COPY (SELECT parent_id, user_id, collection_id, extract(epoch from date_trunc('milliseconds', created_at)) FROM table_name)"

## Installation

To install `elasticsearch-tsv-converter` to `/opt/local/bin` on SmartOS:

    $ make install

## Usage

To build the tool:

    $ make

To convert TSV data and upload it to a local elasticsearch instance:

    $ cat <file> | ./elasticsearch-tsv-converter <index-name> <type-name> | curl -XPOST localhost:9200/_bulk --data-binary @-

To distribute a block of data across a cluster, make sure to copy this application to `/opt/local/lib/elasticsearch-tsv-converter`, then `make install` and run:

    $ ssh -A <main-database> -C '<sql command> > /var/tmp/dump.tsv'
    $ ssh -A <main-database> -C 'mkdir -p /var/tmp/dump-split; split -n <cluster-size> /var/tmp/dump.tsv /var/tmp/dump-split/part-'
    $ ssh -A <main-database> -C 'for index in {1..8}; do rsync -arvce "ssh -o StrictHostKeyChecking=no" `find /var/tmp/dump-split/* | head -n${index} | tail -1` <user>@<cluster>${index}:/var/tmp/dump.tsv & done; wait'
    $ for index in {1..8}; do ssh <user>@<cluster>${index} -C '/opt/local/lib/elasticsearch-tsv-converter/upload.sh <elasticsearch-index> <elasticsearch-type> 100000 /var/tmp/dump.tsv /var/tmp/dump-split > /var/log/elasticsearch-tsv-converter.log &'; done
    $ for index in {1..8}; do ssh <user>@<cluster>${index} -C 'tail -f /var/log/elasticsearch-tsv-converter.log' &; done

## Benchmarking

    $ make benchmark

## Contributing

1. Fork it ( https://github.com/raedoc/elasticsearch-tsv-converter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
