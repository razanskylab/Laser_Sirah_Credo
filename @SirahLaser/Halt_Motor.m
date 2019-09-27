% File: Halt_Motor.m @ SirahLaser
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 22 Feb 2019
% Version: 1.0

% Description: Stops motor movement in a clean way.

function Halt_Motor(sl)

	fwrite(sl.usbObj, 'LAS:HALT');
	if strcmp(fscanf(sl.usbObj), "OK")
		fprintf('[SirahLaser] Motor stopped in a controlled way.\n');
	else
	 	error('Could not stop motors.');
	end 

end