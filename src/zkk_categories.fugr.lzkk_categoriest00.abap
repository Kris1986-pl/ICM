*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZKK_CATEGORIES..................................*
DATA:  BEGIN OF STATUS_ZKK_CATEGORIES                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZKK_CATEGORIES                .
CONTROLS: TCTRL_ZKK_CATEGORIES
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZKK_CATEGORIES                .
TABLES: ZKK_CATEGORIES                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
