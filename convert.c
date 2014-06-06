#include <stdio.h>
#include <string.h>

const char *BASE_62_LOOKUP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

void reverse(char s[]) {
  int length, c, i, j;
  length =  strlen(s);
  for (i = 0, j = length - 1; i < j; i++, j--) {
    c = s[i];
    s[i] = s[j];
    s[j] = c;
  }
}

void printBase62(unsigned long number, FILE *stream) {
  char str[12];
  int index = 0;
  do {
    str[index++] = BASE_62_LOOKUP[number % 62];
    number = number / 62;
  } while (number > 0);
  str[index]='\0';
  reverse(str);
  fputs(str,stream);
}

void printCompositeId(FILE *stream, unsigned long parentId, unsigned long userId, unsigned long collectionId) {
  printBase62(parentId, stream);
  fputc('-', stream);
  printBase62(userId, stream);
  fputc('-', stream);
  printBase62(collectionId, stream);
}

void printIndex(char *indexName, char *typeName, unsigned long parentId, unsigned long userId, unsigned long collectionId){
  fprintf(stdout, "{\"index\":{\"_index\":\"%s\",\"_type\":\"%s\",\"_id\":\"", indexName, typeName);
  printCompositeId(stdout, parentId, userId, collectionId);
  fprintf(stdout, "\",\"_parent\":\"%lu\"}}\n", parentId);
}

void printData(unsigned long userId, unsigned long collectionId, unsigned long timeStamp, unsigned long timeStampMilliseconds){
  fprintf(stdout, "{\"user_id\":\"%lu\",\"collection_id\":\"%lu\",\"created_at\":\"%lu%03lu\"}\n", userId, collectionId, timeStamp, timeStampMilliseconds);
}

void handleLine(char *indexName, char *typeName, char *line){
  unsigned long parentId, userId, collectionId, timeStamp, timeStampMilliseconds;
  if (sscanf(line, "%lu %lu %lu %lu.%lu", &parentId, &userId, &collectionId, &timeStamp, &timeStampMilliseconds) == 5){
    printIndex(indexName, typeName, parentId, userId, collectionId);
    printData(userId, collectionId, timeStamp, timeStampMilliseconds);
  }
}

void getInput(char *indexName, char *typeName){
  char *line = NULL; // unallocated pointer
  size_t linecap = 0;
  while (getline(&line, &linecap, stdin) > 0){
    handleLine(indexName, typeName, line);
  }
}

int main(int argc, char **argv){
  if (argc < 3) {
    fprintf(stderr, "Usage: %s <index-name> <type-name>\n", argv[0]);
    return 1;
  }

  getInput(argv[1], argv[2]);
  return 0;
}
