*&---------------------------------------------------------------------*
*& Include          YWIKAMMC002_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form f_init_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_init_data .

  REFRESH:
  gt_data_bar,
  gt_data_upb,
  gt_data_cst,
  gt_log.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_get_filepath
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- P_FILE
*&---------------------------------------------------------------------*
FORM f_get_filepath CHANGING fp_file.

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    EXPORTING
      static    = abap_true
    CHANGING
      file_name = fp_file.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_upload_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_upload_data.

  DATA: l_it_raw TYPE truxs_t_text_data.

  CASE abap_true.
    WHEN r_bar.
      CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
        EXPORTING
          i_field_seperator    = 'X'
          i_line_header        = 'X'
          i_tab_raw_data       = l_it_raw       " WORK TABLE
          i_filename           = p_file
        TABLES
          i_tab_converted_data = gt_data_bar    "ACTUAL DATA
        EXCEPTIONS
          conversion_failed    = 1
          OTHERS               = 2.

      IF gt_data_bar[] IS INITIAL.
        MESSAGE 'No Data Uploaded.' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
    WHEN r_upb.
      CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
        EXPORTING
          i_field_seperator    = 'X'
          i_line_header        = 'X'
          i_tab_raw_data       = l_it_raw       " WORK TABLE
          i_filename           = p_file
        TABLES
          i_tab_converted_data = gt_data_upb
        EXCEPTIONS
          conversion_failed    = 1
          OTHERS               = 2.
      IF gt_data_upb[] IS INITIAL.
        MESSAGE 'No Data Upload.' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
    WHEN r_cst.
      CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
        EXPORTING
          i_field_seperator    = 'X'
          i_line_header        = 'X'
          i_tab_raw_data       = l_it_raw       " WORK TABLE
          i_filename           = p_file
        TABLES
          i_tab_converted_data = gt_data_cst
        EXCEPTIONS
          conversion_failed    = 1
          OTHERS               = 2.
      IF gt_data_cst[] IS INITIAL.
        MESSAGE 'No Data Upload.' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
    WHEN r_csg.
      CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
        EXPORTING
          i_field_seperator    = 'X'
          i_line_header        = 'X'
          i_tab_raw_data       = l_it_raw       " WORK TABLE
          i_filename           = p_file
        TABLES
          i_tab_converted_data = gt_data_csg
        EXCEPTIONS
          conversion_failed    = 1
          OTHERS               = 2.
      IF gt_data_csg[] IS INITIAL.
        MESSAGE 'No Data Upload.' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.

    WHEN r_ast.
      CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
        EXPORTING
          i_field_seperator    = 'X'
          i_line_header        = 'X'
          i_tab_raw_data       = l_it_raw       " WORK TABLE
          i_filename           = p_file
        TABLES
          i_tab_converted_data = gt_data_ast    " ACTUAL DATA
*        EXCEPTIONS
*         conversion_failed    = 1
*         OTHERS               = 2
        .
      IF gt_data_ast[] IS INITIAL.
        MESSAGE 'No Data Upload.' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.

    WHEN r_trf.
      CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
        EXPORTING
          i_field_seperator    = 'X'
          i_line_header        = 'X'
          i_tab_raw_data       = l_it_raw       " WORK TABLE
          i_filename           = p_file
        TABLES
          i_tab_converted_data = gt_data_trf    "ACTUAL DATA
*        EXCEPTIONS
*         conversion_failed    = 1
*         OTHERS               = 2
        .
      IF gt_data_trf[] IS INITIAL.
        MESSAGE 'No Data Uploaded.' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_process_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_process_data.
  DATA: l_wa_log TYPE ty_log.


**------------end
  CASE abap_true.
    WHEN r_bar.
      PERFORM prepare_standard.

    WHEN r_upb.
      PERFORM prepare_upb.

    WHEN r_cst.
      PERFORM prepare_cst.

    WHEN r_csg.
      PERFORM prepare_csg.

    WHEN r_ast.
      PERFORM f_po_asset.

    WHEN r_trf.
      PERFORM f_po_transfer.
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_show_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_show_log .

  DATA:
    lo_flist TYPE REF TO cl_salv_functions_list,   "ALV Function List
    lo_alv   TYPE REF TO cl_salv_table,            "ALV Table
    lo_msg   TYPE REF TO cx_salv_msg,              "Error Msg
    l_v_msg  TYPE string.                          "Error Msg

  IF gt_log[] IS NOT INITIAL.

    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = gt_log.

** Set Function List - Toolbars
        lo_flist = lo_alv->get_functions( ).    "Get Toolbar functions
        lo_flist->set_all( abap_true ).         "All On
        lo_flist->set_view_lotus( abap_false ). "Lotus 123 off
        lo_flist->set_view_excel( abap_false ). "Excel in Place Off
        lo_flist->set_graphics( abap_false ).   "Graph tool off
