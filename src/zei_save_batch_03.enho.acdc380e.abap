"Name: \PR:SAPLCHRG\EX:SAVE_BATCH_03\EI
ENHANCEMENT 0 ZEI_SAVE_BATCH_03.
        IF sy-tcode EQ 'MSC1N' OR sy-tcode EQ 'MSC2N'.
          BREAK sol_ilham.
        ENDIF.

        CALL FUNCTION 'VB_CHANGE_BATCH'
          EXPORTING
            ymcha                     = akt_mchx
            change_lgort              = dfbatch-lgort
            bypass_lock               = 'X'
            kzcla                     = ' '
            xkcfc                     = ' '
            no_check_of_qm_char       = 'X'
            set_old_batch             = ' '
            no_change_document        = ' '
            no_cfc_calls              = 'X'
* begin ENHO:  /SAPMP/PIECEBATCH_LCHRGF02 IS-MP-MM /SAPMP/SINGLE_UNIT_BATCH
*                 Mill Single unit batch SW
            iref_pcbt_batch           = oref_pcbt_batch
* end ENHO:  /SAPMP/PIECEBATCH_LCHRGF02 IS-MP-MM /SAPMP/SINGLE_UNIT_BATCH
            batch_del_flags           = x_batchdelflg
            bypass_post               = 'X'            "1997493
            prepare_post              = 'X'            "1997493
          IMPORTING
            ymcha                     = akt_mchx
            emkpf                     = ls_emkpf       "1997493
          EXCEPTIONS
            no_material               = 1
            no_batch                  = 2
            no_plant                  = 3
            material_not_found        = 4
            plant_not_found           = 5
            lock_on_material          = 6
            lock_on_plant             = 7
            lock_on_batch             = 8
            lock_system_error         = 9
            no_authority              = 10
            batch_not_exist           = 11
            no_class                  = 12
            error_in_classification   = 13
            error_in_valuation_change = 14
            OTHERS                    = 99.
ENDENHANCEMENT.
