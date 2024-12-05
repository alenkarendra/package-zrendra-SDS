*&---------------------------------------------------------------------*
*& Include          YWIKAMMC002_TOP
*&---------------------------------------------------------------------*

************************************************************************
*  Global Types
************************************************************************
TYPES: BEGIN OF ty_data_jas,
         doc_no(10)              TYPE c,
         doc_type                TYPE bsart,
         vendor                  TYPE lifnr,
         doc_date(10)            TYPE c,
         incoterms1              TYPE inco1,
         incoterms2              TYPE inco2,
         retention_percentage(3) TYPE c,
         downpay_percent(3)      TYPE c,
         downpay_duedate(10)     TYPE c,
         po_item(5)              TYPE c,
         vend_mat                TYPE idnlf,
         wbs_element(24)         TYPE c,
         delivery_date(10)       TYPE c,
         tax_code                TYPE mwskz,
         service                 TYPE asnum,
         quantity(17)            TYPE c,
         base_uom                TYPE meins,
         gr_price                TYPE bapigrprice,
       END OF ty_data_jas,

       BEGIN OF ty_data_bar,
         doc_no       TYPE ebeln,
         comp_cod     TYPE bukrs,
         doc_type     TYPE bsart,
         vendor       TYPE lifnr,
         doc_date     TYPE budat,
         purch_or     TYPE ekorg,
         purch_group  TYPE ekgrp,
         reason_canc  TYPE stgrd,
         po_item      TYPE ebelp,
         material     TYPE matnr,
         quant(17)    TYPE c,
         plant        TYPE werks,
         stge_loc(25) TYPE c,
         net_price    TYPE netpr,
         po_unit      TYPE meins,
         deliv_date   TYPE budat,
       END OF ty_data_bar,

       BEGIN OF ty_data_upb,
         doc_no       TYPE ebeln,
         comp_cod     TYPE bukrs,
         doc_type     TYPE bsart,
         vendor       TYPE lifnr,
         doc_date     TYPE budat,
         purch_or     TYPE ekorg,
         purch_group  TYPE ekgrp,
         reason_canc  TYPE stgrd,
         po_item      TYPE ebelp,
         material     TYPE matnr,
         quant(17)    TYPE c,
         plant        TYPE werks,
         stge_loc(25) TYPE c,
         net_price    TYPE netpr,
         batch(25)    TYPE c,
         po_unit      TYPE meins,
         deliv_date   TYPE budat,
       END OF ty_data_upb,

       BEGIN OF ty_data_cst,
         doc_no       TYPE ebeln,
         comp_cod     TYPE bukrs,
         doc_type     TYPE bsart,
         vendor       TYPE lifnr,
         doc_date     TYPE budat,
         purch_or     TYPE ekorg,
         purch_group  TYPE ekgrp,
         reason_canc  TYPE stgrd,
         po_item      TYPE ebelp,
         acc_assg     TYPE knttp,
         quant(17)    TYPE c,
         plant        TYPE werks,
         net_price    TYPE netpr,
         deliv_date   TYPE budat,
         gl_acc       TYPE saknr,
         cost_cntr    TYPE kostl,
         material     TYPE matnr,
         po_unit      TYPE meins,
         material_grp TYPE matkl,
         short_txt    TYPE txz01,
       END OF ty_data_cst,

       BEGIN OF ty_data_csg, "PO Consignment
         doc_no      TYPE ebeln,
         comp_cod    TYPE bukrs,
         doc_type    TYPE bsart,
         vendor      TYPE lifnr,
         doc_date    TYPE budat,
         purch_or    TYPE ekorg,
         purch_group TYPE ekgrp,
         reason_canc TYPE stgrd,
         po_item     TYPE ebelp,
         material    TYPE matnr,
         plant       TYPE werks,
         quant(17)   TYPE c,
         po_unit     TYPE meins,
         item_cat    TYPE c,
         deliv_date  TYPE budat,
       END OF ty_data_csg,

       BEGIN OF ty_data_trf,
         po_number         TYPE ebeln,
         comp_code         TYPE bukrs,
         doc_type          TYPE bsart,
         suppl_plnt        TYPE lifnr,
         doc_date(10)      TYPE c,
         purch_org         TYPE ekorg,
         pur_group         TYPE ekgrp,
         reason_cancel     TYPE stgrd,
         po_item           TYPE ebelp,
         material          TYPE matnr,
         quantity(17)      TYPE c,
         plant             TYPE werks,
         stge_loc(25)      TYPE c,
