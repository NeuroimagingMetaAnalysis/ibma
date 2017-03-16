%==========================================================================
%Configures the job layout for masking. This code was taken from
%spm_cfg_factorial_design.m
%==========================================================================
function masking = ibma_config_masking()

%--------------------------------------------------------------------------
% tm_none None
%--------------------------------------------------------------------------
tm_none         = cfg_const;
tm_none.tag     = 'tm_none';
tm_none.name    = 'None';
tm_none.val     = {1};
tm_none.help    = {'No threshold masking'};

%--------------------------------------------------------------------------
% athresh Threshold
%--------------------------------------------------------------------------
pthresh         = cfg_entry;
pthresh.tag     = 'pthresh';
pthresh.name    = 'Threshold';
pthresh.help    = {'Enter the percentage of studies.'};
pthresh.strtype = 'r';
pthresh.num     = [1 1];
pthresh.val     = {100};

%--------------------------------------------------------------------------
% tmp Absolute
%--------------------------------------------------------------------------
tmp         = cfg_branch;
tmp.tag     = 'tmp';
tmp.name    = 'Percentage';
tmp.val     = {pthresh };
tmp.help    = {
               'Images are thresholded at a given value and only voxels at which voxels with above that percentage of studies present are kept. '
               ''
               'This option allows you to specify the percentage value of the threshold.'
}';

%--------------------------------------------------------------------------
% rthresh Threshold
%--------------------------------------------------------------------------
rthresh         = cfg_entry;
rthresh.tag     = 'rthresh';
rthresh.name    = 'Threshold';
rthresh.help    = {'Enter the threshold as a proportion of the global value.'};
rthresh.strtype = 'r';
rthresh.num     = [1 1];
rthresh.val     = {5};

%--------------------------------------------------------------------------
% tmr Relative
%--------------------------------------------------------------------------
tmr         = cfg_branch;
tmr.tag     = 'tmr';
tmr.name    = 'Relative';
tmr.val     = {rthresh};
tmr.help    = {
               'Images are thresholded at a given value and only voxels at which all images exceed the threshold are included.'
               ''
               'This option allows you to specify the value of the threshold as a proportion of the global value.'
}';

%--------------------------------------------------------------------------
% tm Threshold masking
%--------------------------------------------------------------------------
tm         = cfg_choice;
tm.tag     = 'tm';
tm.name    = 'Threshold masking';
tm.val     = {tm_none};
tm.help    = {'Images are thresholded at a given value and only voxels at which the number of studies present are above this value are kept.'};
tm.values  = {tm_none tmp tmr};

%--------------------------------------------------------------------------
% im Implicit Mask
%--------------------------------------------------------------------------
im        = cfg_menu;
im.tag    = 'im';
im.name   = 'Implicit Mask';
im.help   = {
             'An "implicit mask" is a mask implied by a particular voxel value. Voxels with this mask value are excluded from the analysis.'
             ''
             'For image data-types with a representation of NaN (see spm_type.m), NaN''s is the implicit mask value, (and NaN''s are always masked out).'
             ''
             'For image data-types without a representation of NaN, zero is the mask value, and the user can choose whether zero voxels should be masked out or not.'
             ''
             'By default, an implicit mask is used.'
}';
im.labels = {'Yes', 'No'};
im.values = {1 0};
im.val    = {1};

%--------------------------------------------------------------------------
% em Explicit Mask
%--------------------------------------------------------------------------
em         = cfg_files;
em.tag     = 'em';
em.name    = 'Explicit Mask';
em.val     = {{''}};
em.help    = {
              'Explicit masks are other images containing (implicit) masks that are to be applied to the current analysis.'
              ''
              'All voxels with value NaN (for image data-types with a representation of NaN), or zero (for other data types) are excluded from the analysis.'
              ''
              'Explicit mask images can have any orientation and voxel/image size. Nearest neighbour interpolation of a mask image is used if the voxel centers of the input images do not coincide with that of the mask image.'
}';
em.filter  = {'image','mesh'};
em.ufilter = '.*';
em.num     = [0 1];

%--------------------------------------------------------------------------
% masking Masking
%--------------------------------------------------------------------------
masking         = cfg_branch;
masking.tag     = 'masking';
masking.name    = 'Masking';
masking.val     = {tm im em};
masking.help    = {
                   'The mask specifies the voxels within the image volume which are to be assessed. SPM supports three methods of masking (1) Threshold, (2) Implicit and (3) Explicit. The volume analysed is the intersection of all masks.'
}';

end