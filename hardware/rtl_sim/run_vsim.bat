SET altera_ver=%SIM_LIB_PATH%\altera_ver
SET lpm_ver=%SIM_LIB_PATH%\lpm_ver
SET sgate_ver=%SIM_LIB_PATH%\sgate_ver
SET altera_mf_ver=%SIM_LIB_PATH%\altera_mf_ver
SET altera_lnsim_ver=%SIM_LIB_PATH%\altera_lnsim_ver
SET fourteennm_ver=%SIM_LIB_PATH%\fourteennm_ver
SET fourteennm_ct1_ver=%SIM_LIB_PATH%\fourteennm_ct1_ver

%QUESTASIM%\vlib.exe work
SET PKT_FILE=.\\input_gen\\output.pkt

Setlocal EnableDelayedExpansion
  for /f "usebackq" %%b in (`type %PKT_FILE% ^| find "" /v /c`) do (
    SET /A PKT_FILE_NB_LINES=%%b
  )
)

xcopy ..\scripts\generated_files  src\common /E

%QUESTASIM%\vlog.exe +define+PKT_FILE=\"%PKT_FILE%\" +define+PKT_FILE_NB_LINES=%PKT_FILE_NB_LINES% *.sv -sv 
%QUESTASIM%\vlog.exe ./common/*.sv -sv
%QUESTASIM%\vlog.exe ./common/*.v
%QUESTASIM%\vlog.exe ./mspm/string_matcher/*.sv -sv

REM GUI full debug
REM %QUESTASIM%\vsim.exe tb -L %altera_mf_ver% -L %altera_lnsim_ver% -L %altera_ver% -L %lpm_ver% -L %sgate_ver% -L %fourteennm_ver% -L %fourteennm_ct1_ver% -voptargs="+acc"

REM Fast
%QUESTASIM%\vsim.exe -L %altera_mf_ver% -L %altera_lnsim_ver% -L %altera_ver% -L %lpm_ver% -L %sgate_ver% -L %fourteennm_ver% -L %fourteennm_ct1_ver% -c -do "run -all" tb
