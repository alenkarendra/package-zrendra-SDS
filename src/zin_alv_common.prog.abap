*----------------------------------------------------------------------*
*   INCLUDE ZIN_ALV_COMMON                                             *
*----------------------------------------------------------------------*
type-pools: slis.

FIELD-SYMBOLS: <fs_table> TYPE table.

data: t_alv_fieldcat      type slis_t_fieldcat_alv with header line,
      t_alv_event         type slis_t_event with header line,
      t_events            TYPE slis_t_event,
      t_alv_isort         type slis_t_sortinfo_alv with header line,
      t_alv_filter        type slis_t_filter_alv with header line,
      t_event_exit        type slis_t_event_exit with header line,
      d_alv_isort         type slis_sortinfo_alv,
      d_alv_variant       type disvariant,
      d_alv_list_scroll   type slis_list_scroll,
      d_alv_sort_postn    type i,
      d_alv_keyinfo       type slis_keyinfo_alv,
      d_alv_fieldcat      type slis_fieldcat_alv,
      d_alv_formname      type slis_formname,
      d_alv_ucomm         type slis_formname,
      d_alv_print         type slis_print_alv,
      d_alv_repid         like sy-repid,
      d_alv_tabix         like sy-tabix,
      d_alv_subrc         like sy-subrc,
      d_alv_screen_start_column type i,
      d_alv_screen_start_line type i,
      d_alv_screen_end_column type i,
      d_alv_screen_end_line type i,
      d_alv_layout type slis_layout_alv.

data: d_layout           TYPE slis_layout_alv,
      d_repid            LIKE sy-repid,
      d_print            TYPE slis_print_alv.

DATA: gt_list_top_of_page TYPE slis_t_listheader.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      IS_FCAT LIKE LINE OF IT_FCAT.

DATA: IT_FIELDCAT TYPE LVC_T_FCAT,
      IS_FIELDCAT LIKE LINE OF IT_FIELDCAT.

data: begin of gi_FIELDCAT occurs 0.
  include structure LVC_S_FCAT.
data: end of gi_FIELDCAT.

DATA: NEW_TABLE TYPE REF TO DATA.
DATA: NEW_LINE  TYPE REF TO DATA.

FIELD-SYMBOLS: <L_TABLE> TYPE standard table, "ANY TABLE,
               <L_LINE>  TYPE ANY,
               <L_FIELD> TYPE ANY,
               <L_FIELD2> TYPE ANY.
