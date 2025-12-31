CC = gcc
CFLAGS = -Wall -Wextra -g -I./src

SRC = src/main.c src/analyzer.c src/utils.c
OBJ = $(SRC:.c=.o)
TARGET = analyzer

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)

test: $(TARGET)
	./$(TARGET) test/sample_kernel.c
