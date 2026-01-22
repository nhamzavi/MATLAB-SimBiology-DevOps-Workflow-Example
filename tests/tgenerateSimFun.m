classdef tgenerateSimFun < matlab.unittest.TestCase
    
    properties 
        MATfilename = "test_generateSimFun.mat"
        MATfilefullpath
        LoadedData
    end
    
    properties (TestParameter)
        fieldName = {"simFun","doseTable","dependenciesSimFun"};
    end

    methods(Test)

        function testMATfileCreation(testCase)
            % Verify that the MAT file is created
            testCase.verifyTrue(isfile(testCase.MATfilefullpath), 'MAT file was not created.');
        end

        function testSimFunctionCreation(testCase, fieldName)
            % Verify that the MAT file contains required fields
            testCase.verifyTrue(isfield(testCase.LoadedData, fieldName), fieldName + " was not saved in " + testCase.MATfilename);
        end

        %% Have attendees add this test?
        function testSimFunctionAcceleration(testCase)
            % Verify that the SimFunction is accelerated
            testCase.verifyTrue(testCase.LoadedData.simFun.isAccelerated, "simFun was not accelerated.");
        end

    end
    
    methods (TestClassSetup)
        
        function classSetup(testCase)
            % Set up shared state for all tests.

            % Test if the simulation function is created successfully
            testCase.MATfilefullpath = generateSimFun(testCase.MATfilename);
            testCase.LoadedData = load(testCase.MATfilefullpath);

            % Tear down with testCase.addTeardown.
            testCase.addTeardown(@delete,testCase.MATfilefullpath);

        end

    end
end