** Display ALV
        lo_alv->display( ).

      CATCH cx_salv_msg INTO lo_msg.
        l_v_msg = lo_msg->get_text( ).
        MESSAGE l_v_msg TYPE c_i.
    ENDTRY.

  ELSE.
    MESSAGE 'No processing log.' TYPE 'I' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_add_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> L_V_IDX
*&      --> MESSAGE
*&---------------------------------------------------------------------*
FORM f_add_log USING p_l_v_idx
                         p_message
                CHANGING p_l_v_err.

  DATA: l_wa_log TYPE ty_log.

  l_wa_log-line = p_l_v_idx.
  l_wa_log-type = 'E'.
  l_wa_log-message = p_message.
  APPEND l_wa_log TO gt_log.
  CLEAR l_wa_log.

  p_l_v_err = abap_true.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form prepare_standard
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM prepare_standard .
  DATA: lv_tabix TYPE sy-tabix VALUE 1.

  "Logic data banyak
  LOOP AT gt_data_bar INTO gs_data_bar.

    IF gs_data_bar-doc_no IS NOT INITIAL.
      CLEAR : gs_poheader, gs_poheaderx.
      "PO_header
      gs_poheader-po_number = gs_data_bar-doc_no.
      gs_poheader-comp_code = gs_data_bar-comp_cod.
      gs_poheader-doc_type = gs_data_bar-doc_type.
      CONCATENATE '000' gs_data_bar-vendor INTO gs_poheader-vendor.
      gs_poheader-doc_date = gs_data_bar-doc_date.
      gs_poheader-purch_org = gs_data_bar-purch_or.
      gs_poheader-pur_group = gs_data_bar-purch_group.
      gs_poheader-reason_cancel = gs_data_bar-reason_canc.
      gs_poheader-langu = sy-langu.

      gs_poheaderx-po_number = 'X'.
      gs_poheaderx-comp_code = 'X'.
      gs_poheaderx-doc_type = 'X'.
      gs_poheaderx-vendor = 'X'.
      gs_poheaderx-doc_date = 'X'.
      gs_poheaderx-purch_org = 'X'.
      gs_poheaderx-pur_group = 'X'.
      gs_poheaderx-reason_cancel = 'X'.
      gs_poheaderx-langu = 'X'.
    ENDIF.

    "PO_Item
    gs_poitem-po_item = gs_data_bar-po_item.
    CONCATENATE '000000000000' gs_data_bar-material INTO gs_poitem-material.
    gs_poitem-quantity = gs_data_bar-quant.
    gs_poitem-plant = gs_data_bar-plant.
    gs_poitem-stge_loc = gs_data_bar-stge_loc.
    gs_poitem-net_price = gs_data_bar-net_price.
    gs_poitem-po_unit = gs_data_bar-po_unit.

    IF gs_poitem-po_item IS NOT INITIAL.
      gs_poitemx-po_item = gs_data_bar-po_item.
      gs_poitemx-material = 'X'.
      gs_poitemx-quantity = 'X'.
      gs_poitemx-plant = 'X'.
      gs_poitemx-stge_loc = 'X'.
      gs_poitemx-net_price = 'X'.
      gs_poitemx-po_unit = 'X'.
    ENDIF.

    "PO_Schedule
    gs_poschedule-po_item = gs_data_bar-po_item.
    gs_poschedule-delivery_date = gs_data_bar-deliv_date.

    IF gs_poschedule-po_item IS NOT INITIAL.
      gs_poschedulex-po_item = gs_data_bar-po_item.
      gs_poschedulex-po_itemx = 'X'.
      gs_poschedulex-delivery_date = 'X'.
    ENDIF.

    APPEND gs_poitem TO gt_poitem.
    APPEND gs_poitemx TO gt_poitemx.
    APPEND gs_poschedule TO gt_poschedule.
    APPEND gs_poschedulex TO gt_poschedulex.

    CLEAR : gs_poitem, gs_poitemx, gs_poschedule, gs_poschedulex, gs_poaccount, gs_poaccountx.
    lv_tabix = lv_tabix + 1.

    READ TABLE gt_data_bar INTO DATA(gs_data_bar1) INDEX lv_tabix.  "index skrg + 1.
    IF sy-subrc = 0.
      IF gs_data_bar1-doc_no IS INITIAL.
        CONTINUE.
      ELSEIF gs_data_bar1-doc_no IS NOT INITIAL.
        PERFORM bapi.
      ENDIF.
    ELSEIF sy-subrc <> 0.
      PERFORM bapi.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form prepare_upb
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM prepare_upb .
  DATA: lv_tabix TYPE sy-tabix VALUE 1.

  LOOP AT gt_data_upb INTO gs_data_upb.
    IF gs_data_upb-doc_no IS NOT INITIAL.                       "PO_berbeda
      CLEAR : gs_poheader, gs_poheaderx.
      "PO_Header
      gs_poheader-po_number = gs_data_upb-doc_no.
      gs_poheader-comp_code = gs_data_upb-comp_cod.
      gs_poheader-doc_type = gs_data_upb-doc_type.
      CONCATENATE '000' gs_data_upb-vendor INTO gs_poheader-vendor.
      gs_poheader-doc_date = gs_data_upb-doc_date.
      gs_poheader-purch_org = gs_data_upb-purch_or.
      gs_poheader-pur_group = gs_data_upb-purch_group.
      gs_poheader-reason_cancel = gs_data_upb-reason_canc.
      gs_poheader-langu = sy-langu.

      gs_poheaderx-po_number = 'X'.
      gs_poheaderx-comp_code = 'X'.
      gs_poheaderx-doc_type = 'X'.
      gs_poheaderx-vendor = 'X'.
      gs_poheaderx-doc_date = 'X'.
      gs_poheaderx-purch_org = 'X'.
      gs_poheaderx-pur_group = 'X'.
      gs_poheaderx-reason_cancel = 'X'.
      gs_poheaderx-langu = 'X'.
    ENDIF.

    "PO_Item
    gs_poitem-po_item = gs_data_upb-po_item.
    CONCATENATE '000000000000' gs_data_upb-material INTO gs_poitem-material.
    gs_poitem-quantity = gs_data_upb-quant.
    gs_poitem-plant = gs_data_upb-plant.
    gs_poitem-stge_loc = gs_data_upb-stge_loc.
    gs_poitem-net_price = gs_data_upb-net_price.
    gs_poitem-batch = gs_data_upb-batch.
    gs_poitem-po_unit = gs_data_upb-po_unit.

    IF gs_poitem-po_item IS NOT INITIAL.
      gs_poitemx-po_item = gs_data_upb-po_item.
      gs_poitemx-material = 'X'.
      gs_poitemx-quantity = 'X'.
      gs_poitemx-plant = 'X'.
      gs_poitemx-stge_loc = 'X'.
      gs_poitemx-net_price = 'X'.
      gs_poitemx-batch = 'X'.
      gs_poitemx-po_unit = 'X'.
    ENDIF.

    "PO_Schedule
    gs_poschedule-po_item = gs_data_upb-po_item.
    gs_poschedule-delivery_date = gs_data_upb-deliv_date.

    IF gs_poschedule-po_item IS NOT INITIAL.
      gs_poschedulex-po_item = gs_data_upb-po_item.
      gs_poschedulex-po_itemx = 'X'.
      gs_poschedulex-delivery_date = 'X'.
    ENDIF.

    APPEND gs_poitem TO gt_poitem.
    APPEND gs_poitemx TO gt_poitemx.
    APPEND gs_poschedule TO gt_poschedule.
    APPEND gs_poschedulex TO gt_poschedulex.

    CLEAR : gs_poitem, gs_poitemx, gs_poschedule, gs_poschedulex, gs_poaccount, gs_poaccountx.
    lv_tabix = lv_tabix + 1.

    READ TABLE gt_data_upb INTO DATA(gs_data_upb1) INDEX lv_tabix.  "index skrg + 1.
    IF sy-subrc = 0.
      IF gs_data_upb1-doc_no IS INITIAL.
        CONTINUE.
      ELSEIF gs_data_upb1-doc_no IS NOT INITIAL.
        PERFORM bapi.
      ENDIF.
    ELSEIF sy-subrc <> 0.
      PERFORM bapi.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form prepare_cst
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM prepare_cst .
  DATA: lv_tabix TYPE sy-tabix VALUE 1.

  LOOP AT gt_data_cst INTO gs_data_cst.

    IF gs_data_cst-doc_no IS NOT INITIAL.
      CLEAR : gs_poheader, gs_poheaderx.
      "PO_Header
      gs_poheader-po_number = gs_data_cst-doc_no.
      gs_poheader-comp_code = gs_data_cst-comp_cod.
      gs_poheader-doc_type = gs_data_cst-doc_type.
      CONCATENATE '000' gs_data_cst-vendor INTO gs_poheader-vendor.
      gs_poheader-doc_date = gs_data_cst-doc_date.
      gs_poheader-purch_org = gs_data_cst-purch_or.
      gs_poheader-pur_group = gs_data_cst-purch_group.
      gs_poheader-reason_cancel = gs_data_cst-reason_canc.
      gs_poheader-langu = sy-langu.

      gs_poheaderx-po_number = 'X'.
      gs_poheaderx-comp_code = 'X'.
      gs_poheaderx-doc_type = 'X'.
      gs_poheaderx-vendor = 'X'.
      gs_poheaderx-doc_date = 'X'.
      gs_poheaderx-purch_org = 'X'.
      gs_poheaderx-pur_group = 'X'.
      gs_poheaderx-reason_cancel = 'X'.
      gs_poheaderx-langu = 'X'.
    ENDIF.

    "PO_Item
    gs_poitem-po_item = gs_data_cst-po_item.
    gs_poitem-acctasscat = gs_data_cst-acc_assg.
    gs_poitem-quantity = gs_data_cst-quant.
    gs_poitem-plant = gs_data_cst-plant.
    gs_poitem-net_price = gs_data_cst-net_price.

    IF gs_poitem-po_item IS NOT INITIAL.
      gs_poitemx-po_item = gs_data_cst-po_item.
      gs_poitemx-po_itemx = 'X'.
      gs_poitemx-acctasscat = 'X'.
      gs_poitemx-quantity = 'X'.
      gs_poitemx-plant = 'X'.
      gs_poitemx-net_price = 'X'.
    ENDIF.

    IF gs_data_cst-material IS NOT INITIAL.
      "Item
      CONCATENATE '000000000000' gs_data_cst-material INTO gs_poitem-material.
      gs_poitemx-material = 'X'.
    ELSEIF gs_data_cst-material IS INITIAL.
      "Item
      gs_poitem-short_text = gs_data_cst-short_txt.
      gs_poitem-po_unit = gs_data_cst-po_unit.
      gs_poitem-matl_group = gs_data_cst-material_grp.

      gs_poitemx-short_text = 'X'.
      gs_poitemx-po_unit = 'X'.
      gs_poitemx-matl_group = 'X'.
    ENDIF.

