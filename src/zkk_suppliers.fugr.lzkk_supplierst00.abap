*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZKK_SUPPLIERS...................................*
DATA:  BEGIN OF STATUS_ZKK_SUPPLIERS                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZKK_SUPPLIERS                 .
CONTROLS: TCTRL_ZKK_SUPPLIERS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZKK_SUPPLIERS                 .
TABLES: ZKK_SUPPLIERS                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
