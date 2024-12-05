class ZCL_GET_DATE_HTTP_000 definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GET_DATE_HTTP_000 IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.
    response->set_text( 'Hello World!, My name is Rendra' ).
  endmethod.
ENDCLASS.
