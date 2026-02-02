classdef NCAView < handle
    
    properties ( Access = private ) 
        Model
        NCApanel
        GridLayout

    end

    properties ( Hidden )
        % Leave these properties Hidden but public to enable access for any test generated
        % with Copilot during workshop
        NCAtable
    end

    properties ( Access = public ) 
        FontName                (1,1) string = "Helvetica"
        NCAoptions              % options for NCA calculations
        ConcentrationColumnName (1,1) string = "Complex"
    end
    
    properties( Access = private )
        DataListener % listener
    end
    
    methods
        function obj = NCAView(parent, model)

            arguments
                parent 
                model (1,1) SimulationModel
            end
            
            ncapanel = uipanel(parent);
            ncapanel.Title = "NCA parameters for bound target ('" + ...
                obj.ConcentrationColumnName + "')";
            ncapanel.BackgroundColor = [1 1 1];
            ncapanel.FontName = obj.FontName;
            ncapanel.BorderType = 'none';

            % Create GridLayout
            gl = uigridlayout(ncapanel);
            gl.ColumnWidth = {'1x'};
            gl.RowHeight = {'1x'};
            gl.Padding = [0 0 0 0];
            gl.BackgroundColor = [1 1 1];

            % Create NCAtable
            ncat = uitable(gl);
        
            % save NCA options 
            opt = sbioncaoptions;
            opt.concentrationColumnName = obj.ConcentrationColumnName;
            opt.timeColumnName          = 'Time';
            opt.IVDoseColumnName        = 'Dose';

            % instantiate listener
            dataListener = event.listener( model, 'DataChanged', ...
                @obj.update );
            
            % store listeners
            obj.DataListener = dataListener;
            
            % save objects
            obj.Model = model;
            obj.NCAoptions = opt;
            obj.NCApanel = ncapanel;
            obj.GridLayout = gl;
            obj.NCAtable = ncat;
            
        end % constructor
        
   
    end % public methods
    
    methods ( Access = private )
        
        function update(obj,~,~)

            % compute NCA parameters and display them in table
            ncaParameters = sbionca(obj.Model.SimDataTable, obj.NCAoptions);
            obj.NCAtable.ColumnName = ncaParameters.Properties.VariableNames(2:end);
            obj.NCAtable.Data = ncaParameters(:,2:end);
            
        end % update

    end % private method
end % class

