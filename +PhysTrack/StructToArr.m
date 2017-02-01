function points = StructToArr(points)
% Gets xy of first object of points

    if isstruct(points)
        vars = fieldnames(points);
        isTpStruct = false;
        for ii = length(vars)
            if ~isempty(find(strcmp(vars, 'tp1')))
                isTpStruct = true;
                break;
            end
        end
        if isTpStruct
            points_ = points.tp1.xy;
            for ii = 2:100
                if ~isempty(find(strcmp(vars, ['tp',num2str(ii)])))
                    points_ = cat(3, points_, eval(['points.tp',num2str(ii),'.xy']));
                end
            end
            points = points_;
        else
            points = points.xy;
        end        
    end
end

