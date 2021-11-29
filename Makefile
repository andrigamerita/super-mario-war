TARGET = smw
TARGET_LE = leveledit

ifdef HOST
	SYSROOT := $(shell $(CC) --print-sysroot)
	SDL_CONFIG = $(SYSROOT)/usr/bin/sdl-config
	TARGET = smw.exe
	TARGET_LE = leveledit.exe
else
	CHAINPREFIX=/opt/miyoo
	CROSS_COMPILE=$(CHAINPREFIX)/bin/arm-miyoo-linux-uclibcgnueabi-
	CC = $(CROSS_COMPILE)gcc
	CXX = $(CROSS_COMPILE)g++
	STRIP = $(CROSS_COMPILE)strip
	SYSROOT     := $(shell $(CC) --print-sysroot)
	SDL_CFLAGS  := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
	SDL_LIBS    := $(shell $(SYSROOT)/usr/bin/sdl-config --libs)
endif

CFLAGS=-Ofast -Wall -I. -DLINUXFUNC -DPREFIXPATH=\"data\" $(SDL_CFLAGS)
LDFLAGS=-lSDL_image -lSDL_mixer -lpng -lz -lSDL -lSDL_gfx -flto -s $(SDL_LIBS)

COMMON_OBJS:=/tmp/smw/MapList.o /tmp/smw/SFont.o /tmp/smw/dirlist.o \
	/tmp/smw/eyecandy.o /tmp/smw/gfx.o /tmp/smw/global.o /tmp/smw/input.o \
	/tmp/smw/map.o /tmp/smw/movingplatform.o /tmp/smw/path.o \
	/tmp/smw/savepng.o \
	/tmp/smw/linfunc.o \
	/tmp/smw/wiz.o \
	/tmp/smw/scaler.o
SMW_OBJS:= /tmp/smw/HashTable.o /tmp/smw/ai.o /tmp/smw/gamemodes.o /tmp/smw/main.o \
	/tmp/smw/map.o /tmp/smw/menu.o /tmp/smw/object.o /tmp/smw/player.o \
	/tmp/smw/sfx.o /tmp/smw/splash.o /tmp/smw/uicontrol.o /tmp/smw/uimenu.o
LEVELEDIT_OBJS:=/tmp/smw/leveleditor.o

all: $(TARGET) $(TARGET_LE)

/tmp/smw/%.o : src/%.cpp
	mkdir -p /tmp/smw
	$(CXX) $(CFLAGS) -o $@ -c $<

$(TARGET) : $(COMMON_OBJS) $(SMW_OBJS)
	mkdir -p /tmp/smw
	$(CXX) $(CFLAGS) $^ $(LDFLAGS) -o $@

$(TARGET_LE) : $(COMMON_OBJS) $(LEVELEDIT_OBJS)
	mkdir -p /tmp/smw
	$(CXX) $(CFLAGS) $^ $(LDFLAGS) -o $@

/tmp/smw/SFont.o : src/SFont.c
	$(CC) $(CFLAGS) -o $@ -c $<

/tmp/smw/SDLMain.o : macosx/SDLMain.m
	$(CC) $(CFLAGS) -o $@ -c $<

clean :
	rm -rf /tmp/smw/* $(TARGET) $(TARGET_LE) $(TARGET).exe $(TARGET_LE).exe
