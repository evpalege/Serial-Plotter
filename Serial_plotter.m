clear; clc;
% PARAMETERS
numOfPort = "COM3";                                                         % com port number
baudRate = 9600;                                                            % serial port speed (baud rate)
ch_fisrtByte = "1";                                                         % the first value to be sent to the serial port
maxValue = 2^19;                                                            % maximum amount of information (bytes)
sizePlot = 300;                                                             % plotter window size
nameFolder = 'Data from serial port';                                       % the name of the folder for saving data
period = 5;                                                                 % signal reading period, ms
file_name = datestr(now, 'mmmm_dd_HH-MM-SS-AM');                            % name of the data file being created


counter = 1;                                                                % counter for serial port cycle
freq = 0;                                                                   % the initial value of the signal sample
value = 0;                                                                  % auxiliary variable


port = serialport(numOfPort, baudRate);                                     % serial port object and its opening 
if ~exist(nameFolder, 'dir')                                                % creating a folder
    mkdir(nameFolder);
end
pause(3);
writeline(port, ch_fisrtByte);                                              % writing to the serial port      
pause(1);
file = fopen(strcat(fullfile(nameFolder, file_name), '.dat'), 'wt');        % creature/opening the data file
fprintf(file, 'ms\tdata\n');                                                % writing column names to a file


while(counter < (maxValue + 1))                                             % a serial port read cycle up to the maximum specified byte information value                  
    data(counter) = str2double(readline(port));
    fprintf(file, '%d\t%d\n', freq(counter), data(counter));                % writing data to a file
    if counter <= sizePlot                                                  % window limitation of the plotter
        plot(data);
    else
        plot(data((end - sizePlot):end));
    end
    counter = counter + 1;
    value = value + period;
    freq(counter) = value;
end
fclose(file);                                                               % close the file


freq(end)=[];                                                               % deleting the last index of the array to combine the matrices
plot(freq, data);                                                           % plotting a graph
title('Signal');
xlabel('time, ms');
ylabel('data');