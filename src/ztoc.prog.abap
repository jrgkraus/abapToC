*&---------------------------------------------------------------------*
*& Report ztoc
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztoc.

" -----------------------------------------------------------------------
TABLES: e070, e07t.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
SELECT-OPTIONS so_trnum FOR e070-trkorr. " Transport numbers
SELECT-OPTIONS so_owner FOR e070-as4user DEFAULT sy-uname. " Transport owners
SELECT-OPTIONS so_descr FOR e07t-as4text.
PARAMETERS p_reltr AS CHECKBOX. " Include released transports
PARAMETERS p_tocs AS CHECKBOX. " Include ToCs
PARAMETERS p_sub AS CHECKBOX. " Include subtransports
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
PARAMETERS p_destoc RADIOBUTTON GROUP desc DEFAULT 'X'.
PARAMETERS p_desori RADIOBUTTON GROUP desc.
PARAMETERS p_descus RADIOBUTTON GROUP desc.
SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-b03.
PARAMETERS p_maxwai TYPE i DEFAULT '60'.
SELECTION-SCREEN END OF BLOCK b03.

SELECTION-SCREEN BEGIN OF BLOCK b04 WITH FRAME TITLE TEXT-b04.
PARAMETERS p_layout TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK b04.

" -----------------------------------------------------------------------

INITIALIZATION.
  DATA(report) = NEW zcl_zabap_toc_report( report_id = sy-repid ).

  " -----------------------------------------------------------------------

START-OF-SELECTION.
  report->set_toc_description( toc_description = NEW #( COND #( WHEN p_destoc = abap_true THEN zcl_zabap_toc_description=>c_toc_description-toc
      WHEN p_desori = abap_true THEN zcl_zabap_toc_description=>c_toc_description-original
      WHEN p_descus = abap_true THEN zcl_zabap_toc_description=>c_toc_description-custom ) ) ).
  report->gather_transports( tranports = so_trnum[] owners = so_owner[] descriptions = so_descr[]
                             include_released = p_reltr include_tocs = p_tocs include_subtransports = p_sub ).
  report->display( p_layout ).

  " -----------------------------------------------------------------------

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.
  p_layout = report->get_layout_from_f4_selection( ).
