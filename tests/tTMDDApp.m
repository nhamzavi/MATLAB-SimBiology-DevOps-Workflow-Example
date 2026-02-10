classdef tTMDDApp < matlab.uitest.TestCase
    properties
        App
    end

    methods (TestMethodSetup)
        function suppressSnapshotWarning(testCase)
            import matlab.unittest.fixtures.SuppressedWarningsFixture;
            testCase.applyFixture(SuppressedWarningsFixture(...
                "MATLAB:appdesigner:appdesigner:SaveObjWarning"));
        end

        function launchApp(testCase)
            import matlab.unittest.diagnostics.ScreenshotDiagnostic;

            testCase.App = TMDDApp;
            testCase.addTeardown(@delete,testCase.App);
            
            % Take a snapshot at app open and close
            snapshot(testCase, "App open"); 
            testCase.addTeardown(@snapshot,testCase, "App close") 


            % Log a screenshot for any failure
            testCase.onFailure(ScreenshotDiagnostic);
        end
    end

    methods (Test)

        function testStartup(testCase)

            % Check plot update
            testCase.verifyNotEmpty(testCase.App.ROViewObj.lhRO.XData, "x values for RO should not be empty");
            testCase.verifyNotEmpty(testCase.App.ROViewObj.lhRO.YData, "y values for RO should not be empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhDrug.XData, "x values for Drug should not be empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhDrug.YData, "y values for Drug should not be empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhReceptor.XData, "x values for Receptor should not be empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhReceptor.YData, "y values for Receptor should not be empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhComplex.XData, "x values for Complex should not be empty");
            testCase.verifyNotEmpty(testCase.App.ConcViewObj.lhComplex.YData, "y values for Complex should not be empty");

            % Check NCA table
            testCase.verifyNotEmpty(testCase.App.NCAViewObj.NCAtable.Data,"NCA table should not be empty");

        end % testStartup

        function testChangeDosingAmountManualUpdate(testCase)

            app = testCase.App;

            % Deactivate automatic plot update
            testCase.choose(testCase.App.AutomaticUpdateSwitch,"Off");
         

            oldlhRO_XData       = app.ROViewObj.lhRO.XData;
            oldlhRO_YData       = app.ROViewObj.lhRO.YData;
            oldlhDrug_XData     = app.ConcViewObj.lhDrug.XData;
            oldlhDrug_YData     = app.ConcViewObj.lhDrug.YData;
            oldlhReceptor_XData = app.ConcViewObj.lhReceptor.XData;
            oldlhReceptor_YData = app.ConcViewObj.lhReceptor.YData;
            oldlhComplex_XData  = app.ConcViewObj.lhComplex.XData;
            oldlhComplex_YData  = app.ConcViewObj.lhComplex.YData;

            % Drag slider
            testCase.drag(app.DosingAmountSlider,100,200); % requires display 
            snapshot(testCase, "Post dosing adjustment");

            % Check plot update
            testCase.verifyEqual(oldlhRO_XData, app.ROViewObj.lhRO.XData, "x values for RO should not be updated");
            testCase.verifyEqual(oldlhRO_YData, app.ROViewObj.lhRO.YData, "y values for RO should not be updated");
            testCase.verifyEqual(oldlhDrug_XData, app.ConcViewObj.lhDrug.XData, "x values for Drug should not be updated");
            testCase.verifyEqual(oldlhDrug_YData, app.ConcViewObj.lhDrug.YData, "y values for Drug should not be updated");
            testCase.verifyEqual(oldlhReceptor_XData, app.ConcViewObj.lhReceptor.XData, "x values for Receptor should not be updated");
            testCase.verifyEqual(oldlhReceptor_YData, app.ConcViewObj.lhReceptor.YData, "y values for Receptor should not be updated");
            testCase.verifyEqual(oldlhComplex_XData, app.ConcViewObj.lhComplex.XData, "x values for Complex should not be updated");
            testCase.verifyEqual(oldlhComplex_YData, app.ConcViewObj.lhComplex.YData, "y values for Complex should not be updated");

            % Check that lamp is on
            testCase.verifyTrue(app.LampViewObj.IsOn, "The lamp should be on");

            % Update app to run simulation manually
            testCase.press(app.SimulateButton)
            snapshot(testCase, "Post simulation");

            % Check plot update
            testCase.verifyNotEqual(oldlhRO_XData, app.ROViewObj.lhRO.XData, "x values for RO should update");
            testCase.verifyNotEqual(oldlhRO_YData, app.ROViewObj.lhRO.YData, "y values for RO should update");
            testCase.verifyNotEqual(oldlhDrug_XData, app.ConcViewObj.lhDrug.XData, "x values for Drug should update");
            testCase.verifyNotEqual(oldlhDrug_YData, app.ConcViewObj.lhDrug.YData, "y values for Drug should update");
            testCase.verifyNotEqual(oldlhReceptor_XData, app.ConcViewObj.lhReceptor.XData, "x values for Receptor should update");
            testCase.verifyNotEqual(oldlhReceptor_YData, app.ConcViewObj.lhReceptor.YData, "y values for Receptor should update");
            testCase.verifyNotEqual(oldlhComplex_XData, app.ConcViewObj.lhComplex.XData, "x values for Complex should update");
            testCase.verifyNotEqual(oldlhComplex_YData, app.ConcViewObj.lhComplex.YData, "y values for Complex should update");

            % Check that lamp is set to false
            testCase.verifyFalse(app.LampViewObj.IsOn, "The lamp should be off");

        end % testChangeDosingAmountManualUpdate

    end

    methods(Access=private)
        function snapshot(testCase, diag)
            arguments
                testCase (1,1) matlab.uitest.TestCase
                diag matlab.unittest.diagnostics.Diagnostic
            end
            import matlab.unittest.diagnostics.FigureDiagnostic;

            testCase.log("Terse", [diag(:)', FigureDiagnostic(testCase.App.TMDDsimUIFigure)]);
        end
    end

end