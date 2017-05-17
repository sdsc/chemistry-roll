NAME       = sdsc-chemistry-roll-test
VERSION    = 1.2
RELEASE    = 4
PKGROOT    = /root/rolltests

CP2K_CUDAVER=
GROMACS_CUDAVER=
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
 CHEMISTRY_CUDA=cuda
 CP2K_CUDAVER=cuda
 GROMACS_CUDAVER=cuda
 ifneq ("$(ROLLOPTS)", "$(subst cp2k_othercuda=,,$(ROLLOPTS))")
  CP2K_CUDAVER = $(subst cp2k_othercuda=,,$(filter cp2k_othercuda=%,$(ROLLOPTS)))
 endif
 ifneq ("$(ROLLOPTS)", "$(subst gromacs_othercuda=,,$(ROLLOPTS))")
  GROMACS_CUDAVER = $(subst gromacs_othercuda=,,$(filter gromacs_othercuda=%,$(ROLLOPTS)))
 endif
endif


RPM.EXTRAS = AutoReq:No
