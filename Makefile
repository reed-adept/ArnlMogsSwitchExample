
TARGETS=arnlMogsSwitchServer #ArnlTaskExamples/*.h

STATICTARGETS=$(patsubst %,%Static,$(TARGETS))

# Just used to generate all dependencies:
SOURCES=arnlMogsSwitchServer.cpp MOGSMapTools/GPSMapTools.cpp MOGSMapTools/GPSMapTools.h #Switcher.h

ifndef ARNL
ARNL:=/usr/local/Arnl
endif

LFLAGS:=-L$(ARNL)/lib

LINK:=-lMogs -lBaseArnl -lArNetworkingForArnl -lAriaForArnl -ldl -lrt -lm -lpthread

STATICLINK:=$(ARNL)/lib/libMogs.a $(ARNL)/lib/libBaseArnl.a $(ARNL)/lib/libArNetworkingForArnl.a $(ARNL)/lib/libAriaForArnl.a  -ldl -lrt -lm -lpthread

INCLUDE:=-I$(ARNL)/include -I$(ARNL)/include/Aria -I$(ARNL)/include/ArNetworking -IArnlTaskExamples 

CXXFLAGS:=-fPIC -g -Wall -D_REENTRANT -O2

OBJ:=$(patsubst %.c,%.o,$(patsubst %.cc,%.o,$(patsubst %.cpp,%.o,$(patsubst %.h,,$(patsubst %.hh,,$(SOURCES))))))

ifndef CXX
CXX:=c++
endif

all: $(TARGETS)

static: $(STATICTARGETS)

arnlMogsSwitchServer: arnlMogsSwitchServer.cpp MOGSMapTools/GPSMapTools.cpp 
	$(CXX) $(CXXFLAGS) $(INCLUDE) $(LFLAGS) -o $@ $^ -lArnl $(LINK)

arnlMogsSwitchServerStatic: arnlMogsSwitchServer.cpp MOGSMapTools/GPSMapTools.cpp 
	$(CXX) $(CXXFLAGS) $(INCLUDE) $(LFLAGS) -o $@ $^ $(ARNL)/lib/libArnl.a $(STATICLINK)
	strip $@

%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDE) -o $@ $<

%.o: %.cc
	$(CXX) -c $(CXXFLAGS) $(INCLUDE) -o $@ $<

%.o: %.c
	$(CXX) -c $(CXXFLAGS) $(INCLUDE) -o $@ $<
	
clean: 
	-rm $(TARGETS) $(STATICTARGETS) $(OBJ)

Makefile.dep: $(SOURCES)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -MM $(SOURCES) >Makefile.dep

-include Makefile.dep

# to force remaking of Makefile.dep:
cleanDep: FORCE
	-rm Makefile.dep

dep: clean cleanDep 
	$(MAKE) Makefile.dep 

.PHONY: clean all dep cleanDep

FORCE:

