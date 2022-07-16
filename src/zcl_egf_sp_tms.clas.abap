class ZCL_EGF_SP_TMS definition
  public
  final
  create public .

public section.

  interfaces /SCWM/IF_EGF_SP .
protected section.
private section.
ENDCLASS.



CLASS ZCL_EGF_SP_TMS IMPLEMENTATION.


  method /SCWM/IF_EGF_SP~DRILL_DOWN.
  endmethod.


  METHOD /scwm/if_egf_sp~get_data.
    DATA: ls_data_result TYPE /scwm/s_egf_point_general,
          ls_data_target TYPE /scwm/s_egf_point_general,
          ls_tms         TYPE /scwm/s_ex_ms_result,
          lv_label       TYPE /scwm/de_egf_label,
          ls_title       TYPE /scwm/s_egf_chart_title,
          ls_subtitle    TYPE /scwm/s_egf_chart_title.

    BREAK-POINT ID zewmdevbook_324.

    "1. Get user-input: get warehouse number
    ASSIGN it_object_input[ tablename = '/SCWM/S_MS_RESULT_SEL_UI' ]
      TO FIELD-SYMBOL(<ls_selection>).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.
    ASSIGN <ls_selection>-frange_t[ fieldname = /scwm/if_ui_pl_c=>sc_field_lgnum ]
      TO FIELD-SYMBOL(<ls_frange_t_read>).
    IF sy-subrc IS NOT INITIAL
    OR <ls_frange_t_read> IS INITIAL.
      RETURN.
    ENDIF.
    DATA(ls_selopt) = VALUE #( <ls_frange_t_read>-selopt_t[ 1 ] ).
    ls_tms-lgnum = ls_selopt-low.
    IF ls_tms-lgnum IS INITIAL.
      RETURN.
    ENDIF.
    "2. Get user-input: table of Measurement Services
    ASSIGN <ls_selection>-frange_t[ fieldname = 'TMS' ]
      TO <ls_frange_t_read>.
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.
    "3. Set the labels for the two Series: Actual and Target
    ls_data_result = VALUE #( label = 'Actual Values'
                              id    = 'ACTUAL' ).
    ls_data_target = VALUE #( label = 'Target Values'
                              id    = 'TARGET' ).
    eo_chart_data = NEW /scwm/cl_egf_chart_data( ).
    "4. For each Meas. Serv., create values in the 2 Series
    LOOP AT <ls_frange_t_read>-selopt_t INTO ls_selopt.
      CLEAR: ls_tms-meas_serv, ls_tms-ms_result.
      ls_tms-meas_serv = ls_selopt-low.
      "5. Get description of Measurement Service for category
      SELECT SINGLE meas_serv_txt
        FROM  /scwm/tms_text
        INTO  lv_label
        WHERE langu = sy-langu
        AND   lgnum = ls_tms-lgnum
        AND   meas_serv = ls_tms-meas_serv
        AND ms_type = 'T'. "tailored ms
      eo_chart_data->add_category(
        EXPORTING
          iv_category = lv_label ).
      "6. Get result of the meas. service (=ACTUAL Series)
      CALL FUNCTION '/SCWM/MS_EVALUATE'
        EXPORTING
          iv_lgnum     = ls_tms-lgnum
          iv_meas_serv = ls_tms-meas_serv
          iv_ms_type   = 'T'
          iv_update_db = abap_false
          iv_alert     = abap_true
        IMPORTING
          ev_result    = ls_tms-ms_result.
      ls_data_result-value = ls_tms-ms_result.
      eo_chart_data->add_series_general(
        EXPORTING
          iv_label = ls_data_result-label
          is_point = ls_data_result
          iv_id    = ls_data_result-id ).
      "7. Get target value from a Z-Database (= Target Series)
      SELECT SINGLE value
        FROM  zegf_ms_target
        INTO  ls_data_target-value
        WHERE lgnum     = ls_tms-lgnum
        AND   meas_serv = ls_tms-meas_serv.
      IF sy-subrc IS INITIAL.
        eo_chart_data->add_series_general(
          EXPORTING
            iv_label = ls_data_target-label
            is_point = ls_data_target
            iv_id    = ls_data_target-id ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  method /SCWM/IF_EGF_SP~GET_URL.
  endmethod.


  method /SCWM/IF_EGF_SP~HANDLE_FUNCTION.
  endmethod.


  method /SCWM/IF_EGF_SP~OBJECT_REMOVED.
  endmethod.


  method /SCWM/IF_EGF_SP~SET_FUNCTIONS.
  endmethod.
ENDCLASS.
