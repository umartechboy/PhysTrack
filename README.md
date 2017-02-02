# PhysTrack
PhysTrack is an open source Matlab library developed by PhysLab (Lahore University of management sciences, Pakistan).

The latest version on Feb 2, 2017 was 2.1.

Following is a quick guide for testing the library.

1: Open Matlab r2010 or above in the ectracted library folder.
2: call fileInit and select a video file for tracking. Some sample videos can be found in the root of this repo.
3: depending on the type of video selected, call the analyzeXYZMotion script and follow the instructions.
4: All of the videos require a pixel to meters calibration constant which has to be drawn on the frame. For testing purpose, any distance can be marked.
5: The script will call different functions to analyze, process and preview the video.

Following is a small list of some important functions and scripts.
  a: PhysTrack.VideoReader2 >> constructs and returns a video redear object. This object contains cropping and trimming information.
  b: PhysTrack.read2(VideoReader2Object, frameNumber) reads a specific frame from the VideoReader2 object.
  c: PhysTrack.GetObjects(VideoReader2Object) is a GUI to manually mark objects for tracking purpose.
  d: PhysTrack.KLT(VideoReader2Object, SelectedObjects) previews and tracks the objects in the rest of the video using KLT algorithm. returns the trajectories of the selected objects in a struct form. The struct contains tpN objects. where N is equal to the number of objects given for tracking.
  e: PhysTrack.BinaryTracker(VideoReader2Object, SelectedObjects) previews and tracks the objects in the rest of the video using Binary background difference method. It returns the trajectories of the selected objects in a struct form. The struct contains tpN objects. where N is equal to the number of objects given for tracking.
  f: DrawCoordinateSystem(vro) lets the user interactively define a floating coordinate system and a pixel to unit calibration constant.
  g: DrawFloatingCoordinateSystem(vro, trajectory1, trajectory2) lets the user interactively define a floating coordinate system and a pixel to unit calibration constant. This type of coordinate system is defined in the first frame but will be stitched to the given track points. This way, it will move with those points in the whole Video.
  h: PhysTrack.TransformCart2Cart and PhysTrack.InverseTransformCart2Cart can transform trajectories from and to a coordinate system defined using the coordinate system tools. These functions work with both TP type structs and arrays of points and can also work fine with floating and stationary coordinate systems.
  i: PhysTrack.VidPlot(VideoReader2Object, TrackPoints) can create a colorful video using the track points and the original video.
  j: PhysTrack.deriv(xdata, ydata, order) function can derivate a given array of points and return deriavative of order 1 to 4.
  k: PhysTrack.lsqCFit(xdata, ydata, dependant, model, independant, startingValues) uses the inbuilt cftool to fit the data on a mathematical model.
  l: PhysTrack.cascade arranges all open figures on the screen in sequence.

For a detail on how every function works, see the embedded comments.