*         net_price    TYPE netpr,
*         batch(25)        TYPE c,
         po_unit           TYPE meins,
         delivery_date(10) TYPE c,
       END OF ty_data_trf,

       BEGIN OF ty_data_ast,
         po_number     TYPE ebeln,
         comp_code     TYPE bukrs,
         doc_type      TYPE bsart,
         vendor        TYPE lifnr,
         doc_date(10)  TYPE c,
         purch_org     TYPE ekorg,
         pur_group     TYPE ekgrp,
         reason_cancel TYPE stgrd,
         po_item       TYPE ebelp,

         preq_no(20)   TYPE c,
         preq_item(20) TYPE c,
         short_text    TYPE txz01,

         quantity(17)  TYPE c,
         material      TYPE matnr,
         po_unit       TYPE meins,

         net_price     TYPE netpr,

         matl_group(3) TYPE c,
         plant         TYPE werks,
         deliv_date    TYPE budat,

         asset_no(9)   TYPE c,

         acctasscat    TYPE knttp,

       END OF ty_data_ast.

TYPES:
*       ty_data_bar TYPE ywikamms002_bar,
*       ty_data_jas TYPE ywikamms002_jas,
*  ty_data_ass TYPE ywikamms002_ass,

  BEGIN OF ty_log,
*         line    TYPE i,
    line(10) TYPE c,
    type     TYPE bapi_mtype,
    ebeln    TYPE ebeln,
    message  TYPE bapi_msg,
  END OF ty_log.

************************************************************************
*  Global Table Types
************************************************************************
TYPES: ty_data_bar_t TYPE STANDARD TABLE OF ty_data_bar,
       ty_data_jas_t TYPE STANDARD TABLE OF ty_data_jas,
       ty_data_upb_t TYPE STANDARD TABLE OF ty_data_upb,
       ty_data_ast_t TYPE STANDARD TABLE OF ty_data_ast,
       ty_data_trf_t TYPE STANDARD TABLE OF ty_data_trf,
       ty_data_cst_t TYPE STANDARD TABLE OF ty_data_cst,
       ty_data_csg_t TYPE STANDARD TABLE OF ty_data_csg,
       ty_log_t      TYPE STANDARD TABLE OF ty_log.
************************************************************************
*  Global Internal Tables
************************************************************************
DATA: gt_data_bar TYPE ty_data_bar_t, "PO Standard
      gt_data_jas TYPE ty_data_jas_t,
      gt_data_upb TYPE ty_data_upb_t, "PO UPB
      gt_data_ast TYPE ty_data_ast_t, "PO Asset
      gt_data_trf TYPE ty_data_trf_t, "PO Transfer
      gt_data_cst TYPE ty_data_cst_t, "PO Cost Center
      gt_data_csg TYPE ty_data_csg_t, "PO Consignment
      gt_log      TYPE ty_log_t.

DATA: gs_data_bar LIKE LINE OF gt_data_bar,
      gs_data_upb LIKE LINE OF gt_data_upb,
      gs_data_cst LIKE LINE OF gt_data_cst,
      gs_data_csg LIKE LINE OF gt_data_csg.
************************************************************************
*  CONSTANTS
************************************************************************
CONSTANTS: c_i TYPE char1 VALUE 'I'.

************************************************************************
*  BAPI
************************************************************************
DATA : gs_poheader    TYPE bapimepoheader,
       gs_poheaderx   TYPE bapimepoheaderx,

       gs_poitem      TYPE bapimepoitem,
       gt_poitem      TYPE TABLE OF bapimepoitem,
       gs_poitemx     TYPE bapimepoitemx,
       gt_poitemx     TYPE TABLE OF bapimepoitemx,
       gs_poschedule  TYPE bapimeposchedule,
       gt_poschedule  TYPE TABLE OF bapimeposchedule,
       gs_poschedulex TYPE bapimeposchedulx,
       gt_poschedulex TYPE TABLE OF bapimeposchedulx,
       gs_poaccount   TYPE bapimepoaccount,
       gt_poaccount   TYPE TABLE OF bapimepoaccount,
       gs_poaccountx  TYPE bapimepoaccountx,
       gt_poaccountx  TYPE TABLE OF bapimepoaccountx.

DATA : gt_return  TYPE TABLE OF bapiret2,
       gs_return  TYPE bapiret2,
       gs_return1 TYPE bapiret2,
       gs_log     TYPE ty_log.

DATA : lv_doc_no TYPE ebeln.
