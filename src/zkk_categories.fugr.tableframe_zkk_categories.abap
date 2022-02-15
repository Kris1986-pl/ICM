*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZKK_CATEGORIES
*   generation date: 11.02.2022 at 14:00:54
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZKK_CATEGORIES     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
