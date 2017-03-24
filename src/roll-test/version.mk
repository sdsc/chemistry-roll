NAME       = sdsc-chemistry-roll-test
VERSION    = 1.2
RELEASE    = 1
PKGROOT    = /root/rolltests

CP2K_CUDAVER=
GROMACS_CUDA=
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
 CHEMISTRY_CUDA=cuda
 CP2K_CUDAVER=cuda
 ifneq ("$(ROLLOPTS)", "$(subst cp2k_othercuda=,,$(ROLLOPTS))")
  CP2K_CUDAVER = $(subst cp2k_othercuda=,,$(filter cp2k_othercuda=%,$(ROLLOPTS)))
 endif
endif


RPM.EXTRAS = AutoReq:No
