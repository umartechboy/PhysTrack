function originalPoints = InverseTransformCart2Cart(points, originalAxesOfTransformation)
oldAxes = PhysTrack.TransformCart2Cart([0,0;1,0;0,1], originalAxesOfTransformation);
originalPoints = PhysTrack.TransformCart2Cart(points, oldAxes);
end
