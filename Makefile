PLATFORMS=linux macosx mingw32 emscripten
BUILDDIR=build
TARGETNAME=dose2
TARGET=$(BUILDDIR)/$(TARGETNAME)$(TARGETSUFFIX)
CC=cc
STRIP=strip
SDLCFLAGS=`$(SDLPREFIX)sdl-config --cflags`
SDLLIBS=`$(SDLPREFIX)sdl-config --libs`
FLAGS=
CFLAGS=-DINTEL -O2 -ffast-math $(SDLCFLAGS) $(FLAGS)
LDLIBS=-lm $(SDLLIBS) $(FLAGS)

none:
	@echo "Please do 'make PLATFORM' where PLATFORM is one of the following:"
	@echo "  $(PLATFORMS)"

objs = src/alue.o \
	   src/argb.o \
	   src/blob.o \
	   src/demo.o \
	   src/layer.o \
	   src/line.o \
	   src/main.o \
	   src/obu2d.o \
	   src/ogdecode.o \
	   src/palette.o \
	   src/schaibe.o \
	   src/taso.o

mingw32: CC = i686-w64-mingw32-gcc
mingw32: STRIP = i686-w64-mingw32-strip
mingw32: TARGETSUFFIX = .exe
mingw32: SDLPREFIX = src/vendor/mingw32/

macosx: SDLPREFIX = /usr/local/bin/

mingw32: linux
	cp $(SDLPREFIX)SDL12/bin/SDL.dll $(BUILDDIR)/SDL.dll

macosx: linux

emscripten: CC = emcc
emscripten: STRIP = echo
emscripten: TARGETNAME = index
emscripten: TARGETSUFFIX = .html
emscripten: SDLCFLAGS=
emscripten: SDLLIBS=
emscripten: FLAGS=-O2 -s TOTAL_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1 --preload-file data/@data --shell-file src/shell.html
emscripten: linux

linux: $(objs)
	$(CC) -o $(TARGET) $(objs) $(LDLIBS)
	$(STRIP) $(TARGET)

clean:
	rm -f src/*.o $(TARGET)*

.PHONY: clean
