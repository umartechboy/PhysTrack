function SetPreProcessingFunction( funcName )
%SETPREPORCESSINGFUNCTION assigns a function which will be used to
%pre-process each video frame before further processing by the library. The
%function must take nxm wide uint8 RGB array and return back an image of
%the same dimensions and bit depth.
%
%    Example
%
%    SetPreprocessingFunction('MyFunc1');
%
%    See also PHYSTRACK.READ2

    if exist(funcName)
        evalin('base', 'global PreProcessingFunction');
        assignin('base', 'PreProcessingFunction', funcName);
    else
        error(['No function by name ''',funcName,''' was found in the current directory. Make sure that the directory containing the function is included in the path.']);
    end
end

