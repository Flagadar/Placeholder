UNAME_S = $(shell uname -s)

CC = clang
CFLAGS = -Wall
CFLAGS += -Ilibs/glfw/include -Ilibs/glad/include
LDFLAGS = libs/glad/src/glad.o libs/glfw/src/libglfw3.a -lm

SRC = $(wildcard src/*.c) $(wildcard src/**/*.c) $(wildcard src/**/**/*.c)
OBJ = $(SRC:.c=.o)
BIN = bin

ifeq ($(UNAME_S), Darwin)
	LDFLAGS += -framework OpenGL -framework IOKit -framework CoreVideo -framework Cocoa
endif

ifeq ($(UNAME_S), Linux)
	LDFLAGS += -lX11 -ldl -lpthread
endif

SRC  = $(wildcard src/**/*.c) $(wildcard src/*.c) $(wildcard src/**/**/*.c) $(wildcard src/**/**/**/*.c)
OBJ  = $(SRC:.c=.o)
BIN = bin

.PHONY: all libs clean

all: dirs libs game

dirs: all
	mkdir -p ./$(BIN)

libs:
	cd libs/glad && $(CC) -o src/glad.o -Iinclude -c src/glad.c
	cd libs/glfw && cmake . && make

run:
	$(BIN)/game

game: $(OBJ)
	$(CC) -o $(BIN)/game $^ $(LDFLAGS)

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -rf $(BIN) $(OBJ)
