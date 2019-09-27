% File: Clear_Error.m @ SirahLaser
% Author: Urs Hofmann
% Date: 22 Feb 2019
% Mail: hofmannu@biomed.ee.ethz.ch
% Version: 1.0

% Description: Clears all errors in the laser register. 

function Clear_Error(sl)
	fwrite(sl.usbObj, 'ERR:CL');
	if strcmp(fscanf(sl.usbObj), "OK")
		fprintf('[SirahLaser] Error cleared.\n');
	else
	 	error('Could not clear error.');
	end 
end