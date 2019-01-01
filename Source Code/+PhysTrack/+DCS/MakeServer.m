%MAKESERVER Makes a struct to represent the DCS server
global DCSServer
if isempty(DCSServer)
    evalin('base', 'global DCSServer');
    assignin('base', 'DCSServer', struct('Nodes', struct('Address', [], 'Port', []), 'TempDir', []));    
end


if evalin('base','length(DCSServer.TempDir) < 2')
    evalin('base', ['DCSServer.TempDir = ''', uigetdir(pwd,'Select a folder for saving work files'), ''';']);
end