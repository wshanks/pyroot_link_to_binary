PYTHON_VERSION = $(shell python -V 2>&1 | sed -E 's/Python ([0-9]+\.[0-9]+).*/\1/')
PYTHON_INCLUDE_DIR ?= ${CONDA_PREFIX}/include/python${PYTHON_VERSION}m
PYTHON_LIBRARY_DIR ?= ${CONDA_PREFIX}/lib

default: libPyROOT.so

src/G__PyROOT.cxx:
	ROOTIGNOREPREFIX=1 rootcling -rootbuild -v2 -f src/G__PyROOT.cxx -s libPyROOT.so -m libCore_rdict.pcm -m libMathCore_rdict.pcm -m libNet_rdict.pcm -m libTree_rdict.pcm -m libRint_rdict.pcm -excludePath inc -rml libPyROOT.so -rmf libPyROOT.rootmap -writeEmptyRootPCM -I${ROOTSYS}/include -I${PYTHON_INCLUDE_DIR} TPyArg.h TPyDispatcher.h TPyException.h TPyFitFunction.h TPyROOTApplication.h TPyReturn.h TPySelector.h TPython.h inc/LinkDef.h

%.o: src/%.cxx
	g++ -fPIC -std=c++11 -I${ROOTSYS}/include -I${PYTHON_INCLUDE_DIR} -o $@ -c $<

G__PyROOT.o: src/G__PyROOT.cxx
	g++ -fPIC -std=c++11 -I${ROOTSYS}/include -I${PYTHON_INCLUDE_DIR} -o $@ -c $<

pyroot_objects: $(addsuffix .o, $(basename $(notdir $(wildcard src/*.cxx))))
pyroot_objects: G__PyROOT.o

libPyROOT.so: pyroot_objects G__PyROOT.o
	g++ -fPIC  -Wno-implicit-fallthrough -Wno-noexcept-type -pipe -m64  -Wshadow -Wall -W -Woverloaded-virtual -fsigned-char -pthread -std=c++11 -fno-strict-aliasing -Wno-parentheses-equality -O3 -g -DNDEBUG  -Wl,--no-undefined -shared -Wl,-soname,libPyROOT.so -o libPyROOT.so *.o -L${ROOTSYS}/lib -Wl,-rpath,${PYTHON_LIBRARY_DIR} ${PYTHON_LIBRARY_DIR}/libpython${PYTHON_VERSION}m.so ${ROOTSYS}/lib/libRint.so ${ROOTSYS}/lib/libROOTDataFrame.so ${ROOTSYS}/lib/libROOTVecOps.so -lvdt ${ROOTSYS}/lib/libTreePlayer.so ${ROOTSYS}/lib/libTree.so ${ROOTSYS}/lib/libGraf3d.so ${ROOTSYS}/lib/libGpad.so ${ROOTSYS}/lib/libGraf.so ${ROOTSYS}/lib/libMultiProc.so ${ROOTSYS}/lib/libNet.so ${ROOTSYS}/lib/libHist.so ${ROOTSYS}/lib/libRIO.so ${ROOTSYS}/lib/libMatrix.so ${ROOTSYS}/lib/libMathCore.so ${ROOTSYS}/lib/libImt.so ${ROOTSYS}/lib/libThread.so ${ROOTSYS}/lib/libCore.so 

clean:
	rm -f *.o libPyROOT.so src/G__PyROOT.cxx *.cpm *.rootmap

.PHONY: default pyroot_objects clean
