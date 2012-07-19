TCLDIR=ROOTDIR/linux-x86_64
TCLINCL=-I$(TCLDIR)/include
TCLLIB=-L$(TCLDIR)/lib -ltcl`echo 'puts $$tcl_version' | tclsh` -ldl
TCLFLAGS=-DNAMD_TCL
TCL=$(TCLINCL) $(TCLFLAGS)