*PO_Schedule
    gs_poschedule-po_item = gs_data_cst-po_item.
    gs_poschedule-delivery_date = gs_data_cst-deliv_date.

    IF gs_data_cst-po_item IS NOT INITIAL.
      gs_poschedulex-po_item = gs_data_cst-po_item.
      gs_poschedulex-po_itemx = 'X'.
      gs_poschedulex-delivery_date = 'X'.
    ENDIF.

*PO_Account
    gs_poaccount-po_item = gs_data_cst-po_item.
    CONCATENATE '00' gs_data_cst-gl_acc INTO gs_poaccount-gl_account.
    gs_poaccount-costcenter = gs_data_cst-cost_cntr.

    IF gs_data_cst-po_item IS NOT INITIAL.
      gs_poaccountx-po_item = gs_data_cst-po_item.
      gs_poaccountx-po_itemx = 'X'.
      gs_poaccountx-gl_account = 'X'.
      gs_poaccountx-costcenter = 'X'.
    ENDIF.

    APPEND gs_poitem TO gt_poitem.
    APPEND gs_poitemx TO gt_poitemx.
    APPEND gs_poschedule TO gt_poschedule.
    APPEND gs_poschedulex TO gt_poschedulex.
    APPEND gs_poaccount TO gt_poaccount.
    APPEND gs_poaccountx TO gt_poaccountx.

    CLEAR : gs_poitem, gs_poitemx, gs_poschedule, gs_poschedulex, gs_poaccount, gs_poaccountx.
    lv_tabix = lv_tabix + 1.

    READ TABLE gt_data_cst INTO DATA(gs_data_cst1) INDEX lv_tabix.
    IF sy-subrc = 0.
      IF gs_data_cst1-doc_no IS INITIAL.
        CONTINUE.
      ELSEIF gs_data_cst1-doc_no IS NOT INITIAL.
        PERFORM bapi.
      ENDIF.
    ELSEIF sy-subrc <> 0.
      PERFORM bapi.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form prepare_csg
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM prepare_csg .
  DATA: lv_tabix TYPE sy-tabix VALUE 1.

  LOOP AT gt_data_csg INTO gs_data_csg.

    IF gs_data_csg-doc_no IS NOT INITIAL.
      CLEAR : gs_poheader, gs_poheaderx.
      "PO_Header
      gs_poheader-po_number = gs_data_csg-doc_no.
      gs_poheader-comp_code = gs_data_csg-comp_cod.
      gs_poheader-doc_type = gs_data_csg-doc_type.
      CONCATENATE '000' gs_data_csg-vendor INTO gs_poheader-vendor.
      gs_poheader-doc_date = gs_data_csg-doc_date.
      gs_poheader-purch_org = gs_data_csg-purch_or.
      gs_poheader-pur_group = gs_data_csg-purch_group.
      gs_poheader-reason_cancel = gs_data_csg-reason_canc.
      gs_poheader-langu = sy-langu.

      gs_poheaderx-po_number = 'X'.
      gs_poheaderx-comp_code = 'X'.
      gs_poheaderx-doc_type = 'X'.
      gs_poheaderx-vendor = 'X'.
      gs_poheaderx-doc_date = 'X'.
      gs_poheaderx-purch_org = 'X'.
      gs_poheaderx-pur_group = 'X'.
      gs_poheaderx-reason_cancel = 'X'.
      gs_poheaderx-langu = 'X'.
    ENDIF.

    "PO_Item
    gs_poitem-po_item = gs_data_csg-po_item.
    CONCATENATE '000000000000' gs_data_csg-material INTO gs_poitem-material.
    gs_poitem-quantity = gs_data_csg-quant.
    gs_poitem-plant = gs_data_csg-plant.
    gs_poitem-po_unit = gs_data_csg-po_unit.
    gs_poitem-item_cat = gs_data_csg-item_cat.

    IF gs_poitem-po_item IS NOT INITIAL.
      gs_poitemx-po_item = gs_data_csg-po_item.
      gs_poitemx-material = 'X'.
      gs_poitemx-quantity = 'X'.
      gs_poitemx-plant = 'X'.
      gs_poitemx-po_unit = 'X'.
      gs_poitemx-item_cat = 'X'.
    ENDIF.

    "PO_Schedule
    gs_poschedule-po_item = gs_data_csg-po_item.
    gs_poschedule-delivery_date = gs_data_csg-deliv_date.

    IF gs_poschedule-po_item IS NOT INITIAL.
      gs_poschedulex-po_item = gs_data_csg-po_item.
      gs_poschedulex-po_itemx = 'X'.
      gs_poschedulex-delivery_date = 'X'.
    ENDIF.

    APPEND gs_poitem TO gt_poitem.
    APPEND gs_poitemx TO gt_poitemx.
    APPEND gs_poschedule TO gt_poschedule.
    APPEND gs_poschedulex TO gt_poschedulex.

    CLEAR : gs_poitem, gs_poitemx, gs_poschedule, gs_poschedulex, gs_poaccount, gs_poaccountx.
    lv_tabix = lv_tabix + 1.

    READ TABLE gt_data_csg INTO DATA(gs_data_csg1) INDEX lv_tabix.
    IF sy-subrc = 0.
      IF gs_data_csg1-doc_no IS INITIAL.
        CONTINUE.
      ELSEIF gs_data_csg1-doc_no IS NOT INITIAL.
        PERFORM bapi.
      ENDIF.
    ELSEIF sy-subrc <> 0.
      PERFORM bapi.
    ENDIF.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_po_transfer
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_po_transfer .
  DATA: lv_index      TYPE sy-tabix,
        lv_next_index TYPE sy-tabix.

  LOOP AT gt_data_trf INTO DATA(ls_data_trf).

    lv_index = sy-tabix.

    "INI HEADER
    IF ls_data_trf-po_number IS NOT INITIAL.
