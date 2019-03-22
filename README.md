# coarse_to_fine_DIOF

### dynamic illumination optical flow computing


We implemented the multi-resolution optical flow which can deal with illumination changes.

The dynamic illumination optical flow computing aims at solving the velocity field based on the following loss function：

<div align=center><img height="200" src="https://github.com/shengzesnail/coarse_to_fine_DIOF/blob/master/data/DIOFloss.PNG"/></div>

      

### Main reference:

This program is originally implemented to perform motion-based object detection and motion estimation:

 Cai, S., Huang, Y., Ye, B., & Xu, C. (2018). Dynamic illumination optical flow computing for sensing multiple mobile robots from a drone.  IEEE Transactions on Systems, Man, and Cybernetics: Systems, 48(8), 1370-1382. (https://doi.org/10.1109/TSMC.2017.2709404)  
  

#### However, in this project, we apply the DIOF method to extract motion field of fluid flow from partical images.



### Usage:  Run the script main.m  
  
### Example:

The images of this example are originally provided by FLUID - http://fluid.irisa.fr/data-eng.htm  

And we add synthetic brightness change to the second image frame.

<div align=center><img height="300" src="https://github.com/shengzesnail/coarse_to_fine_DIOF/blob/master/data/images.png"/></div>


#### Results - velocity field and vorticity map

<div align=center><img height="250" src="https://github.com/shengzesnail/coarse_to_fine_DIOF/blob/master/data/uvs.png"/></div>


