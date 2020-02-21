# HIDRAG

Original Matlab code used in the Donelan et al. (2004) drag study.

## Description of source files and data

### Source files

* `DRAGPLOT.M`: Reads processed data and plots `cd10.jpg`
* `DRAG4.M`: Processes momentum budget data and writes `dratplt2.mat` 
* `DRAG6.M`: Processes eddy-covariance (hot-film) data and writes `uwcd.mat`
* `FLUXGRAD.M: Processes profile experiments and writes `taugrad.mat`

### Data files

* `dragplt2.mat`: 10-m drag coefficient and wind speed from momentum budget
* `dragplot.mat`: 10-m drag coefficient and wind speed from profiles
* `uwcd.mat`: 10-m drag coefficient and wind speed from eddy-covariance (hot-film)
* `taugrad.mat`: Fits of vertical stress gradient d(tau)/dz to alongtank pressure gradient dp/dx
* `uwvsu2-24.mat`: Data from eddy-covariance (hot-film) and momentum budget experiments
* `uwvsu27-62.mat`: Data from stress profile experiments
