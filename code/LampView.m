classdef LampView < handle

    properties ( Dependent )
        IsOn (1,1) logical
    end

    properties
        LampColorSucess  = [0.47, 0.67, 0.19]  % color of lamp if RO between thresholds after day 1
        LampColorFailure = [0.85, 0.33, 0.10]  % color of lamp if RO not between thresholds after day 1
    end

    properties ( SetAccess=private, GetAccess={?tTMDDApp} )
        LampObj
    end

    properties ( Access=private )
        Model
    end

    properties( Access = private )
        DataListener % listener
    end

    methods
        function obj = LampView(parent,model)

            lampObj = uilamp(parent);
            lampObj.Tooltip = compose("Target occupancy does not remain\n between thresholds");
            lampObj.Color = obj.LampColorFailure;

            % instantiate listener
            dataListener = event.listener( model, 'DataChanged', ...
                @obj.update );

            % store listeners
            obj.DataListener = dataListener;

            obj.LampObj = lampObj;
            obj.Model = model;

        end % constructor

        function set.IsOn(obj, value)
            % color lamp according to whether or not RO remains between thresholds after day 1
            if value
                obj.LampObj.Color = obj.LampColorSucess;
                obj.LampObj.Tooltip = compose("Target occupancy remains\n between thresholds");
            else
                obj.LampObj.Color = obj.LampColorFailure;
                obj.LampObj.Tooltip = compose("Target occupancy does not remain\n between thresholds");
            end

            obj.LampObj.UserData = value;

        end % set.IsOn

        function value = get.IsOn(obj)
                value = obj.LampObj.UserData;
        end % get.IsOn

    end % public methods

    methods ( Access = private )

        function update(obj,~,~)
                obj.IsOn = obj.Model.ROIsBetweenThresholds;
        end % update

    end % private method
end