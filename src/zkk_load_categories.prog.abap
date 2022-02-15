*&---------------------------------------------------------------------*
*& Report zkk_load_categories
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_load_categories.


DATA: ls_categories     TYPE zkk_str_categories,
      lt_categories     TYPE zkk_tt_categories,
      lt_output       TYPE table_of_strings,
      lv_rc           TYPE i,
      lt_file_table   TYPE filetable.

PARAMETERS pa_path TYPE string LOWER CASE OBLIGATORY.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_path.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      file_filter             = '*.CSV'
    CHANGING
      file_table              = lt_file_table
      rc                      = lv_rc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF lt_file_table IS NOT INITIAL.
    pa_path = lt_file_table[ 1 ].
  ENDIF.

END-OF-SELECTION.

    cl_progress_indicator=>progress_indicate(
                         i_text = 'Uploading in progress'
                         i_output_immediately = abap_true ).

    cl_gui_frontend_services=>gui_upload(
     EXPORTING
       filename                = pa_path
     CHANGING
       data_tab                = lt_output
     EXCEPTIONS
       file_open_error         = 1
       file_read_error         = 2
       no_batch                = 3
       gui_refuse_filetransfer = 4
       invalid_type            = 5
       no_authority            = 6
       unknown_error           = 7
       bad_data_format         = 8
       header_not_allowed      = 9
       separator_not_allowed   = 10
       header_too_long         = 11
       unknown_dp_error        = 12
       access_denied           = 13
       dp_out_of_memory        = 14
       disk_full               = 15
       dp_timeout              = 16
       not_supported_by_gui    = 17
       error_no_gui            = 18
       OTHERS                  = 19 ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


LOOP AT lt_output INTO data(ls_output).
    SPLIT ls_output AT ',' INTO TABLE DATA(lt_split_dataset).

    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    IF sy-tabix = 1.
      CLEAR lt_split_dataset.
      CONTINUE.
    ENDIF.

    CHECK lt_split_dataset IS NOT INITIAL.

    ls_categories-scategoryid = lt_split_dataset[ 1 ].
    ls_categories-scategoriesname = lt_split_dataset[ 2 ].
    ls_categories-sdescripion = lt_split_dataset[ 3 ].

    APPEND ls_categories TO lt_categories.
    MODIFY zkk_categories FROM TABLE lt_categories.

ENDLOOP.
