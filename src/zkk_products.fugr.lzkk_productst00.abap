*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZKK_PRODUCTS....................................*
DATA:  BEGIN OF STATUS_ZKK_PRODUCTS                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZKK_PRODUCTS                  .
CONTROLS: TCTRL_ZKK_PRODUCTS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZKK_PRODUCTS                  .
TABLES: ZKK_PRODUCTS                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
