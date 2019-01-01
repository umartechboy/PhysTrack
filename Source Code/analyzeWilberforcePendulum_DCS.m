% make a DCS Server first.
clear all
PhysTrack.DCS.AddDCSNode('127.0.0.1');
 
vr2o = PhysTrack.DCS.VideoReader2;
objs = PhysTrack.GetObjects(vr2o);

h1 = PhysTrack.DCS.KLT(vr2o, objs);
[trajectory] = PhysTrack.DCS.AcquireResults(ans);