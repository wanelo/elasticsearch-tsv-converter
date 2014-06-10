CONVERTER_NAME = elasticsearch-tsv-converter
UPLOAD_SCRIPT_NAME = upload.sh
GENERATOR_NAME = generate-raw-data
PROGRAMS = $(CONVERTER_NAME) $(GENERATOR_NAME)
CWARNINGFLAGS = -Wall -Wextra -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wcast-align -Wstrict-prototypes -Wstrict-overflow=5 -Wwrite-strings -Waggregate-return -Wcast-qual -Wswitch-default -Wswitch-enum -Wconversion -Wunreachable-code
CFLAGS = -std=c99 -O3 $(CWARNINGFLAGS)
BIN_PATH = /opt/local/bin
CURRENT_PATH = $(shell pwd)

all: clean test

converter:
	gcc convert.c $(CFLAGS) -o $(CURRENT_PATH)/$(CONVERTER_NAME)

generator:
	gcc generate.c $(CFLAGS) -o $(CURRENT_PATH)/$(GENERATOR_NAME)

install: converter
	ln -sf $(CURRENT_PATH)/$(CONVERTER_NAME) $(BIN_PATH)/$(CONVERTER_NAME)

test: converter
	./test.sh

benchmark: test generator
	time ./benchmark.sh 10000

clean:
	rm -f $(PROGRAMS)
	rm -rf benchmark/
