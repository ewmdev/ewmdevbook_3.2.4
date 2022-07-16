*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 16.07.2022 at 02:26:58
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZEGF_MS_TARGET..................................*
DATA:  BEGIN OF STATUS_ZEGF_MS_TARGET                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEGF_MS_TARGET                .
CONTROLS: TCTRL_ZEGF_MS_TARGET
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZEGF_MS_TARGET                .
TABLES: ZEGF_MS_TARGET                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
