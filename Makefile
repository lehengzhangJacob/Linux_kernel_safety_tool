CC = gcc
CFLAGS = -Wall -Wextra -g -I./src

SRC = src/main.c
OBJ = $(SRC:.c=.o)
TARGET = bin/kernel_analyzer

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)
