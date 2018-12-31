function InitializeClient()
import java.net.ServerSocket
import java.io.*

    fprintf('Initializing');       
    if evalin('base', 'exist(''processHandles'')') ~= 1
        evalin('base', 'processHandles = [];');
    end
    if evalin('base', 'exist(''processReturns'')') ~= 1
        evalin('base', 'processReturns = cell(0);');
    end
    if evalin('base','exist(''TempDir'')') ~= 1
        evalin('base','TempDir = [];')
    end
    if evalin('base','length(TempDir) < 2')
        assignin('base', 'TempDir', uigetdir(pwd,'Select a folder for saving work files'));
    end
    if evalin('base','isempty(TempDir)')
        return;
    end
    pause(0.01);
    seed = 10000;
    while 1
        try
            server_socket = ServerSocket(seed);
            server_socket.setSoTimeout(100);
            break;
        catch
            seed = seed + 1;
            if seed == 65000
                error 'Could not create a listening node';
            end
        end
    end
    fprintf(['\nBegun the node at: ', num2str(seed)]);   
    pause(0.01);
    while 1
        try
            client = server_socket.accept;
            try
                if PhysTrack.DCS.ListenerHandler(client) == 1                    
                    client.close
                    break;
                end
            catch
            end
            client.close
        catch
        end
    end
    fprintf('\nTerminated\n');
end