*   POHEADER
      gs_poheader-po_number = ls_data_trf-po_number.
      gs_poheader-comp_code = ls_data_trf-comp_code.
      gs_poheader-doc_type = ls_data_trf-doc_type.
      gs_poheader-suppl_plnt = ls_data_trf-suppl_plnt.

*      REPLACE ALL OCCURRENCES OF ls_data_trf-doc_date IN lv_special_chars WITH ''.
      REPLACE ALL OCCURRENCES OF REGEX '[^0-9a-zA-Z]' IN ls_data_trf-doc_date WITH ''.
      CONCATENATE ls_data_trf-doc_date+6(4) ls_data_trf-doc_date+2(2) ls_data_trf-doc_date+0(2) INTO ls_data_trf-doc_date.
      gs_poheader-doc_date = ls_data_trf-doc_date.
      gs_poheader-purch_org = ls_data_trf-purch_org.
      gs_poheader-pur_group = ls_data_trf-pur_group.
      gs_poheader-reason_cancel = ls_data_trf-reason_cancel.
*   POHEADERX
      gs_poheaderx-po_number = 'X'.
      gs_poheaderx-comp_code = 'X'.
      gs_poheaderx-doc_type = 'X'.
      gs_poheaderx-suppl_plnt = 'X'.
      gs_poheaderx-doc_date = 'X'.
      gs_poheaderx-purch_org = 'X'.
      gs_poheaderx-pur_group = 'X'.
      gs_poheaderx-reason_cancel = 'X'.
    ENDIF.

