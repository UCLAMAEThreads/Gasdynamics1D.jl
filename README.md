# Gasdynamics1D.jl

_Tools for analysis of 1d gasdynamics problems_

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://uclamaethreads.github.io/Gasdynamics1D.jl/dev/)
 [![Build Status](https://github.com/UCLAMAEThreads/Gasdynamics1D.jl/workflows/CI/badge.svg)](https://github.com/UCLAMAEThreads/Gasdynamics1D.jl/actions) [![codecov](https://codecov.io/gh/UCLAMAEThreads/Gasdynamics1D.jl/branch/main/graph/badge.svg?token=m4pj7rjF0r)](https://codecov.io/gh/UCLAMAEThreads/Gasdynamics1D.jl)

The tools in this package enable the user to
- specify the thermodynamic state of a flow for a calorically perfect gas
- convert the state variables between different units
- find the change of flow state in various processes, including
  - quasi-1d isentropic flow with area changes
  - flows through normal shocks
  - flow with ducts with effects of wall friction (Fanno flow)
  - flows with ducts with effects of heat transfer (Rayleigh flow)

The easiest way to get started is to follow the examples notebooks in the `notebook` directory. Also, please consult the [documentation](https://uclamaethreads.github.io/Gasdynamics1D.jl/dev/).
