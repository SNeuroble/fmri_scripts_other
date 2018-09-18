# borrowed mainly from: https://github.com/florisvanvugt/afnipy/blob/master/Read%20AFNI.ipynb
#
# d/l afni.py to somewhere from here: https://github.com/florisvanvugt/afnipy/blob/master/afni.py
#
# set up mounted dirs:
# sshfs -o IdentityFile=~/.ssh/MRCInstance1.pem ec2-user@34.239.129.83:data/cluster_failure/RandomGroupAnalyses/Results/Beijing/6mm/randomEvent_REML/GroupAnalyses/FSL_Perm/GroupSize20/Twosamplettest/ClusterThreshold2.3/TPR_wFPR/EffectSize0.8/NoBlur/Summary/ mnt
# sshfs smn33@172.23.202.136:data2_smn33/cluster_failure/RandomGroupAnalyses/Results/Beijing/6mm/randomEvent_REML/GroupAnalyses/FSL_Perm/GroupSize20/Twosamplettest/ClusterThreshold2.3/FPR2/Summary/ mnt2

#sshfs -o IdentityFile=~/.ssh/MRCInstance1.pem ec2-user@34.239.129.83:data/cluster_failure/RandomGroupAnalyses/Results/Beijing/6mm/randomEvent_REML/GroupAnalyses/FSL_Perm_TFCE/GroupSize20/Twosamplettest/ClusterThreshold2.3/TPR_wFPR/EffectSize0.8/NoBlur/Summary/ mnt

#sshfs -o IdentityFile=~/.ssh/MRCInstance1.pem ec2-user@34.239.129.83:data/cluster_failure/RandomGroupAnalyses/Results/Beijing/6mm/randomEvent_REML/GroupAnalyses/FSL_Perm_TFCE/GroupSize20/Twosamplettest/ClusterThreshold2.3/FPR_TOBECONTINUED/Summary/ mnt2

# sshfs smn33@172.23.202.136:temp/ mnt3
##################################################

# Import stuff
import nibabel as nib # for NIFTI
import matplotlib.pyplot as plt
import os
os.chdir('/Users/stephanie/Documents/scripts/python/') # or wherever you kept afni
import afni # for AFNI
import numpy as np # various matrix manip

# Parameters
dir_TPR='/Users/stephanie/Documents/data/mnt'
dir_FPR='/Users/stephanie/Documents/data/mnt2'
#dir_FPR_fsl='/Users/stephanie/Documents/data/mnt2'
#dir_afni='/Users/stephanie/Documents/data/mnt2'
dir_smooth='/Users/stephanie/Documents/data/mnt3'
dir_mask=dir_smooth
xslice=27
yslice=31
zslice=25


# Get original subject data
#hdr,data_orig = afni.read('/Users/stephanie/Documents/data/mnt3/sub02403.results/stats.sub02403+tlrc')
#_,data_orig = afni.read(dir_orig+'/sub'+this_sub+'.results/stats.sub'+this_sub+'+tlrc')
#
#data_orig=data_orig[:,:,:,1]
#data_orig.shape # find out dimensions for subsequent plotting


# Get data for AFNI
#TPR, FWE, smooth
#_,data_roi_afni = afni.read(dir_afni+'/'+this_cm+'_activationadded_roiblur+tlrc')
#_,data_post_afni = afni.read(dir_afni+'/SubjectActivations/stats.sub'+this_sub+'_activationadded_roiblur+tlrc')
#_,data_tstat_afni = afni.read(dir_afni+'/'+this_cm+'_activationadded_stat+tlrc')
#img_clusters_afni=nib.load(dir_afni+'/'+this_cm+'_activationadded_clusters.nii.gz')
#
#data_roi_afni=data_roi_afni[:,:,:,0]
#data_post_afni=data_post_afni[:,:,:,0]
#data_tstat_afni=data_tstat_afni[:,:,:,1]
#data_clusters_afni=img_clusters_afni.get_data()
#data_clusters_afni=data_clusters_afni[:,:,:,0,0]
#
#data_tstat_thresh_afni=data_tstat_afni>2.326


# Get data for FSL
img_TPR = nib.load(dir_TPR+'/all_clusters_activationadded_sum.nii.gz')
img_FPR = nib.load(dir_FPR+'/all_clusters_sum.nii.gz')
img_smooth = nib.load(dir_smooth+'/avgsmooth.nii.gz')
img_mask=nib.load(dir_mask+'/TT_N27_3mm_seg_1__dilated_remasked.nii')

data_TPR=img_TPR.get_data()
data_FPR=img_FPR.get_data()
data_mask=img_mask.get_data()
data_smooth=img_smooth.get_data()

# Apply mask
(i,j,k)=data_mask.nonzero()
data_TPR_m=data_TPR[i,j,k]
data_FPR_m=data_FPR[i,j,k]
data_smooth_m=data_smooth[i,j,k]

print('TPR FPR:'+str(np.corrcoef(data_TPR_m.flatten(1),data_FPR_m.flatten(1))))
print('TPR sm:'+str(np.corrcoef(data_TPR_m.flatten(1),data_smooth_m.flatten(1))))
print('FPR sm:'+str(np.corrcoef(data_FPR_m.flatten(1),data_smooth_m.flatten(1))))

print('TPR FPR cov:'+str(np.cov(data_TPR_m.flatten(1),data_FPR_m.flatten(1))))
print('TPR sm cov:'+str(np.cov(data_TPR_m.flatten(1),data_smooth_m.flatten(1))))
print('FPR sm cov:'+str(np.cov(data_FPR_m.flatten(1),data_smooth_m.flatten(1))))

print('obs:'+str(len(data_FPR_m.flatten(1))))

# Plot images
# Define images for plotting
#data_to_plot=[data_orig,data_roi_afni,data_post_afni]
#data_to_plot=[data_orig,data_tstat_afni,data_tstat_fsl]
#data_to_plot=[data_orig,data_tstat_afni,data_corr_tstat_fsl,data_tstat_thresh_afni,data_corr_tstat_thresh_fsl]
#nplots=len(data_to_plot)
#data_to_plot[0].shape 
#np.max(data_to_plot[0])
#np.min(data_to_plot[0])
#f, axarr = plt.subplots(nplots, 3, figsize=(12,5.5))
#for i in range(0,nplots):
#	axarr[i,0].imshow(data_to_plot[i][xslice,:,:].T,origin='lower',cmap='gray')
#	axarr[i,1].imshow(data_to_plot[i][:,yslice,:].T,origin='lower',cmap='gray')
#	axarr[i,2].imshow(data_to_plot[i][:,:,zslice].T,origin='lower',cmap='gray')
#plt.show(block=False)


# Data checks - should all be true
#t=data_roi_fsl==data_roi_afni
#print('Same rois: '+str(t.all())) 
#t=data_post_fsl==data_roi_fsl+data_orig
#print('FSL addition works: '+str(t.all())) 
#t=data_post_afni==data_roi_afni+data_orig
#print('AFNI addition works: '+str(t.all())) 
#t=data_post_afni==data_post_fsl
#print('AFNI and FSL betas same: '+str(t.all())) 
#t=data_tstat_afni==data_tstat_fsl
#print('AFNI and FSL tstat maps same: '+str(t.all()))

