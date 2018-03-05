NAME       = sdsc-chemistry-roll-test
VERSION    = 1.2
RELEASE    = 7
PKGROOT    = /root/rolltests

CP2K_CUDAVER=
GROMACS_CUDAVER=

ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CHEMISTRY_CUDAVER = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
  CP2K_CUDAVER=$(CHEMISTRY_CUDAVER)
  GROMACS_CUDAVER=$(CHEMISTRY_CUDAVER)
  LAMMPS_CUDAVER=$(CHEMISTRY_CUDAVER)
  NAMD_CUDAVER=$(CHEMISTRY_CUDAVER)
endif

ifneq ("$(ROLLOPTS)", "$(subst lammps_othercuda=,,$(ROLLOPTS))")
  LAMMPS_CUDAVER = $(subst lammps_othercuda=,,$(filter lammps_othercuda=%,$(ROLLOPTS)))
endif

ifneq ("$(ROLLOPTS)", "$(subst cp2k_othercuda=,,$(ROLLOPTS))")
  CP2K_CUDAVER = $(subst cp2k_othercuda=,,$(filter cp2k_othercuda=%,$(ROLLOPTS)))
endif

ifneq ("$(ROLLOPTS)", "$(subst gromacs_othercuda=,,$(ROLLOPTS))")
  GROMACS_CUDAVER = $(subst gromacs_othercuda=,,$(filter gromacs_othercuda=%,$(ROLLOPTS)))
endif

ifneq ("$(ROLLOPTS)", "$(subst namd_othercuda=,,$(ROLLOPTS))")
  NAMD_CUDAVER = $(subst namd_othercuda=,,$(filter namd_othercuda=%,$(ROLLOPTS)))
endif

RPM.FILES  = $(PKGROOT)/chemistry.t
RPM.EXTRAS = AutoReq:No\nAutoProv:No
