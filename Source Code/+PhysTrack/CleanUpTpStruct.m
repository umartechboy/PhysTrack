function tpStruct = CleanUpTpStruct( tpStruct )
%CLEANUPTPSTRUCT determines if the struct contains tpx sub structs. if it
%contains only 1, the data is brought one level heigher.
    if (PhysTrack.IsTpStruct(tpStruct))
        if (length(fieldnames(tpStruct)) == 1)
            vars = fieldnames(tpStruct);
            eval(['tpStruct = tpStruct.', vars{1}, ';']);
        end
    end
end

