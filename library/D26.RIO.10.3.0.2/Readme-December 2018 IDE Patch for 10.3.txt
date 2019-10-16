December 2018 IDE Patch for 10.3

This patch fixes a few issues related with the RAD Studio IDE in 10.3, including problems building an UWP app for the Windows Store, missing application configuration options in C++Builder, the lack of DBExpress Enterprise drivers in Data Explorer and an incorrect configuration for the Android NDK.
 
The patch addresses the following issues reported on Quality Portal, and other related, reproducible issues logged internally by the support and QA teams:

RSP-22123: Deploying an App to the Windows Store fails
RSP-21683: Rio 10.3 IDE missing Application sub options [for C++Builder]
RSP-21791: IBTogo November 2018 fails on linker
RSP-22268: Android IBLite Linker Error
RSP-22081: Android FireIBLite no working

====== Patch installation steps:

Please follow the installation steps below:

1. Shut down RAD Studio

2.  Create a backup copy of the following files in your <install-root> directory, usually in C:\Program files (x86)\Embarcadero\Studio\20.0\

\bin\bcbide260.bpl
\bin\bcbide260.de
\bin\bcbide260.fr
\bin\bcbide260.ja
\bin\bcbide260.jdbg
\bin\coreide260.bpl
\bin\coreide260.de
\bin\coreide260.fr
\bin\coreide260.ja
\bin\coreide260.jdbg
\bin\DataExplorerDBXPluginInt260.bpl
\bin\DataExplorerDBXPluginInt260.de
\bin\DataExplorerDBXPluginInt260.fr
\bin\DataExplorerDBXPluginInt260.ja
\bin\DataExplorerDBXPluginInt260.jdbg
\bin\delphicoreide260.bpl
\bin\delphicoreide260.de
\bin\delphicoreide260.fr
\bin\delphicoreide260.ja
\bin\delphicoreide260.jdbg
\bin\getithelper260.dll
\bin\sdkmgride260.bpl
\bin\sdkmgride260.de
\bin\sdkmgride260.fr
\bin\sdkmgride260.ja
\bin\sdkmgride260.jdbg


3.  Replace the old files with new versions by copying the expanded content of this zip archive to <install-root> (requires admin permission)


If you’re not targeting Android, or using DBExpress, you can skip the steps below.


====== Additional steps for the Android NDK

4. To update an existing Android SDK/NDK platform configuration, first make sure you have properly installed the SDK/NDK, following the additional steps in the section “Android SDK/NDK Installation Steps” in the Release Notes at http://docwiki.embarcadero.com/RADStudio/Rio/en/Release_Notes#Android_SDK.2FNDK_Installation_Steps

4.1. In the RAD Studio IDE, select File > Close All

4.2 Open the Tools > Options dialog and select Deployment > SDK Manager

4.3 Select the Android SDK 25.2.5 32-bit from the SDK Versions list box (if one has been installed) and click Delete. If there is no Android SDK listed, ignore this step.

4.4 In the same window, click Add and in the Add a New SDK dialog box, choose Android from the Select a platform dropdown list and Add New... from the Select an SDK version dropdown list. This action opens the Create a new Android SDK dialog.

4.5 Now locate the Android SDK Base path and Android NDK Base path from the following root directories, depending on your installation:

Web/GetIt installation: 
C:\Users\Public\Documents\Embarcadero\Studio\20.0\CatalogRepository

Local/ISO installation: 
c:\Users\Public\Documents\Embarcadero\Studio\20.0\PlatformSDKs

====== Additional Steps for DBExpress Enterprise drivers

5. To enable the DBExpress Enterprise drivers in Data Explorer (applies only to customers of the Enterprise and Architect editions), follow the steps below:

5.1 Close the RAD Studio IDE

5.2 Open CMD.exe or PowerShell as Administrator. 

5.3 Type the following command. 


reg add HKLM\SOFTWARE\Embarcadero\BDS\20.0\ /v RegMergeTimeStamp /t REG_SZ /d "11-19-2018 0|00|00"  /reg:32

5.4 Open the "Install Packages" dialog from [Component | Install Packages...] menu. 

5.5. Find "DBExpress Enterprise Data Explore Integration", then turn on the check box and close the dialog


Copyright (c) 2018 Embarcadero Technologies, Inc. All rights reserved.
