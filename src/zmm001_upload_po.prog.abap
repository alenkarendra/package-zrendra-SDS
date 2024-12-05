*&---------------------------------------------------------------------*
*& WIKA - SAP Implementation Project
*&---------------------------------------------------------------------*
*& Description  : Upload Purchase Order
*& Input        : Selection Screen
*& Output       : Success/Error Logs
*& Module       : MM
*& Functional   : Hendri
*& Developer    : Felix Natanael
*& Created Date : 12.08.2022
*& Version      : 01.00.00
*&---------------------------------------------------------------------*
*& REVISION LOG
*&---------------------------------------------------------------------*
*& VER#       DATE        AUTHOR      DESCRIPTION
*& ----       ----        ------      -----------
*& 01.00.00   12.08.2022  SOL_FELIX   Initial Coding
*&                                    Transport Request : WS1K900287
*&                                    CR# : -
*& 01.00.02   29.10.2022  SOL_FELIX   PO Schedule bug fix
*&                                    Upd logic qty decimal
*&                                    Upd logic preq_name to vend_mat
*&                                    Transport Request : WS1K901211
*&                                    CR# : -
*& 01.00.03   31.10.2022  SOL_FELIX   PO Service vornr bug fix
*&                                    Transport Request : WS1K901220
*&                                    CR# : -
*& 01.00.04   08.12.2022  SOL_FELIX   PO Service Enhancement
*&                                    Transport Request : WS1K901813
*&                                    CR# : -
*&---------------------------------------------------------------------*

REPORT  zmm001_upload_po NO STANDARD PAGE HEADING.
*REPORT ywikammc005_ilham NO STANDARD PAGE HEADING.
***********************************************************************
*   DECLARATIONS INCLUDE
***********************************************************************
* Include for Data Declaration
INCLUDE zmm001_t01.
************************************************************************
*           SELECTION SCREEN DEFINITIONS
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-000.
  PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY.
  SELECTION-SCREEN SKIP 1.
  PARAMETERS: r_bar RADIOBUTTON GROUP rb1 DEFAULT 'X', "Standard
              r_upb RADIOBUTTON GROUP rb1, "PO UPB
              r_ast RADIOBUTTON GROUP rb1, "PO Asset
              r_trf RADIOBUTTON GROUP rb1, "PO Transfer
              r_cst RADIOBUTTON GROUP rb1, "PO Cost Center
              r_csg RADIOBUTTON GROUP rb1. "PO Consignment


  PARAMETERS :p_test AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK b01.
***********************************************************************
*   SELECTION SCREEN VALIDATIONS
***********************************************************************
AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_get_filepath CHANGING p_file.
***********************************************************************
*   SUBROUTINES INCLUDE
***********************************************************************
* Include for Subroutines
  INCLUDE zmm001_f01.
***********************************************************************
*   DATA SELECTION
***********************************************************************
START-OF-SELECTION.
  PERFORM f_init_data.
  PERFORM f_upload_data.
  PERFORM f_process_data.
  PERFORM f_show_log.
************************************************************************
*  End-of-selection event
************************************************************************
END-OF-SELECTION.


*Selection texts
*----------------------------------------------------------
* P_BBAL         Beginning Balance
* P_FILE         File Location
* P_TEST         Test Run
* R_ASS         PO Asset
* R_BAR         PO Barang
* R_JAS         PO Jasa


*Messages
*----------------------------------------------------------
*
* Message class: Hard coded
*   No Data Uploaded.
