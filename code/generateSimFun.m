function MATfilename = generateSimFun(MATfilename)

arguments
    MATfilename = "simFunction_Dose.mat"
end

% if only a file name without folder name is provided, make sure the MAT
% file is saved in the same directory as generateSimFun.m
if ~contains(MATfilename,filesep)
    fullpath = mfilename('fullpath');
    folder   = fileparts(fullpath);
    MATfilename = fullfile(folder,MATfilename);
end

% Load the SimBiology project into the workspace
s = sbioloadproject("TMDD.sbproj",'m1');
modelObj = s.m1;
doseObj = modelObj.getdose('Daily Dose');
basevariantObj = modelObj.getvariant('Estimated values');

% Use hours for dose timing and convert any day-based interval to hours
oldTimeUnit         = doseObj.TimeUnits;
doseObj.TimeUnits   = 'hour';
doseObj.Interval    = sbiounitcalculator(oldTimeUnit, ...
    doseObj.TimeUnits, doseObj.Interval);

% Increase the number of repeat doses for long simulations
doseObj.RepeatCount = 200;

% Save dose table for simulation
doseTable = doseObj.getTable();

% Create a simulation function 
simFun = modelObj.createSimFunction({'kel','kon','kdeg'}, ...
    {'Drug','Receptor','Complex','RO'}, doseObj.TargetName, basevariantObj);

% Compile the simulation function for faster execution
simFun.accelerate();
dependenciesSimFun = simFun.DependentFiles';

% Create MAT file
save(MATfilename,"simFun","doseTable","dependenciesSimFun");

end
