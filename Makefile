# makefile for CHAPRO using MinGW

CFLAGS=-Wall -Wno-unknown-pragmas -I$(INCDIR) -DSHA
LFLAGS=-L$(LIBDIR)
LIBS=-lchapro -lsigpro -lm -lz
SCLIB=-larsc -lwinmm -lkernel32 -luser32 -lgdi32
CC=gcc
AR=ar
LIBDIR=c:/usr/lib
INCDIR=c:/usr/include
BINDIR=c:/usr/bin
CHAPRO=cha_core.o cha_scale.o db.o rfft.o \
	agc_prepare.o agc_process.o \
	firfb_prepare.o firfb_process.o \
	cgtfb_prepare.o cgtfb_process.o \
	feedback_prepare.o feedback_process.o \
	compressor_prepare.o compressor_process.o
PGMS=tst_gfa tst_gfio tst_ffa tst_ffio tst_ffsc 

all: $(PGMS)

tst: tstgf tstff tstsc

tstgf: tst_gfa tst_gfio 
	./tst_gfa
	./tst_gfio
	./tst_gfio -t

tstff: tst_ffa tst_ffio 
	./tst_ffa
	./tst_ffio
	./tst_ffio -t

tstsc: tst_gfsc tst_ffsc
	./tst_gfsc
	./tst_ffsc

tst_gfa : tst_gfa.o  libchapro.a
	$(CC) $(LFLAGS) -o $@ $^ $(LIBS)

tst_gfio : tst_gfio.o  libchapro.a
	$(CC) $(LFLAGS) -o $@ $^ $(LIBS)

tst_gfsc : tst_gfsc.o  libchapro.a
	$(CC) $(LFLAGS) -o $@ $^ $(LIBS) $(SCLIB)

tst_ffa : tst_ffa.o  libchapro.a
	$(CC) $(LFLAGS) -o $@ $^ $(LIBS)

tst_ffio : tst_ffio.o  libchapro.a
	$(CC) $(LFLAGS) -o $@ $^ $(LIBS)

tst_ffsc : tst_ffsc.o  libchapro.a
	$(CC) $(LFLAGS) -o $@ $^ $(LIBS) $(SCLIB)

libchapro.a: $(CHAPRO)
	$(AR) rus libchapro.a $(CHAPRO)

install: libchapro.a
	cp -f libchapro.a $(LIBDIR)
	cp -f chapro.h $(INCDIR)

zipsrc:
	zip chaprosc *.mgw *.lnx *.mac
	zip chaprosc *.h *.c *.plt *.std *.m *.def
	zip chaprosc VS9/*.sln VS9/*.vcproj test/cat.wav
	zip chaprosc configure configure.bat 
	zip chaprosc compress.bat suppress.bat shacmp.bat

dist: zipsrc 
	cp -f chapr*.zip ../dist
	rm -f *.zip

clean:
	rm -f *.o *.obj *.bak *.a *.exe $(PGMS) 
	rm -f out*.mat out*.wav *.cfg *~

# dependencies
cha_core.o : chapro.h version.h
compressor_prepare.o : chapro.h cha_gf.h
compressor_process.o : chapro.h cha_gf.h
cgtfb_process.o : chapro.h cha_gf.h
cgtfb_prepare.o : chapro.h cha_gf.h
firb_prepare.o : chapro.h cha_gf.h
firb_process.o : chapro.h cha_gf.h
tst_gf.o : chapro.h cha_gf.h
tst_gfio.o : chapro.h cha_gf.h
tst_gfsc.o : chapro.h cha_gf.h
