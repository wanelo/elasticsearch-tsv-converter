CONVERTER_NAME = elasticsearch-tsv-converter
GENERATOR_NAME = generate-raw-data
PROGRAMS = $(CONVERTER_NAME) $(GENERATOR_NAME)

all: clean test

converter:
	gcc convert.c -o $(CONVERTER_NAME)

generator:
	gcc generate.c -o $(GENERATOR_NAME)

install: converter
	cp $(CONVERTER_NAME) /opt/local/bin

test: converter
	./test.sh

benchmark: test generator
	time ./benchmark.sh 10000

clean:
	rm -f $(PROGRAMS)
	rm -rf benchmark/
