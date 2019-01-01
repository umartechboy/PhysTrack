function getvariables(address, port, vars )
%GETVARIABLES This is just like getvariable, only with forced implemenation
%of workspace file copy. This function also supports multiple variable
%copy. input args must be a comma (,) separated list of the variables
%required.
PhysTrack.DCS.AssertNodeAvailable(address, port);
PhysTrack.DCS.MakeServer;
PhysTrack.DCS.assignon(address, port, 'sharedDir', DCSServer.TempDir);
vars2 = strrep(vars, ',', ''',''');
PhysTrack.DCS.evalon(address, port, ['save([sharedDir, ''\tSave.mat''], ''', vars2,''');']);
tgt = PhysTrack.DCS.getvariable(address, port, 'TempDir');
evalin('base', ['load([''', tgt,''', ''\tSave.mat''])']);
delete([DCSServer.TempDir, '\tSave.mat']);
end

