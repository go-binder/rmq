
all:	
	# We have to build the C code definitions separately in a library now. Despite
	# what the early CGO tutorials say, you can only have declarations inline in the
	# the .go files now. https://code.google.com/p/go/issues/detail?id=3116 and
	# the cgo command documents here: https://golang.org/doc/go1#cmd_cgo specifically:
	# In Go 1, the cgo command uses a different _cgo_export.h file, which is generated for packages containing //export lines. The _cgo_export.h file now begins with the C preamble comment, so that exported function definitions can use types defined there. This has the effect of compiling the preamble multiple times, so a package using //export must not put function definitions or variable initializations in the C preamble. 
	# This library will be called libinterface.a. The linker commands that
	# link against it are actually embedded in the rmq.go file at the top.
	# Namely: #cgo LDFLAGS: -lR ${SRCDIR}/libinterface.a
	#
	# "R CMD build" buggily refuses to tar up our src/vendor/ contents for us, so we must resort to
	# packing vendor.tar.gz and unpacking it when installing.
	if test "$$R_INSTALL_PKG" = "rmq"; then echo "R_INSTALL_PKG = rmq found in env, unpacking vendor.tar.gz"; tar xf vendor.tar.gz; fi;
	gcc -c -o interface.o cpp/interface.cpp -Iinclude/
	ar cr rmq/libinterface.a interface.o
	cd rmq && GOPATH=${CURDIR}/.. GO15VENDOREXPERIMENT=1 go build -buildmode=c-shared  -o ../rmq.so

r:
	cd ../..  &&  R CMD INSTALL rmq
	echo "require(rmq); .Call('SayHello', 'gracey', PACKAGE = 'rmq')" | R --no-save --quiet

c: rmq/rmq.go cpp/_example_main.c
	gcc -c -o interface.o cpp/interface.cpp -Iinclude/
	ar cr rmq/libinterface.a interface.o
	GOPATH=${CURDIR}/.. GO15VENDOREXPERIMENT=1 go build -buildmode=c-shared  -o example.so rmq/rmq.go
	gcc -o _example_main cpp/_example_main.c example.so -I. -Iinclude/
	./_example_main

clean:
	find . -name '*~' | xargs rm -f
	find . -name '*[.]so' | xargs rm -f
	find . -name '*[.]o' | xargs rm -f
	find . -name '[.]Rhistory' | xargs rm -f
	rm -f rmq.h rmq.so _example_main rmq/libinterface.a  *.o example.so example.h
	rm -f ../bin/*
	# warning: do not delete vendor.tar.gz here or the 'make check' and 'make build' will fail.

check:
	tar --exclude dot[.]git --exclude [.]git -c -f - vendor |gzip > vendor.tar.gz
	cd ../.. && R CMD build rmq && R CMD check --no-manual --no-build-vignettes --no-codoc rmq_1.0.1.tar.gz

build:
	tar --exclude dot[.]git -c  -f - vendor |gzip > vendor.tar.gz
	cd ../.. && R CMD build rmq

install:
	tar --exclude dot[.]git -c  -f - vendor |gzip > vendor.tar.gz
	cd ../.. && R CMD install rmq


vtree:
	tar --exclude dot[.]git -c -v -f - vendor |gzip > vendor.tar.gz


# use the vendor/ subdir which holds the vendored apache thrift go library, version 
# the vendored thrift is commit fa0796d33208eadafb6f42964c8ef29d7751bfc2 on 1.0.0-dev,
# last commit there is Fri Oct 16 21:33:39 2015 +0200, from https://github.com/apache/thrift
thrift-all:
	cd rmq/thrift-example/client && GOPATH=${CURDIR}/.. GO15VENDOREXPERIMENT=1 go build -o ../../../../bin/thrift-ex-client
	cd rmq/thrift-example/server && GOPATH=${CURDIR}/.. GO15VENDOREXPERIMENT=1 go build -o ../../../../bin/thrift-ex-server

thrift-regen:
	rm -rf vendor/shared vendor/tutorial
	# check thrift version.
	thrift -version || true
	if test "$(shell thrift -version)" != "Thrift version 1.0.0-dev"; then echo "wrong version of thrift: 1.0.0-dev required!"; exit 1; fi;
	thrift --gen go -out vendor -r -I idl idl/tutorial.thrift


thrift-run:
	../bin/thrift-ex-server -secure &
	sleep 1 && ../bin/thrift-ex-client -secure
	sleep 1 && pkill -9 thrift-ex-server

superclean: clean
	rm -f vendor.tar.gz
