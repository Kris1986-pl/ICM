*&---------------------------------------------------------------------*
*& Report zkk_helloworld
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_helloworld.
PARAMETERS pa_num TYPE i.

DATA gv_result TYPE i.

MOVE pa_num TO gv_result.

ADD 1 TO gv_result.

WRITE 'Your input:'.
WRITE pa_num.

NEW-LINE.

WRITE 'Result:    '.
WRITE gv_result.