*   POITEM
    gs_poitem-po_item = ls_data_trf-po_item.
*    gs_poitem-material = ls_data_trf-material.
    CONCATENATE '000000000000' ls_data_trf-material INTO gs_poitem-material.
    gs_poitem-quantity = ls_data_trf-quantity.
    gs_poitem-plant = ls_data_trf-plant.
    gs_poitem-stge_loc = ls_data_trf-stge_loc.
    gs_poitem-po_unit = ls_data_trf-po_unit.

*   POITEMX
    gs_poitemx-po_item = gs_poitem-po_item.
    gs_poitemx-po_itemx = 'X'.
    gs_poitemx-material = 'X'.
    gs_poitemx-quantity = 'X'.
    gs_poitemx-plant = 'X'.
    gs_poitemx-stge_loc = 'X'.
    gs_poitemx-po_unit = 'X'.

*   PO_Schedule
    gs_poschedule-po_item = ls_data_trf-po_item.
    gs_poschedule-delivery_date = ls_data_trf-delivery_date.

    IF gs_poschedule-po_item IS NOT INITIAL.
      gs_poschedulex-po_item = gs_poitem-po_item.
      gs_poschedulex-po_itemx = 'X'.
      gs_poschedulex-delivery_date = 'X'.
    ENDIF.

    APPEND gs_poitem TO gt_poitem.
    APPEND gs_poitemx TO gt_poitemx.
    APPEND gs_poschedule TO gt_poschedule.
    APPEND gs_poschedulex TO gt_poschedulex.

    CLEAR : gs_poitem, gs_poitemx, gs_poschedule, gs_poschedulex.

    lv_next_index = lv_index + 1.
    READ TABLE gt_data_trf INTO DATA(lv_next) INDEX lv_next_index.
    IF sy-subrc EQ 0.
      IF lv_next-po_number IS INITIAL AND lv_index NE lines( GT_data_ast ).
        CONTINUE.
      ENDIF.

      IF lv_next-po_number IS NOT INITIAL.
        PERFORM bapi.
        CLEAR : gs_poheader, gs_poheaderx.
      ENDIF.
    ENDIF.

    IF lv_index = lines( gt_data_trf ).
      PERFORM bapi.
      CLEAR : gs_poheader, gs_poheaderx.
    ENDIF.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_PO_asset
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_po_asset.
  DATA : lv_flag_po(20) TYPE c.

  DATA: lv_index      TYPE sy-tabix,
        lv_next_index TYPE sy-tabix.

