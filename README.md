ibma
====

Image-Based Meta-Analysis toolbox for SPM.

Implementation of z-based statistics: Fisher's, Stouffer's.


# Heterogeneity toolbox

Assess Heterogeneity within meta-analysis.

##### Usage

To use the tool first open SPM in Matlab:

In the menu window select batch.

<img src="ibma_doc/example1.png" width="300">           

Then select SPM -> Tools -> Image-Based Meta-Analysis Tools -> Diagnose Heterogeneity.

<img src="ibma_doc/example2.png" width="300"> 

Fill the batch with the appropriate study data (nii's must be unzipped) and select
which statistic you wish to view and run the batch with the green triangle button.

This should then create the display window showing the map. 

To perform voxel specific plots, click on the region of interest and select Tools from
the toolbar. Then select Voxel plot and select the plot of interest (either funnel, forest
or galbraith).

<img src="ibma_heterogeneity_doc/example3.png" width="300"> 

##### Requirements

- [SPM12](http://www.fil.ion.ucl.ac.uk/spm/software/spm12/)

##### Installation

To run the NIDM-Results viewer do the following:

 ```
1. Add the filepath to SPM in Matlab;

 ```
 addpath(<full path to SPM>)
 ```