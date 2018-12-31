function I = GenerateImageTag(tag)
% under construction
    if ~ischar(tag) || (length(tag) ~= 1 && length(tag) ~= 2)
        error 'The tag must be a 1 or 2 characters long string'
    end
    num = 0;
    for ii = 1:length(tag)
        if tag(ii) >= '0' && tag(ii) <= '9'
            num = uint16(tag(ii) - '0' + 1) * 36^(ii - 1) + num;
        elseif tag(ii) >= 'A' && tag(ii) <= 'Z'
            num = (uint16(tag(ii) - 'A' + 1) + 10) * 36^(ii - 1) + num;
        elseif tag(ii) >= 'a' && tag(ii) <= 'z'
            num = (uint16(tag(ii) - 'a' + 1) + 10) * 36^(ii - 1) + num;
        else
            error 'Invalid tag';
        end
    end
    
    num2 = num;
    figure; hold on;
    PhysTrack.drawRotaryEncoder(0,0,200, 30, [1]);
    PhysTrack.drawRotaryEncoder(0,0,170, 30, [1,zeros(1,10)]);
    digits = [];
    rings = [12,9,6,3]
    for ii = 1:4
        data = rem(num2, 2^rings(ii));
        data = 85;
        binRep = PhysTrack.dec2binarray(data, rings(ii));
        num2 = floor(num2 / rem(num2, 2^rings(ii)));
        PhysTrack.drawRotaryEncoder(0,0,140 - (ii - 1) * 30, 30, binRep);
    end
    axis equal
    xlim([-250, 250]);
    ylim([-250, 250]);
    I = num;
end