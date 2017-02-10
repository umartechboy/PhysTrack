function retCol = GetColor( reqCol, getName, getInverse, useExtendedColors)
%GETCOLOR Gets a color from a pre defined color pallete
%   The Basic Color Pallete contains 14 basic colors. If a color is not
%   found in the basic pallete, it will be searched for in the extended
%   vesion. reqCol can be a string, color, or an index. While using index,
%   if the index exceeds the length of basic pallete, it is converted to
%   extended pallete.
    fromCol = false;
    fromName = false;
    
    if nargin < 4
        useExtendedColors = false;
    end
    if ischar(reqCol)
        fromName = true;
    elseif length(reqCol) == 3
        fromCol = true;
    else % is index
        if reqCol > 14
            useExtendedColors = true;
        end
    end
    if nargin < 3
        getInverse = false;
    end
    if nargin < 2
        getName = false;
    end
    fCols = PhysTrack.ColorPallete(false, useExtendedColors);
    fColsName = PhysTrack.ColorPallete(true, useExtendedColors);
    
    retCol = [];
    if fromName
        for ii = 1:size(fCols, 1)
            if strcmp(strrep(lower(fColsName(ii)), ' ', ''), strrep(lower(reqCol), ' ', ''))
                retCol = fCols(ii, :);
            end
        end
        if isempty(retCol)
            if ~useExtendedColors && isempty(retCol)
                retCol = PhysTrack.GetColor(reqCol, getName, getInverse, true);
            end
            return;
        end
    elseif fromCol
        retCol = reqCol;
    else
        retCol = fCols(reqCol, :);
    end
    
    if getInverse
        retCol = [255, 255, 255] - retCol;
    end
    if getName
        for ii = 1:size(fCols, 1)
            if sum(fCols(ii,:) == retCol) == 3
                retCol = fColsName(ii);
                if ~useExtendedColors && isempty(retCol)
                    retCol = PhysTrack.GetColor(reqCol, getName, getInverse, true);
                end
                return;
            end
        end
        retCol = [];
        if ~useExtendedColors && isempty(retCol)
            retCol = PhysTrack.GetColor(reqCol, getName, getInverse, true);
        end
        return;
    end;
    
    if ~useExtendedColors && isempty(retCol)
        retCol = PhysTrack.GetColor(reqCol, getName, getInverse, true);
    end
end

