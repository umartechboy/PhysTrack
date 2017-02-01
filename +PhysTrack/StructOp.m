function struct_= StructOp( struct_, value, op)
    if isstruct(struct_)
        vars = fieldnames(struct_);
        isTpStruct = false;
        for ii = length(vars)
            if ~isempty(find(strcmp(vars, 'tp1')))
                isTpStruct = true;
                break;
            end
        end
        if isTpStruct
            for ii = 1:100
                if ~isempty(find(strcmp(vars, ['tp',num2str(ii)])))
                    eval(['struct_.tp', num2str(ii), ' = PhysTrack.StructOp(struct_.tp', num2str(ii), ', value, op);']);
                end
            end
        else
            struct_.x = eval(['struct_.x ', op,' value;']);
            struct_.y = eval(['struct_.y ', op,' value;']);
            struct_.xy = cat(2, struct_.x, struct_.y);
        end
    end
end