* Populate Data for BAPI PO CREATE
  LOOP AT gt_data_ast INTO DATA(ls_data_ast).

    lv_index = sy-tabix.

    CLEAR lv_flag_po.

*   PO Tanpa PR
    IF ls_data_ast-preq_no IS INITIAL AND ls_data_ast-material IS INITIAL.
      lv_flag_po = 'PO Tanpa PR'.

*   PO_Item
      gs_poitem-po_item = ls_data_ast-po_item.
      gs_poitem-short_text = ls_data_ast-short_text.
      gs_poitem-quantity = ls_data_ast-quantity.
      gs_poitem-po_unit = ls_data_ast-po_unit.
      gs_poitem-acctasscat = 'A'. " ls_data_ast-acctasscat.
      gs_poitem-net_price = ls_data_ast-net_price.
      gs_poitem-matl_group = ls_data_ast-matl_group.
      gs_poitem-plant = ls_data_ast-plant.

*   POITEMX
      gs_poitemx-po_item = ls_data_ast-po_item..
      gs_poitemx-po_itemx = 'X'.
      gs_poitemx-short_text = 'X'.
      gs_poitemx-quantity = 'X'.
      gs_poitemx-po_unit = 'X'.
      gs_poitemx-acctasscat = 'X'.
      gs_poitemx-net_price = 'X'.
      gs_poitemx-matl_group = 'X'.
      gs_poitemx-plant = 'X'.

*   POSCHEDULE
      gs_poschedule-po_item = ls_data_ast-po_item.
      gs_poschedule-delivery_date = ls_data_ast-deliv_date.
*      CONCATENATE ls_data_ast-deliv_date+6(2) ls_data_ast-deliv_date+4(2) ls_data_ast-deliv_date+0(4) INTO gs_poschedule-delivery_date.


*   POSCHEDULEX
      gs_poschedulex-po_item = ls_data_ast-po_item.
      gs_poschedulex-po_itemx = 'X'.
      gs_poschedulex-delivery_date = 'X'.

*   POACCOUNT
      gs_poaccount-po_item = ls_data_ast-po_item.
      gs_poaccount-asset_no = ls_data_ast-asset_no.

*   POACCOUNTX
      gs_poaccountx-po_item = ls_data_ast-po_item.
      gs_poaccountx-po_itemx = 'X'.
      gs_poaccountx-asset_no = 'X'.

    ENDIF.

*   PO Dengan PR
    IF ls_data_ast-preq_no IS NOT INITIAL AND ls_data_ast-material IS INITIAL.
      lv_flag_po = 'PO Dengan PR'.

