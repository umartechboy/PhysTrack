function structData = ArrToStr(arrData, forceCollectionStruct)
if nargin == 1
    %if true, we will force to create a tp struct even if it is not needed
    forceCollectionStruct = false;
end
    if size(arrData, 3) == 1
        structData = struct ('x', arrData(:,1), 'y', arrData(:,2), 'xy', arrData) ;
        if forceCollectionStruct
            structData = struct('tp1', structData);
        end
        return;
    else % multi
        for ii = 1:size(arrData, 3)
            eval(['tp', num2str(ii) ,' = struct (''x'', arrData(:,1, ', num2str(ii), '), ''y'', arrData(:,2, ', num2str(ii), '), ''xy'', arrData(:,:,', num2str(ii), '));']);
        end
        str = '';
        for ii = 1:size(arrData, 3)
            if ii > 1
                str = [str, ', '];
            end
            str = [str, '''tp', num2str(ii),''', tp',num2str(ii)];
        end
        str = ['struct(', str, ')'];
        structData = eval(str);
        return;
    end
end

