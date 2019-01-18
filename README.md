# PyROOT link to binary
This repo demonstrates how to build PyROOT from the
[ROOT](https://root.cern.ch) source linking to the pre-compiled distribution of
ROOT and an arbitrary version of Python. For the demonstration, the Fedora
version of ROOT and the conda version of Python are used.

## Included files

* `Makefile`: a Makefile that can be run in the `binddings/pyroot` directory of
  the ROOT source to compile `libPyROOT.so` without the full build of the ROOT
source.

* `fedora_setup.sh`:
  + Downloads the binary and source distributions of ROOT
  + Downloads the Miniconda installer
  + Creates a systemd-nspawn Fedora container
  + Installs the dependencies for conda and ROOT into the container
  + Copies all the downloaded components into the container
  + Copies the Makefile and test_pyroot.py files into the container
  + Runs test_pyroot.sh in the container

* `test_pyroot.sh`:
  + Creates a new conda environment with `python` and `numpy`
  + Unpacks the ROOT distributions
  + Activates the conda and ROOT environments
  + Compiles the PyROOT source agains the binary version of ROOT
  + Runs test_pyroot.py which should open a window with a sinusoid plot

* `test_pyroot.py`: Python script that generates a simple ROOT plot to test
  that Python and ROOT are properly linked.