*   PO_Item
      gs_poitem-po_item = ls_data_ast-po_item.
      gs_poitem-preq_no = ls_data_ast-preq_no.
      gs_poitem-preq_item = ls_data_ast-preq_item.


*   POITEMX
      gs_poitemx-po_item = ls_data_ast-po_item.
      gs_poitemx-po_itemx = 'X'.
      gs_poitemx-preq_no = 'X'.
      gs_poitemx-preq_item = 'X'.


*   POSCHEDULE
      gs_poschedule-po_item = ls_data_ast-po_item.
      gs_poschedule-delivery_date = ls_data_ast-deliv_date.
*      CONCATENATE ls_data_ast-deliv_date+6(2) ls_data_ast-deliv_date+4(2) ls_data_ast-deliv_date+0(4) INTO gs_poschedule-delivery_date.

*   POSCHEDULEX
      gs_poschedulex-po_item = ls_data_ast-po_item.
      gs_poschedulex-po_itemx = 'X'.
      gs_poschedulex-delivery_date = 'X'.

    ENDIF.

*   PO Dengan Material Master
    IF ls_data_ast-preq_no IS INITIAL AND ls_data_ast-material IS NOT INITIAL.
      lv_flag_po = 'PO Dengan Material Master'.

*   PO_Item
      gs_poitem-po_item = ls_data_ast-po_item.
      gs_poitem-short_text = ls_data_ast-short_text.
      gs_poitem-quantity = ls_data_ast-quantity.

*      gs_poitem-material = ls_data_ast-material.
      CONCATENATE '000000000000' ls_data_ast-material INTO gs_poitem-material.

      gs_poitem-acctasscat = 'A'. " ls_data_ast-acctasscat.
      gs_poitem-net_price = ls_data_ast-net_price.
      gs_poitem-plant = ls_data_ast-plant.

*   POITEMX
      gs_poitemx-po_item = ls_data_ast-po_item.
      gs_poitemx-po_itemx = 'X'.
      gs_poitemx-short_text = 'X'.
      gs_poitemx-quantity = 'X'.
      gs_poitemx-material = 'X'.
      gs_poitemx-acctasscat = 'X'.
      gs_poitemx-net_price = 'X'.
      gs_poitemx-matl_group = 'X'.
      gs_poitemx-plant = 'X'.

*   POSCHEDULE
      gs_poschedule-po_item = ls_data_ast-po_item.
      gs_poschedule-delivery_date = ls_data_ast-deliv_date.

*   POSCHEDULEX
      gs_poschedulex-po_item = ls_data_ast-po_item.
      gs_poschedulex-po_itemx = 'X'.
      gs_poschedulex-delivery_date = 'X'.

*   POACCOUNT
      gs_poaccount-po_item = ls_data_ast-po_item.
      gs_poaccount-asset_no = ls_data_ast-asset_no.

*   POACCOUNTX
      gs_poaccountx-po_item = ls_data_ast-po_item.
      gs_poaccountx-po_itemx = 'X'.
      gs_poaccountx-asset_no = 'X'.
    ENDIF.

*   PREPRARE DATA HEADER
    IF ls_data_ast-po_number IS NOT INITIAL.
*   PO_Header
      gs_poheader-po_number = ls_data_ast-po_number.
      gs_poheader-comp_code = ls_data_ast-comp_code.
      gs_poheader-doc_type = ls_data_ast-doc_type.
*      gs_poheader-vendor = ls_data_ast-vendor.
      CONCATENATE '000' ls_data_ast-vendor INTO gs_poheader-vendor.

      PERFORM f_date_fix CHANGING ls_data_ast-doc_date.
      gs_poheader-doc_date = ls_data_ast-doc_date.

      gs_poheader-pur_group = '201'. "ls_data_ast-purch_org.
      IF lv_flag_po EQ 'PO Dengan PR'.
        CLEAR: gs_poheader-pur_group , gs_poheaderx-pur_group.
      ENDIF.

      gs_poheader-purch_org = ls_data_ast-purch_org.
      gs_poheader-reason_cancel = ls_data_ast-reason_cancel.
      gs_poheader-langu = sy-langu.

