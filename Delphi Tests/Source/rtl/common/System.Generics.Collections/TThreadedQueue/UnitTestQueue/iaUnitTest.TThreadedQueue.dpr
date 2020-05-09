(*-----------------------------------------------------------------------------------------------------------------------
 Ideas Awakened, Inc ("COMPANY") CONFIDENTIAL

 Unpublished Copyright (c) 2019 Ideas Awakened Inc, All Rights Reserved.

 NOTICE:  All information contained herein is and remains the property of COMPANY. The intellectual and technical
 concepts contained herein are proprietary to COMPANY and may be covered by U.S. and Foreign Patents, patents in
 process, and are protected by trade secret or copyright law.

 Dissemination of this information or reproduction of this material is strictly forbidden unless prior written
 permission is obtained from COMPANY.

 Access to the source code contained herein is hereby forbidden to anyone except current COMPANY employees, managers
 or contractors who have executed Confidentiality and Non-disclosure agreements explicitly covering such access.

 The copyright notice above does not evidence any actual or intended publication or disclosure of this source code,
 which includes information that is confidential and/or proprietary, and is a trade secret, of COMPANY.

 ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC PERFORMANCE, OR PUBLIC DISPLAY OF OR THROUGH USE OF THIS SOURCE
 CODE WITHOUT THE EXPRESS WRITTEN CONSENT OF COMPANY IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE LAWS AND
 INTERNATIONAL TREATIES. THE RECEIPT OR POSSESSION OF THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR
 IMPLY ANY RIGHTS TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT
 MAY DESCRIBE, IN WHOLE OR IN PART.

 Ideas Awakened Inc is a privately held company headquartered in Geneseo, Illinois, USA.
 More information is available online at https://www.ideasawakend.com
 Copyright notice version 1.1 2019.12.29 {5A0254F2-D0A6-4059-A77C-C7AEDF3044BA}
-----------------------------------------------------------------------------------------------------------------------
Reminder, command line parameters to minimize output and remove input prompt:  -b -exit:Continue
*)
program iaUnitTest.TThreadedQueue;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  iaExample.ConsumerThread in 'iaExample.ConsumerThread.pas',
  iaExample.ProducerThread in 'iaExample.ProducerThread.pas',
  iaExample.TaskData in 'iaExample.TaskData.pas',
  iaTestSupport.Log in '..\..\..\..\..\iaTestSupport.Log.pas',
  iaUnitTest.TThreadedQueue.ExerciseQueue in 'iaUnitTest.TThreadedQueue.ExerciseQueue.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;

    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
