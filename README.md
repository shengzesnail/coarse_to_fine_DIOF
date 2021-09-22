# coarse-to-fine DIOF

### dynamic illumination optical flow computing


We implemented the multi-resolution optical flow which can deal with illumination changes.

The dynamic illumination optical flow computing aims at solving the velocity field based on the following loss function：

<div align=center><img height="200" src="https://github.com/shengzesnail/coarse_to_fine_DIOF/blob/master/data/DIOFloss.PNG"/></div>

      

### License and citation

This repository is provided for research purposes only. Any commercial use requires our consent. If you use the codes in your research work, please cite the following paper: 
  
      @article{cai2018dynamic,
        title={Dynamic illumination optical flow computing for sensing multiple mobile robots from a drone},
        author={Cai, Shengze and Huang, Yongbin and Ye, Bo and Xu, Chao},
        journal={IEEE Transactions on Systems, Man, and Cybernetics: Systems},
        volume={48},
        number={8},
        pages={1370--1382},
        year={2018},
        publisher={IEEE}
      }
  
This program is originally implemented to perform motion-based object detection. **However, in this project, we apply the DIOF method to extract motion field of fluid flow from particle images**.



### Usage:  Run the script main.m  
  
### Example:

The images of this example are originally provided by FLUID - http://fluid.irisa.fr/data-eng.htm  

And we add synthetic brightness change to the second image frame.

<div align=center><img height="250" src="https://github.com/shengzesnail/coarse_to_fine_DIOF/blob/master/data/image.png"/></div>


#### Results - velocity field and vorticity map

<div align=center><img height="250" src="https://github.com/shengzesnail/coarse_to_fine_DIOF/blob/master/data/uvs.png"/></div>


