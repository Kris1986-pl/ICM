*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZKK_SUPPLIERS
*   generation date: 20.12.2021 at 08:42:25
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZKK_SUPPLIERS      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
