SUBDIRS=sysdeps

EXTRA_DIST=generalize-small.template

BUILT_SOURCES = generalize-small.h

#Private Headers
private_HEADERS=generalize.h generalize-small.h
privatedir=${includedir}/atomic_ops/

generalize-small.h: generalize-small.template
	sed -e s:XSIZE:char:g -e s:XCTYPE:char:g $? > $@
	sed -e s:XSIZE:short:g -e s:XCTYPE:short:g $? >> $@
	sed -e s:XSIZE:int:g -e s:XCTYPE:int:g $? >> $@
