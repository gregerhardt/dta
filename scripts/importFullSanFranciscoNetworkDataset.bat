:: This file should run in an empty directory, all the way through.

:: DTA Anyway code location is required
IF NOT DEFINED DTA_CODE_DIR (
  echo Please set the DTA_CODE_DIR environment variable to the directory where DTA Anyway is installed.
  echo e.g. set DTA_CODE_DIR=Y:\Users\neema\dta
  goto done
)

:: let PYTHON know where to find it
set PYTHONPATH=%DTA_CODE_DIR%

::
:: 1) create the network from the Cube network
::
:convertStaticNetwork
python %DTA_CODE_DIR%\scripts\createSFNetworkFromCubeNetwork.py -n sf_nodes.shp -l sf_links.shp notused notused Y:\dta\SanFrancisco\2010\SanFranciscoSubArea_2010.net Y:\dta\SanFrancisco\2010\turnspm.pen Q:\GIS\Road\SFCLINES\AttachToCube\stclines.shp
:: primary output: Dynameq files sf_{scen,base,advn,ctrl}.dqt
:: log     output: createSFNetworkFromCubeNetwork.{DEBUG,INFO}.log
:: debug   output: sf_{links,nodes}.shp
IF ERRORLEVEL 1 goto done

::
:: 2) attach the signal data to the DTA network
::
:importSignals
python %DTA_CODE_DIR%\scripts\importExcelSignals.py . sf Y:\dta\SanFrancisco\2010\excelSignalCards 15:30 18:30
:: primary output: Dynameq files sf_signals_{scen,base,advn,ctrl}.dqt
:: log     output: importExcelSignals.{DEBUG,INFO}.log
IF ERRORLEVEL 1 goto done

::
:: 3) attach the transit lines to the DTA network
:: 
:importTransit
python %DTA_CODE_DIR%\scripts\importTPPlusTransitRoutes.py . sf Y:\dta\SanFrancisco\2010\transit\sfmuni.lin Y:\dta\SanFrancisco\2010\transit\bus.lin
:: primary output: Dynameq files sf_ptrn.dqt
:: log     output: importTPPlusTransitRoutes.{DEBUG,INFO}.log
IF ERRORLEVEL 1 goto done

:done