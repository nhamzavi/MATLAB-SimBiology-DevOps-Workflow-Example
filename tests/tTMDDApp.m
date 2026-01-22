classdef tTMDDApp < matlab.uitest.TestCase
    properties
        App
    end

    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.App = TMDDApp;
            testCase.addTeardown(@delete,testCase.App)
        end
    end

    methods (Test)

        function testStartup(testCase)
           
            % Check plot update
            testCase.verifyNotEmpty(testCase.App.ROViewObj.lhRO.XData, "x values for RO are empty");
            testCase.verifyNotEmpty(testCase.App.ROViewObj.lhRO.YData, "y values for RO are empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhDrug.XData, "x values for Drug are empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhDrug.YData, "y values for Drug are empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhReceptor.XData, "x values for Receptor are empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhReceptor.YData, "y values for Receptor are empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhComplex.XData, "x values for Complex are empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhComplex.YData, "y values for Complex are empty");

            % Check NCA table
            testCase.verifyNotEmpty(testCase.App.NCAViewObj.NCAtable.Data,"NCA table is empty");
            
        end % testStartup


        function testChangeDosingAmountAutomaticUpdate(testCase)
            
            % Deactivate automatic plot update
            testCase.App.AutomaticupdateCheckBox.Value = false;

            % Simulate for drug=100
            testCase.App.DosingAmountField.Value = 100;
            testCase.App.updateApp();   

            oldlhRO_XData       = testCase.App.ROViewObj.lhRO.XData;
            oldlhRO_YData       = testCase.App.ROViewObj.lhRO.YData;
            oldlhDrug_XData     = testCase.App.ConcViewObj.lhDrug.XData;
            oldlhDrug_YData     = testCase.App.ConcViewObj.lhDrug.YData;
            oldlhReceptor_XData = testCase.App.ConcViewObj.lhReceptor.XData;
            oldlhReceptor_YData = testCase.App.ConcViewObj.lhReceptor.YData;
            oldlhComplex_XData  = testCase.App.ConcViewObj.lhComplex.XData;
            oldlhComplex_YData  = testCase.App.ConcViewObj.lhComplex.YData;

            % Activate automatic plot update
            testCase.App.AutomaticupdateCheckBox.Value = true;

            % Drag slider
            testCase.drag(testCase.App.DosingAmountSlider,100,200);
           
            % Check plot update
            testCase.verifyNotEqual(oldlhRO_XData, testCase.App.ROViewObj.lhRO.XData, "x values for RO not updated");
            testCase.verifyNotEqual(oldlhRO_YData, testCase.App.ROViewObj.lhRO.YData, "y values for RO not updated");
            testCase.verifyNotEqual(oldlhDrug_XData, testCase.App.ConcViewObj.lhDrug.XData, "x values for Drug not updated");
            testCase.verifyNotEqual(oldlhDrug_YData, testCase.App.ConcViewObj.lhDrug.YData, "y values for Drug not updated");
            testCase.verifyNotEqual(oldlhReceptor_XData, testCase.App.ConcViewObj.lhReceptor.XData, "x values for Receptor not updated");
            testCase.verifyNotEqual(oldlhReceptor_YData, testCase.App.ConcViewObj.lhReceptor.YData, "y values for Receptor not updated");
            testCase.verifyNotEqual(oldlhComplex_XData, testCase.App.ConcViewObj.lhComplex.XData, "x values for Complex not updated");
            testCase.verifyNotEqual(oldlhComplex_YData, testCase.App.ConcViewObj.lhComplex.YData, "y values for Complex not updated");

            % Check that lamp is set to false
            testCase.verifyFalse(testCase.App.LampViewObj.IsOn);
            
        end % testChangeDosingAmountAutomaticUpdate

        function testChangeDosingAmountManualUpdate(testCase)
            
            % Deactivate automatic plot update
            testCase.App.AutomaticupdateCheckBox.Value = false;

            oldlhRO_XData       = testCase.App.ROViewObj.lhRO.XData;
            oldlhRO_YData       = testCase.App.ROViewObj.lhRO.YData;
            oldlhDrug_XData     = testCase.App.ConcViewObj.lhDrug.XData;
            oldlhDrug_YData     = testCase.App.ConcViewObj.lhDrug.YData;
            oldlhReceptor_XData = testCase.App.ConcViewObj.lhReceptor.XData;
            oldlhReceptor_YData = testCase.App.ConcViewObj.lhReceptor.YData;
            oldlhComplex_XData  = testCase.App.ConcViewObj.lhComplex.XData;
            oldlhComplex_YData  = testCase.App.ConcViewObj.lhComplex.YData;

            % Drag slider
            testCase.drag(testCase.App.DosingAmountSlider,100,200);
           
            % Check plot update
            testCase.verifyEqual(oldlhRO_XData, testCase.App.ROViewObj.lhRO.XData, "x values for RO not updated");
            testCase.verifyEqual(oldlhRO_YData, testCase.App.ROViewObj.lhRO.YData, "y values for RO not updated");
            testCase.verifyEqual(oldlhDrug_XData, testCase.App.ConcViewObj.lhDrug.XData, "x values for Drug not updated");
            testCase.verifyEqual(oldlhDrug_YData, testCase.App.ConcViewObj.lhDrug.YData, "y values for Drug not updated");
            testCase.verifyEqual(oldlhReceptor_XData, testCase.App.ConcViewObj.lhReceptor.XData, "x values for Receptor not updated");
            testCase.verifyEqual(oldlhReceptor_YData, testCase.App.ConcViewObj.lhReceptor.YData, "y values for Receptor not updated");
            testCase.verifyEqual(oldlhComplex_XData, testCase.App.ConcViewObj.lhComplex.XData, "x values for Complex not updated");
            testCase.verifyEqual(oldlhComplex_YData, testCase.App.ConcViewObj.lhComplex.YData, "y values for Complex not updated");

            % Check that lamp is set to false
            testCase.verifyTrue(testCase.App.LampViewObj.IsOn);

            % Update app to run simulation manually
            testCase.App.updateApp();  
            
            % Check plot update
            testCase.verifyNotEqual(oldlhRO_XData, testCase.App.ROViewObj.lhRO.XData, "x values for RO not updated");
            testCase.verifyNotEqual(oldlhRO_YData, testCase.App.ROViewObj.lhRO.YData, "y values for RO not updated");
            testCase.verifyNotEqual(oldlhDrug_XData, testCase.App.ConcViewObj.lhDrug.XData, "x values for Drug not updated");
            testCase.verifyNotEqual(oldlhDrug_YData, testCase.App.ConcViewObj.lhDrug.YData, "y values for Drug not updated");
            testCase.verifyNotEqual(oldlhReceptor_XData, testCase.App.ConcViewObj.lhReceptor.XData, "x values for Receptor not updated");
            testCase.verifyNotEqual(oldlhReceptor_YData, testCase.App.ConcViewObj.lhReceptor.YData, "y values for Receptor not updated");
            testCase.verifyNotEqual(oldlhComplex_XData, testCase.App.ConcViewObj.lhComplex.XData, "x values for Complex not updated");
            testCase.verifyNotEqual(oldlhComplex_YData, testCase.App.ConcViewObj.lhComplex.YData, "y values for Complex not updated");

            % Check that lamp is set to false
            testCase.verifyFalse(testCase.App.LampViewObj.IsOn);

        end % testChangeDosingAmountManualUpdate

    end
end