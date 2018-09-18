# borrowed mainly from: https://github.com/florisvanvugt/afnipy/blob/master/Read%20AFNI.ipynb
#
# d/l afni.py to somewhere from here: https://github.com/florisvanvugt/afnipy/blob/master/afni.py
#
#
# Procedure:
#
# set up mounted dirs:
# sshfs -o IdentityFile=~/.ssh/MRCInstance1.pem ec2-user@54.86.18.216:data/cluster_failure/RandomGroupAnalyses/Results/TESTING/Beijing/6mm/randomEvent_REML/GroupAnalyses/FSL_Perm/GroupSize20/Twosamplettest/ClusterThreshold2.3/TPR_wFPR/EffectSize0.8/NoBlur/WholeBrainTest1/CM_3199_3213/ mnt
# sshfs -o IdentityFile=~/.ssh/MRCInstance1.pem ec2-user@54.165.240.96:data/cluster_failure/RandomGroupAnalyses/Results/TESTING/Beijing/6mm/randomEvent_REML/GroupAnalyses/AFNI_OLS/GroupSize20/Twosamplettest/ClusterThreshold2.3/TPR_wFPR/EffectSize0.8/NoBlur/WholeBrainTest1/CM_3199_3213/ mnt2
# sshfs -o IdentityFile=~/.ssh/MRCInstance1.pem ec2-user@54.165.240.96:data/cluster_failure/RandomGroupAnalyses/Results/Beijing/6mm/randomEvent_REML/SubjectAnalyses/ mnt3
# in python:
# os.chdir("/Users/stephanie/Documents/scripts/python/")
# import clf_comparison
##################################################

# Import stuff
import nibabel as nib # for NIFTI
import matplotlib.pyplot as plt
import os
os.chdir('/Users/stephanie/Documents/scripts/python/') # or wherever you kept afni
import afni # for AFNI

# Parameters
this_cm='11'
this_sub='96163'
#this_sub='92602'
CDT=3.432
dir_fsl='/Users/stephanie/Documents/data/mnt'
dir_afni='/Users/stephanie/Documents/data/mnt2'
dir_singlesub_orig='/Users/stephanie/Documents/data/mnt3'
xslice=23
yslice=13
zslice=25
#xslice=27
#yslice=31
#zslice=25


# Get original subject data
#hdr,data_singlesub_orig = afni.read('/Users/stephanie/Documents/data/mnt3/sub02403.results/stats.sub02403+tlrc')
_,data_singlesub_orig = afni.read(dir_singlesub_orig+'/sub'+this_sub+'.results/stats.sub'+this_sub+'+tlrc')

data_singlesub_orig=data_singlesub_orig[:,:,:,1]
#data_singlesub_orig.shape # find out dimensions for subsequent plotting


# Get data for AFNI
# data_tstat_afni is thresholded
_,data_roi_afni = afni.read(dir_afni+'/'+this_cm+'_activationadded_roiblur+tlrc')
_,data_singlesub_roi_afni = afni.read(dir_afni+'/SubjectActivations/stats.sub'+this_sub+'_activationadded_roiblur+tlrc')
_,data_tstat_afni = afni.read(dir_afni+'/'+this_cm+'_activationadded_stat+tlrc')
img_clusters_afni=nib.load(dir_afni+'/'+this_cm+'_activationadded_clusters.nii.gz')

data_roi_afni=data_roi_afni[:,:,:,0]
data_singlesub_roi_afni=data_singlesub_roi_afni[:,:,:,0]
data_tstat_afni=data_tstat_afni[:,:,:,1]
data_clusters_afni=img_clusters_afni.get_data()
data_clusters_afni=data_clusters_afni[:,:,:,0,0]

data_tstat_thresh_afni=data_tstat_afni>CDT


# Get data for FSL
_,data_roi_fsl = afni.read(dir_fsl+'/'+this_cm+'_activationadded_roiblur+tlrc')
img_singlesub_roi_fsl = nib.load(dir_fsl+'/SubjectActivations/stats.sub'+this_sub+'_activationadded_roiblur.nii.gz')
img_tstat_fsl = nib.load(dir_fsl+'/'+this_cm+'_activationadded_tstat1.nii.gz')
img_corr_tstat_fsl = nib.load(dir_fsl+'/'+this_cm+'_activationadded_clustere_corrp_tstat1.nii.gz')

data_roi_fsl=data_roi_fsl[:,:,:,0]
data_tstat_fsl=img_tstat_fsl.get_data()
data_corr_tstat_fsl=img_corr_tstat_fsl.get_data()
data_singlesub_roi_fsl=img_singlesub_roi_fsl.get_data()

randomthresh=0.8
randomthresh=0.95
data_corr_tstat_thresh_fsl=data_corr_tstat_fsl>randomthresh

# Plot images
# Define images for plotting
#data_to_plot=[data_singlesub_orig,data_roi_afni,data_singlesub_roi_afni]
#data_to_plot=[data_singlesub_orig,data_tstat_afni,data_tstat_fsl]
#data_to_plot=[data_singlesub_orig,data_tstat_afni,data_tstat_fsl,data_corr_tstat_fsl,data_tstat_thresh_afni,data_corr_tstat_thresh_fsl]
data_to_plot=[data_tstat_afni,data_tstat_fsl,data_corr_tstat_fsl,data_tstat_thresh_afni,data_corr_tstat_thresh_fsl]
nplots=len(data_to_plot)
#data_to_plot[0].shape 
#np.max(data_to_plot[0])
#np.min(data_to_plot[0])
f, axarr = plt.subplots(nplots, 3, figsize=(12,5.5))
for i in range(0,nplots):
	axarr[i,0].imshow(data_to_plot[i][xslice,:,:].T,origin='lower',cmap='gray')
	axarr[i,1].imshow(data_to_plot[i][:,yslice,:].T,origin='lower',cmap='gray')
	axarr[i,2].imshow(data_to_plot[i][:,:,zslice].T,origin='lower',cmap='gray')
plt.show(block=False)

# Data checks - should all be true
t=data_roi_fsl==data_roi_afni
print('Same rois: '+str(t.all())) 
t=data_singlesub_roi_fsl==data_roi_fsl+data_singlesub_orig
print('FSL addition works: '+str(t.all())) 
t=data_singlesub_roi_afni==data_roi_afni+data_singlesub_orig
print('AFNI addition works: '+str(t.all())) 
t=data_singlesub_roi_afni==data_singlesub_roi_fsl
print('AFNI and FSL betas same: '+str(t.all())) 
t=data_tstat_afni==data_tstat_fsl
print('AFNI and FSL tstat maps same: '+str(t.all()))