*   POHEADERX
      gs_poheaderx-po_number = 'X'.
      gs_poheaderx-comp_code = 'X'.
      gs_poheaderx-doc_type = 'X'.
      gs_poheaderx-vendor = 'X'.
      gs_poheaderx-doc_date = 'X'.
      gs_poheaderx-purch_org = 'X'.
      gs_poheaderx-pur_group = 'X'.
      gs_poheaderx-reason_cancel = 'X'.
      gs_poheaderx-langu = 'X'.
    ENDIF.

    APPEND gs_poitem TO gt_poitem.
    APPEND gs_poitemx TO gt_poitemx.
    APPEND gs_poschedule TO gt_poschedule.
    APPEND gs_poschedulex TO gt_poschedulex.

    CLEAR : gs_poitem,gs_poitem ,gs_poschedule,gs_poschedulex.

    IF gs_poaccount IS NOT INITIAL.
      APPEND gs_poaccount TO gt_poaccount.
      APPEND gs_poaccountx TO gt_poaccountx.
      CLEAR : gs_poaccount, gs_poaccountx.
    ENDIF.

    lv_next_index = lv_index + 1.
    READ TABLE gt_data_ast INTO DATA(lv_next) INDEX lv_next_index.
    IF sy-subrc EQ 0.
      IF lv_next-po_number IS INITIAL AND lv_next-po_number <= lines( gt_data_ast ).
        CONTINUE.
      ENDIF.
      IF lv_next-po_number IS NOT INITIAL.
        PERFORM bapi.
        CLEAR : gs_poheader, gs_poheaderx.
        CLEAR : gt_poitem, gt_poitemx, gt_poschedule, gt_poschedulex, gt_poaccount, gt_poaccountx.
      ENDIF.
    ENDIF.

    IF lv_index = lines( gt_data_ast ).
      PERFORM bapi.
      CLEAR : gs_poheader, gs_poheaderx.
      CLEAR : gt_poitem, gt_poitemx, gt_poschedule, gt_poschedulex, gt_poaccount, gt_poaccountx.
    ENDIF.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form BAPI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM bapi .
  CALL FUNCTION 'BAPI_PO_CREATE1'
    EXPORTING
      poheader    = gs_poheader
      poheaderx   = gs_poheaderx
      testrun     = p_test
    TABLES
      return      = gt_return
      poitem      = gt_poitem
      poitemx     = gt_poitemx
      poschedule  = gt_poschedule
      poschedulex = gt_poschedulex
      poaccount   = gt_poaccount
      poaccountx  = gt_poaccountx.

  READ TABLE gt_return INTO gs_return WITH KEY type = 'E'.
  IF sy-subrc EQ 0.

    LOOP AT gt_return INTO gs_return WHERE type = 'E'.
      gs_log-ebeln = gs_poheader-po_number.
      gs_log-type = gs_return-type.
      gs_log-message = gs_return-message.
      APPEND gs_log TO gt_log.
      CLEAR gs_log.
    ENDLOOP.

  ELSE. "success

    IF p_test IS INITIAL. "posting

      CLEAR gs_return.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = abap_true
        IMPORTING
          return = gs_return.

      IF sy-subrc IS INITIAL.
        READ TABLE gt_return INTO gs_return1 INDEX 1.
        gs_log-ebeln = gs_poheader-po_number.
        gs_log-type = 'S'.
        gs_log-message = 'Data successfully uploaded'.
        APPEND gs_log TO gt_log.
        CLEAR gs_log.
      ELSE.
        gs_log-ebeln = gs_poheader-po_number.
        gs_log-type = gs_return-type.
        gs_log-message = gs_return-message.
        APPEND gs_log TO gt_log.
        CLEAR gs_log.

        CLEAR gs_return.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
          IMPORTING
            return = gs_return.

        IF sy-subrc IS NOT INITIAL.
          gs_log-ebeln = gs_poheader-po_number.
          gs_log-type = gs_return-type.
          gs_log-message = gs_return-message.
          APPEND gs_log TO gt_log.
          CLEAR gs_log.
        ENDIF.
      ENDIF.

    ELSE. "testing

      gs_log-ebeln = gs_poheader-po_number.
      gs_log-type = 'S'.
      gs_log-message = 'Data successfully uploaded'.
      APPEND gs_log TO gt_log.
      CLEAR gs_log.

      CLEAR gs_return.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = gs_return.

      IF sy-subrc IS NOT INITIAL.
        gs_log-ebeln = gs_poheader-po_number.
        gs_log-type = gs_return-type.
        gs_log-message = gs_return-message.
        APPEND gs_log TO gt_log.
        CLEAR gs_log.
      ENDIF.
    ENDIF.

    CLEAR : gs_poheader, gs_poheaderx, gs_poitem, gs_poitemx, gs_poschedule, gs_poschedulex, gs_poaccount, gs_poaccountx.
  ENDIF.

  CLEAR: lv_doc_no, gt_return, gt_poitem, gt_poitemx, gt_poschedule, gt_poschedulex, gt_poaccount, gt_poaccountx.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_date_fix
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_DATA_AST_DOC_DATE
*&---------------------------------------------------------------------*
FORM f_date_fix  CHANGING lv_date.

  REPLACE ALL OCCURRENCES OF REGEX '[^0-9a-zA-Z]' IN lv_date WITH ''.
  CONCATENATE lv_date+4(4) lv_date+2(2) lv_date+0(2) INTO lv_date.

ENDFORM.
