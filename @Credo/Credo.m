% File: Credo.m @ Credo
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 22 Feb 2019
% Version: 0.1

% Description: class used to control the output

% in device manager: "USB Test and Measurement Device (IVI)"

classdef Credo < handle

	% Public and writeable properties
	properties
		wavelength double {mustBePositive, mustBeFinite};  % represents the wavelength of the laser in [nm]
	end

	properties (SetAccess = private)
		isConnected logical;
		isBusy logical;  % bool checking if any motor is busy
		usbObj;
	end

	properties(Hidden = true, Access = private)
	end

	properties(Constant, Hidden = true)
		WAVELENGTH_MAX = 900;  % [nm] (taken from manual)
		WAVELENGTH_MIN = 380;  % [nm] (taken from manual)
	end

	methods

		% Constructor for laser
		function Credo = Credo()
			% Find a VISA-USB object.
			temp = instrfind('Type', 'visa-usb');

			% Create the VISA-USB object if it does not exist
			% otherwise use the object that was found.
			if isempty(Credo.usbObj)
    			Credo.usbObj = visa('NI', 'USB0::0x17E7::0x0500::18-52-28::0::INSTR');
			else
    			fclose(Credo.usbObj);
    			Credo.usbObj = Credo.usbObj(1);
			end

			% Connect to instrument object, obj1.
			fopen(Credo.usbObj);
		end

		function delete(Credo)
			fclose(Credo.usbObj)
		end

		Clear_Error(sl);  % clears errors in class
		Halt_Motor(sl);  % stops all motor movement
		Wakeup(sl);  % wakes all components up after a sleep phase
		Sleep(sl);  % Make sirah laser fall asleep

		% check if device is busy
		function ib = get.isBusy(sl)
			fwrite(sl.usbObj, 'LAS:BUSY?');
			response = fscanf(sl.usbObj);
			if strcmp(response(1:10), ':LAS:BUSY:')
				if strcmp(response(12), '0')
					ib = 0;
				else
					ib = 1;
				end
			else
				error('Could not read motor status.')
			end
		end

		% check if connection is established
		function ic = get.isConnected(sl)
			if strcmp(sl.usbObj.Status, 'open')
				ic = 1;
			else
				ic = 0;
			end
		end

		% get currently set wavelength from laser
		function lambda = get.wavelength(sl)
			fwrite(sl.usbObj, 'LAS:WL?');
			response = fscanf(sl.usbObj);
			if strcmp(response(1:8), ':LAS:WL:')
				lambda = str2num(response(10:end));
			else
				error('Could not read wavelength');
			end
		end

		% Set wavelength of laser
		function set.wavelength(sl, lambda)
			% check if wavelength is in valid range
			if (lambda <= sl.WAVELENGTH_MAX) && (lambda >= sl.WAVELENGTH_MIN)
				% generate command string to set wavelength
				sendString = ['LAS:WL ', num2str(lambda)];
				fwrite(sl.usbObj, sendString);

				% check laser response if successfull
				if strcmp(fscanf(sl.usbObj), "OK")
					fprintf(['[Credo] Set wavelength to ', ...
						num2str(lambda), ' nm.\n'])
				else
					error('Could not set wavelength.')
				end
			else
				error('Wavelength not within valid range');
			end
		end

	end

end
