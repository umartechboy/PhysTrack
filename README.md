![PhysTrack Logo](http://i.imgur.com/5YFi1E8.png)

## What is PhysTrack?

PhysTrack is a Matlab based video tracking solution for analyzing kinematics of moving bodies. Since Matlab is a very popular analysis tool in physics laboratories around the globe, we have tried to combine the robustness of Matlab computation power with such a friendly user interface which can be found in commercial video tracking software.

## Who should use it?

PhysTrack is used in numerous physics experiments of [Smart Physics Lab](http://physlab.org/smart-physics/) section of [PhysLab](http://physlab.org/smart-physics/). 

Physics teachers, students and researchers can use PhysTrack to track the motion of moving bodies and investigate the underlying physics in many kinds of experiments. Typical examples of these experiments are rotating and translating discs [1], spring pendulum systems [2], bodies colliding on a plane and projectiles [3], microspheres exhibiting Brownian motion [4], liquid droplets falling down a stream and the movement of a fruitfly [5].

Examples of some experiments can be viewed on the Smart Physics Lab website on [This Link](http://physlab.org/smart-physics/).

## Requirements for performing an experiment with PhysTrack

* In addition to having primary knowledge of kinematics, we assume that the user is accustomed with the basics of Matlab as well.

* To capture videos a good slow motion camera is required. In PhysLab, we usually use a [Canon PowerShot SX280HS](https://www.cnet.com/products/canon-powershot-sx280-hs/review/) mounted on a tripod stand which works very well with most of the mechanics experiments. This camera can capture video at as high a frame rate as 240fps with a frame size of 320x240 pixels.

* For investigating microscopic motion, a video microscope is also required. In PhysLab, we usually use a [Motic BA210 Trinocular](http://www.motic.com/As_LifeSciences_UM_BA210/product_240.html) for investigating the Browninan motion of micro parti[]cles.

* Usually, to move the objects in required fashion, an apparatus is also recommended.

* A computer with RAM >=3GB and an installation of Matlab 2006 (or above) with [Image Acquisition Toolbox](https://www.mathworks.com/products/imaq.html) and [Computer Vision Toolbox](https://www.mathworks.com/products/computer-vision.html) is also required.

## Getting started

You are only a couple of steps away from using PhysTrack for your own experiments. 

* Download and extract the latest PhysTrack source from the downloads section . It also contains some additional experiment scripts which serve as an example for creating your own experiments.

* Also, choose and download a sample video from the [this link](https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos).

* Open Matlab and change the current directory to the downloaded package. You should see the _"+PhysTrack"_ and _"GUIs"_ directory alongwith some _"analyze motion"_ scripts in the current address window.

* Depending upon the type of experiment requied, select any script from the window and run it. (Or you can type in the name of that experiment in the command window and hit _"Enter"_.

* The scripts are designed to be user interactive. They communicate with the user through GUI's and message boxes and guide through the whole process. The script will also ask to load the experiment video you downloaded in the previous steps.

* Once done, puruse the sample scripts, which are well commented, and try to understand how you can modify the codes for your own experiment.

* Capture your own experiment's video and start making robust video tracking experiment scripts.

## Downloads

<a href="https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/umartechboy/PhysTrack/tree/master/Source%20Code" target="_blank"><img src="http://www.free-icons-download.net/images/download-logo-icon-45961.png" 
alt="PhysTrack Package" width="50" height="50" border="10" /></a> [The latest PhysTrack Package (without videos)](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/umartechboy/PhysTrack/tree/master/Source%20Code)

<a href="https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos" target="_blank"><img src="http://www.free-icons-download.net/images/download-logo-icon-45961.png" 
alt="PhysTrack Package" width="50" height="50" border="10" /></a> [Sample Videos](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos)

## Performing a physics experiment with PhysTrack

![Process Flow](http://i.imgur.com/iYiVtuD.png)

Performing a classical mechanics experiments using video tracking and performing advance analysis is very simple.

* We capture video of the moving object using a digital camera, 
* use one of the automated trackers of PhysTrack to track the objects and generate position and orientation data,
* to investigate the motion, use the in-built Matlab tools or those included in PhysTrack like numerical differentiation, curve fitting, object stitching and coordinate system transformation and
* present the results using Matlab plots and video plots included in PhysTrack.

## Sample experiments
| Experiment Title | Student manual and resources | Sample Analysis Codes| Sample Videos|
| ------------------ |:----------:| :----------:|:----------:|
|	Spring pendulum	|	[Link]	(http://physlab.org/experiment/spring-pendulum/)	|	[analyze1DSHM.m]	(https://github.com/umartechboy/PhysTrack/blob/master/Source%20Code/analyze1DSHM.m)	|	[Link]	(https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos/SpringPendulum) 	|
|	2D Collisions	|	[Link]	(http://physlab.org/experiment/colliding-pucks-on-a-carom-board/)	|	[analyze2DCollision.m]	(https://github.com/umartechboy/PhysTrack/blob/master/Source%20Code/analyze2DCollision.m)	|	[Link]	(https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos/CaromPuck)	|
|	Projectile Motion	|	[Link]	(http://physlab.org/experiment/projectile-motion/)	|	[analyzeProjectileMotion.m]	(https://github.com/umartechboy/PhysTrack/blob/master/Source%20Code/analyzeProjectileMotion.m)	|	[Link]	(https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos/Projectile%20Motion)	|
|	Sliding Friction	|	[Link]	(http://physlab.org/experiment/sliding-friction-2/)	|	[analyzeSlidingFriction.m]	(https://github.com/umartechboy/PhysTrack/blob/master/Source%20Code/analyzeSlidingFriction.m)	|	[Link]	(https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos/SlidingFriction)	|
|	Rotation on a Fixed Pivot	|	[Link]	(http://physlab.org/experiment/rotational-motion-about-a-fixed-axis/)	|	[analyzeRotationOnAFixedPivot.m]	(https://github.com/umartechboy/PhysTrack/blob/master/Source%20Code/analyzeRotationOnAFixedPivot.m)	|	[Link]	(https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos/RotationOnAFixedPivot)	|
|	Brownian Motion	|	[Link]	(http://physlab.org/experiment/tracking-brownian-motion-through-video-microscopy/)	|	[analyzeBrownianMotion.m]	(https://github.com/umartechboy/PhysTrack/blob/master/Source%20Code/analyzeBrownianMotion.m)	|	[Link]	(https://github.com/umartechboy/PhysTrack/tree/master/SampleVideos/BrownianMotion)	|
|	Rotational Friction	|			|	[analyzeRotationalFriction.m]	(https://github.com/umartechboy/PhysTrack/blob/master/Source%20Code/analyzeRotationalFriction.m)	|	[Link]	(https://github.com/umartechboy/PhysTrack/blob/master/SampleVideos/RollingCylinder.MP4)	|



## Video demonstration

Once the video is captured, PhysTrack is used in Matlab for extracting data, performing analysis and presenting the results. When using the sample _"analyze motion"_ scripts from the previous section, the process is similar for all the experiments. Users can also take these experiments as a base for creating new scrips and automated experiments.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=tSQxx-jpT-Q" target="_blank"><img src="http://i.imgur.com/VrLSe5p.png" 
alt="Video Demonstration on YouTube" width="650" height="360" border="10" /></a>

## Resources

* [PhysTrack Wiki](https://github.com/umartechboy/PhysTrack/wiki).
* Primer: [Investigating kinematics with PhysTrack](http://physlab.org/wp-content/uploads/2016/03/primer_videoTracking.pdf).
* [Examples of mechanics experiments](http://physlab.org/tag/mechanics/).
* [Example of experiment with video microscopy](http://physlab.org/experiment/tracking-brownian-motion-through-video-microscopy/).
* [PhysLab website](http://physlab.org/).

## Credits

The whole work is an effort of <a href="http://physlab.org/">PhysLab</a> of the Lahore University of Management Sciences (<a href="https://lums.edu.pk/">LUMS</a>), Lahore, Pakistan. Kindly feel free to contact in case you wish to contribute in the development and improvement of this library.

### Authors

M. Umar Hassan, [M. Sabieh Anwar](http://physlab.org/muhammad-sabieh-anwar-personal/).

## References

[1] J. Poonyawatpornkul and P. Wattanakasiwich, "High-speed video analysis of a rolling disc in three dimensions", Eur. J. Phys. 36 065027 (2015).

[2] J. Poonyawatpornkul and P. Wattanakasiwich, _"High-speed video analysis of damped harmonic motion"_, Eur. J. Phys. 48 6 (2013).

[3] Loo Kang Wee, Charles Chew, Giam Hwee Goh, Samuel Tan and Tat Leong Lee, _"Using Tracker as a pedagogical tool for understanding projectile motion"_ Eur. J. Phys. 47 448 (2012).

[4] Paul Nakroshis, Matthew Amoroso, Jason Legere and Christian Smith, _"Measuring Boltzmann’s constant using video microscopy of Brownian motion"_, Am. J. Phys, 71, 568 (2003).

[5] [_"Tracking kinematics of a fruitfly using video analysis"_](http://goo.gl/ljypdC).

The first version uploaded on GitHub is v2.1 and a comprehensive documentation of this code can be viewed on PhysTrack Wiki on <a href="https://github.com/umartechboy/PhysTrack/wiki">This Link</a>. 

