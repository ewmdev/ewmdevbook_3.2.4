*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZBKS_SRV_PROVIDE
*   generation date: 16.07.2022 at 02:26:57
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZBKS_SRV_PROVIDE   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
