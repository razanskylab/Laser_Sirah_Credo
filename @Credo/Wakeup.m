% File: Wakeup.m @ SirahLaser
% Author: Urs Hofmann
% Date: 22 Feb 2019
% Mail: hofmannu@biomed.ee.ethz.ch
% Version: 1.0

% Description: Wakes all components up after sleep phase

function Wakeup(sl)
	fwrite(sl.usbObj, 'LAS:WUP');
	if strcmp(fscanf(sl.usbObj), "OK")
		fprintf('[SirahLaser] Wakeup successfull.\n');
	else
	 	error('Could not wake up laser.');
	end 
end