classdef SimulationModel < handle
% Class to simulate the TMDD model
    
    properties ( SetAccess = private )
        DoseTable  % daily dose to apply to simulate
        SimFun     % exported SimFunction
        
        SimData
        SimDataTable
        
        ThresholdValues = [20, 80]  % threshold values

    end
    
    properties
        % original values for resetting
        Amount0           (1,1) double
        Duration0         (1,1) double
        Kon0              (1,1) double
        Kel0              (1,1) double
        Kdeg0             (1,1) double
        Interval0         (1,1) double
        ROIsBetweenThresholds (1,1) logical
    end

    events ( NotifyAccess = private )
        DataChanged
    end
    
    methods
        
        function obj = SimulationModel()
            % load Simfunction and dosing information
            load('simFunction_Dose.mat', 'simFun', 'doseTable');
            obj.SimFun    = simFun;
            obj.DoseTable = doseTable;

            
            % save original values to allow for resetting
            obj.Kel0  = obj.SimFun.Parameters.Value(1);
            obj.Kon0  = obj.SimFun.Parameters.Value(2);
            obj.Kdeg0 = obj.SimFun.Parameters.Value(3);
            obj.Duration0 = 119;
            obj.Interval0 = obj.DoseTable.Interval;
            obj.Amount0   = obj.DoseTable.Amount;
           
        end % constructor
        
    end
    
    methods
        
        function simulate(obj, parameters)
            
            arguments
                obj
                parameters (1,:) double
            end

            cellpar = num2cell(parameters);
            [kel, kon, kdeg,stopTime, amount, interval] = deal(cellpar{:});
            obj.DoseTable.Amount = amount;
            obj.DoseTable.Interval = interval;
                    
            sd = obj.SimFun([kel, kon, kdeg], stopTime, obj.DoseTable);
            t = array2table([sd.Time, sd.Data], 'VariableNames',[{'Time'}; sd.DataNames]);
            t.Properties.VariableUnits = [{'hours'}; cellfun(@(x) x.Units, sd.DataInfo, 'UniformOutput', false)];
                
            % add dosing information to table to compute NCA parameters
            t.Dose = NaN(height(t),1);
            dosingTimes = interval*(0:stopTime/interval);
            t.Dose(ismember(t.Time, dosingTimes)) = amount;
            idxNotIncreasing = diff(t.Time)<=0; % remove duplicates
            t(idxNotIncreasing,:) = [];

            % logical value to check whether or not RO remains between thresholds after day 1
            aboveThreshold1 = all(t.RO(t.Time >= 24) >= obj.ThresholdValues(1)/100);
            belowThreshold2 = all(t.RO(t.Time >= 24) <= obj.ThresholdValues(2)/100);
            obj.ROIsBetweenThresholds = aboveThreshold1 && belowThreshold2;

            obj.SimData = sd;
            obj.SimDataTable = t;

            notify( obj, 'DataChanged' );
            
        end % simulate
        
        
    end % public methods
    
    
end % classdef

