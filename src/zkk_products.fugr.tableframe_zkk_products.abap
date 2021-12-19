*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZKK_PRODUCTS
*   generation date: 19.12.2021 at 14:50:42
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZKK_PRODUCTS       .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
