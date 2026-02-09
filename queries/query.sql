/* Anomali 1-8 Blok Demografi
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_01 = 1 THEN ',1' ELSE '' END,
                      CASE WHEN rekap.anomali_02 = 1 THEN ',2' ELSE '' END,
                      CASE WHEN rekap.anomali_03 = 1 THEN ',3' ELSE '' END,
                      CASE WHEN rekap.anomali_04 = 1 THEN ',4' ELSE '' END,
                      CASE WHEN rekap.anomali_05 = 1 THEN ',5' ELSE '' END,
                      CASE WHEN rekap.anomali_06 = 1 THEN ',6' ELSE '' END,
                      CASE WHEN rekap.anomali_07 = 1 THEN ',7' ELSE '' END,
                      CASE WHEN rekap.anomali_08 = 1 THEN ',8' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_01,rekap.anomali_02,rekap.anomali_03,rekap.anomali_04,rekap.anomali_05,rekap.anomali_06,rekap.anomali_07,rekap.anomali_08
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_1.anomali_arr IS NULL AND art.r407 < 17 AND root.r412_value = '02'),1,0) AS anomali_01
               ,IIF((anomali_2.anomali_arr IS NULL AND art.r408_value = 8 AND pair_a.pair_value = 'A'),1,0) AS anomali_02
               ,IIF((anomali_3.anomali_arr IS NULL 
                    AND (root.r412_value = '03' OR root.r412_value = '04' OR root.r412_value = '06' OR root.r412_value = '08')
                    AND pair_a.pair_value = 'A'),1,0) AS anomali_03
               ,IIF((anomali_4.anomali_arr IS NULL 
                    AND (root.r412_value = '03' OR root.r412_value = '04' OR root.r412_value = '06' OR root.r412_value = '08')
                    AND pair_b.pair_value = 'B'),1,0) AS anomali_04
               ,IIF((anomali_5.anomali_arr IS NULL AND art.r408_value = 8 AND pair_c.pair_value = 'C'),1,0) AS anomali_05
               ,IIF((anomali_6.anomali_arr IS NULL 
                    AND (root.r412_value = '03' OR root.r412_value = '04' OR root.r412_value = '06' OR root.r412_value = '08' OR root.r412_value = '13')
                    AND pair_c.pair_value = 'C'),1,0) AS anomali_06
               ,IIF((anomali_7.anomali_arr IS NULL 
                    AND art.r408_value = 8 AND pair_d.pair_value = 'D'),1,0) AS anomali_07
               ,IIF((anomali_8.anomali_arr IS NULL 
                    AND (root.r412_value = '03' OR root.r412_value = '04' OR root.r412_value = '06' OR root.r412_value = '08')
                    AND pair_d.pair_value = 'D'),1,0) AS anomali_08
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_1.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_1
                  ON root.assignment_id = anomali_1.assignment_id AND anomali_1.anomali_arr = '01'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_2
                  ON root.assignment_id = anomali_2.assignment_id AND anomali_2.anomali_arr = '02'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_3
                  ON root.assignment_id = anomali_3.assignment_id AND anomali_3.anomali_arr = '03'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_4
                  ON root.assignment_id = anomali_4.assignment_id AND anomali_4.anomali_arr = '04'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_5
                  ON root.assignment_id = anomali_5.assignment_id AND anomali_5.anomali_arr = '05'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_6
                  ON root.assignment_id = anomali_6.assignment_id AND anomali_6.anomali_arr = '06'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_7
                  ON root.assignment_id = anomali_7.assignment_id AND anomali_7.anomali_arr = '07'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_8
                  ON root.assignment_id = anomali_8.assignment_id AND anomali_8.anomali_arr = '08'
                  
            LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_a
                  ON root.assignment_id = pair_a.assignment_id AND pair_a.data_key = 'r414' AND pair_a.pair_value = 'A'
            LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_b
                  ON root.assignment_id = pair_b.assignment_id AND pair_b.data_key = 'r414' AND pair_b.pair_value = 'B'
            LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_c
                  ON root.assignment_id = pair_c.assignment_id AND pair_c.data_key = 'r414' AND pair_c.pair_value = 'C'
            LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_d
                  ON root.assignment_id = pair_d.assignment_id AND pair_d.data_key = 'r414' AND pair_d.pair_value = 'D'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_1.anomali_arr IS NULL
            AND anomali_2.anomali_arr IS NULL
            AND anomali_3.anomali_arr IS NULL
            AND anomali_4.anomali_arr IS NULL
            AND anomali_5.anomali_arr IS NULL
            AND anomali_6.anomali_arr IS NULL
            AND anomali_7.anomali_arr IS NULL
            AND anomali_8.anomali_arr IS NULL) rekap
WHERE rekap.anomali_01 = 1 
      OR rekap.anomali_02 = 1 
      OR rekap.anomali_03 = 1 
      OR rekap.anomali_04 = 1 
      OR rekap.anomali_05 = 1 
      OR rekap.anomali_06 = 1
      OR rekap.anomali_07 = 1
      OR rekap.anomali_08 = 1
      


/* Anomali 9-15 Blok Perbankan
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_09 = 1 THEN ',9' ELSE '' END,
                      CASE WHEN rekap.anomali_10 = 1 THEN ',10' ELSE '' END,
                      CASE WHEN rekap.anomali_11 = 1 THEN ',11' ELSE '' END,
                      CASE WHEN rekap.anomali_12 = 1 THEN ',12' ELSE '' END,
                      CASE WHEN rekap.anomali_13 = 1 THEN ',13' ELSE '' END,
                      CASE WHEN rekap.anomali_14 = 1 THEN ',14' ELSE '' END,
                      CASE WHEN rekap.anomali_15 = 1 THEN ',15' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_09,rekap.anomali_10,rekap.anomali_11,rekap.anomali_12,rekap.anomali_13,rekap.anomali_14,rekap.anomali_15
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_9.anomali_arr IS NULL AND pair_a.pair_value = 'A' AND root.r501a_value = 5 AND root.r501b_value = 5),1,0) AS anomali_09
               ,IIF((anomali_10.anomali_arr IS NULL AND root.r501a_value = 5 AND root.r504a_value = 1),1,0) AS anomali_10
               ,IIF((anomali_11.anomali_arr IS NULL AND root.r501b_value = 5 AND root.r504b_value = 1),1,0) AS anomali_11
               ,IIF((anomali_12.anomali_arr IS NULL 
                    AND (root.r412_value = '02' OR root.r412_value = '03' OR root.r412_value = '05' OR root.r412_value = '06')
                    AND (root.r505a_value = 5 OR root.r505a_value IS NULL)
                    AND (root.r505b_value = 5 OR root.r505b_value IS NULL)),1,0) AS anomali_12
               ,IIF((anomali_13.anomali_arr IS NULL AND root.r504a_value = 1 AND root.r506ai_value = 5 AND root.r506aii_value = 5 
                    AND root.r506aiii_value = 5 AND root.r506aiv_value = 5 AND root.r506av_value = 5 AND root.r506avi_value = 5),1,0) AS anomali_13
               ,IIF((anomali_14.anomali_arr IS NULL AND root.r504b_value = 1 AND root.r506bi_value = 5 AND root.r506bii_value = 5 
                    AND root.r506biii_value = 5 AND root.r506biv_value = 5 AND root.r506bv_value = 5 AND root.r506bvi_value = 5),1,0) AS anomali_14
               ,IIF((anomali_15.anomali_arr IS NULL AND (root.r503b_value = 1 AND root.r504b_value = 1) AND root.r507a_value = 5 
                    AND root.r507b_value = 5 AND root.r507c_value = 5 AND root.r507d_value = 5 AND root.r507e_value = 5),1,0) AS anomali_15
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_9.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_9
                  ON root.assignment_id = anomali_9.assignment_id AND anomali_9.anomali_arr = '09'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_10
                  ON root.assignment_id = anomali_10.assignment_id AND anomali_10.anomali_arr = '10'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_11
                  ON root.assignment_id = anomali_11.assignment_id AND anomali_11.anomali_arr = '11'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_12
                  ON root.assignment_id = anomali_12.assignment_id AND anomali_12.anomali_arr = '12'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_13
                  ON root.assignment_id = anomali_13.assignment_id AND anomali_13.anomali_arr = '13'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_14
                  ON root.assignment_id = anomali_14.assignment_id AND anomali_14.anomali_arr = '14'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_15
                  ON root.assignment_id = anomali_15.assignment_id AND anomali_15.anomali_arr = '15'
             
            LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_a
                  ON root.assignment_id = pair_a.assignment_id AND pair_a.data_key = 'r414' AND pair_a.pair_value = 'A'
            
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_9.anomali_arr IS NULL
            AND anomali_10.anomali_arr IS NULL
            AND anomali_11.anomali_arr IS NULL
            AND anomali_12.anomali_arr IS NULL
            AND anomali_13.anomali_arr IS NULL
            AND anomali_14.anomali_arr IS NULL
            AND anomali_15.anomali_arr IS NULL) rekap
WHERE rekap.anomali_09 = 1 
      OR rekap.anomali_10 = 1 
      OR rekap.anomali_11 = 1 
      OR rekap.anomali_12 = 1 
      OR rekap.anomali_13 = 1 
      OR rekap.anomali_14 = 1
      OR rekap.anomali_15 = 1
      
/* Anomali 16-19 Blok Pasar Modal
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_16 = 1 THEN ',16' ELSE '' END,
                      CASE WHEN rekap.anomali_17 = 1 THEN ',17' ELSE '' END,
                      CASE WHEN rekap.anomali_18 = 1 THEN ',18' ELSE '' END,
                      CASE WHEN rekap.anomali_19 = 1 THEN ',19' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_16,rekap.anomali_17,rekap.anomali_18,rekap.anomali_19
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_16.anomali_arr IS NULL AND art.r407 < 17 AND (root.r604a_value = 1 OR root.r604b_value = 1 )),1,0) AS anomali_16
               ,IIF((anomali_17.anomali_arr IS NULL 
                    AND root.r604a_value = 1  AND root.r606ai_value = 5 AND root.r606aii_value = 5 AND root.r606aiii_value = 5
                    AND root.r606aiv_value = 5 AND root.r606av_value = 5 AND root.r606avi_value = 5),1,0) AS anomali_17
               ,IIF((anomali_18.anomali_arr IS NULL 
                    AND root.r604b_value = 1  AND root.r606bi_value = 5 AND root.r606bii_value = 5 AND root.r606biii_value = 5
                    AND root.r606biv_value = 5 AND root.r606bv_value = 5 AND root.r606bvi_value = 5),1,0) AS anomali_18
               ,IIF((anomali_19.anomali_arr IS NULL 
                    AND (root.r604a_value = 1 OR root.r604b_value = 1 ) AND root.r607a_value = 5 AND root.r607b_value = 5 
                    AND root.r607c_value = 5),1,0) AS anomali_19
                    
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_16.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_16
                  ON root.assignment_id = anomali_16.assignment_id AND anomali_16.anomali_arr = '16'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_17
                  ON root.assignment_id = anomali_17.assignment_id AND anomali_17.anomali_arr = '17'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_18
                  ON root.assignment_id = anomali_18.assignment_id AND anomali_18.anomali_arr = '18'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_19
                  ON root.assignment_id = anomali_19.assignment_id AND anomali_19.anomali_arr = '19'
            
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_16.anomali_arr IS NULL
            AND anomali_17.anomali_arr IS NULL
            AND anomali_18.anomali_arr IS NULL
            AND anomali_19.anomali_arr IS NULL) rekap
WHERE rekap.anomali_16 = 1 
      OR rekap.anomali_17 = 1 
      OR rekap.anomali_18 = 1 
      OR rekap.anomali_19 = 1 
      
/* Anomali 20-23 Blok BPJS
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_20 = 1 THEN ',20' ELSE '' END,
                      CASE WHEN rekap.anomali_21 = 1 THEN ',21' ELSE '' END,
                      CASE WHEN rekap.anomali_22 = 1 THEN ',22' ELSE '' END,
                      CASE WHEN rekap.anomali_23 = 1 THEN ',23' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_20,rekap.anomali_21,rekap.anomali_22,rekap.anomali_23
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_20.anomali_arr IS NULL AND root.r701_value = 5 AND pair_b.pair_value = 'B'),1,0) AS anomali_20
               ,IIF((anomali_21.anomali_arr IS NULL 
                    AND (root.r412_value = '03' OR root.r412_value = '04') AND root.r705_value = 5),1,0) AS anomali_21
               ,IIF((anomali_22.anomali_arr IS NULL 
                    AND root.r704_value = 1  AND root.r706i_value = 5 AND root.r706ii_value = 5 AND root.r706iii_value = 5
                    AND root.r706iv_value = 5 AND root.r706v_value = 5 AND root.r706vi_value = 5),1,0) AS anomali_22
               ,IIF((anomali_23.anomali_arr IS NULL 
                    AND root.r704_value = 1  AND root.r707a_value = 5 AND root.r707b_value = 5 AND root.r707c_value = 5 
                    AND root.r707d_value = 5 AND root.r707e_value = 5),1,0) AS anomali_23
                       
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_20.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_20
                  ON root.assignment_id = anomali_20.assignment_id AND anomali_20.anomali_arr = '20'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_21
                  ON root.assignment_id = anomali_21.assignment_id AND anomali_21.anomali_arr = '21'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_22
                  ON root.assignment_id = anomali_22.assignment_id AND anomali_22.anomali_arr = '22'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_23
                  ON root.assignment_id = anomali_23.assignment_id AND anomali_23.anomali_arr = '23'
                  
            LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_b
                  ON root.assignment_id = pair_b.assignment_id AND pair_b.data_key = 'r414' AND pair_b.pair_value = 'B'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id

            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_20.anomali_arr IS NULL
            AND anomali_21.anomali_arr IS NULL
            AND anomali_22.anomali_arr IS NULL
            AND anomali_23.anomali_arr IS NULL) rekap
WHERE rekap.anomali_20 = 1 
      OR rekap.anomali_21 = 1 
      OR rekap.anomali_22 = 1 
      OR rekap.anomali_23 = 1 
      
/* Anomali 24-26 Blok Perasuransian
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_24 = 1 THEN ',24' ELSE '' END,
                      CASE WHEN rekap.anomali_25 = 1 THEN ',25' ELSE '' END,
                      CASE WHEN rekap.anomali_26 = 1 THEN ',26' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_24,rekap.anomali_25,rekap.anomali_26
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_24.anomali_arr IS NULL 
                    AND root.r804a_value = 1  AND root.r806ai_value = 5 AND root.r806aii_value = 5 AND root.r806aiii_value = 5
                    AND root.r806aiv_value = 5 AND root.r806av_value = 5 AND root.r806avi_value = 5),1,0) AS anomali_24
               ,IIF((anomali_25.anomali_arr IS NULL 
                    AND root.r804b_value = 1  AND root.r806bi_value = 5 AND root.r806bii_value = 5 AND root.r806biii_value = 5
                    AND root.r806biv_value = 5 AND root.r806bv_value = 5 AND root.r806bvi_value = 5),1,0) AS anomali_25
               ,IIF((anomali_26.anomali_arr IS NULL 
                    AND (root.r804a_value = 1 OR root.r804b_value = 1 ) AND root.r807a_value = 5 AND root.r607b_value = 5 
                    AND root.r807c_value = 5 AND root.r807d_value = 5 AND root.r807e_value = 5),1,0) AS anomali_26
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_24.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_24
                  ON root.assignment_id = anomali_24.assignment_id AND anomali_24.anomali_arr = '24'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_25
                  ON root.assignment_id = anomali_25.assignment_id AND anomali_25.anomali_arr = '25'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_26
                  ON root.assignment_id = anomali_26.assignment_id AND anomali_26.anomali_arr = '26'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_24.anomali_arr IS NULL
            AND anomali_25.anomali_arr IS NULL
            AND anomali_26.anomali_arr IS NULL) rekap
WHERE rekap.anomali_24 = 1 
      OR rekap.anomali_25 = 1 
      OR rekap.anomali_26 = 1 
      
/* Anomali 27-30 Blok Lembaga Pembiayaan
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_27 = 1 THEN ',27' ELSE '' END,
                      CASE WHEN rekap.anomali_28 = 1 THEN ',28' ELSE '' END,
                      CASE WHEN rekap.anomali_29 = 1 THEN ',29' ELSE '' END,
                      CASE WHEN rekap.anomali_30 = 1 THEN ',30' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_27,rekap.anomali_28,rekap.anomali_29,rekap.anomali_30
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_27.anomali_arr IS NULL AND art.r407 < 17 AND (root.r904a_value = 1 OR root.r904b_value = 1 )),1,0) AS anomali_27
               ,IIF((anomali_28.anomali_arr IS NULL 
                    AND root.r904a_value = 1  AND root.r906ai_value = 5 AND root.r906aii_value = 5 AND root.r906aiii_value = 5
                    AND root.r906aiv_value = 5 AND root.r906av_value = 5 AND root.r906avi_value = 5),1,0) AS anomali_28
               ,IIF((anomali_29.anomali_arr IS NULL 
                    AND root.r904b_value = 1  AND root.r906bi_value = 5 AND root.r906bii_value = 5 AND root.r906biii_value = 5
                    AND root.r906biv_value = 5 AND root.r906bv_value = 5 AND root.r906bvi_value = 5),1,0) AS anomali_29
               ,IIF((anomali_30.anomali_arr IS NULL 
                    AND (root.r904a_value = 1 OR root.r904b_value = 1 ) AND root.r907a_value = 5 AND root.r907b_value = 5 
                    AND root.r907c_value = 5 AND root.r907d_value = 5 AND root.r907e_value = 5),1,0) AS anomali_30
                    
               ,usr.PPL
               ,usr.PML
              
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_27.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_27
                  ON root.assignment_id = anomali_27.assignment_id AND anomali_27.anomali_arr = '27'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_28
                  ON root.assignment_id = anomali_28.assignment_id AND anomali_28.anomali_arr = '28'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_29
                  ON root.assignment_id = anomali_29.assignment_id AND anomali_29.anomali_arr = '29'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_30
                  ON root.assignment_id = anomali_30.assignment_id AND anomali_30.anomali_arr = '30'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_27.anomali_arr IS NULL
            AND anomali_28.anomali_arr IS NULL
            AND anomali_29.anomali_arr IS NULL
            AND anomali_30.anomali_arr IS NULL) rekap
WHERE rekap.anomali_27 = 1 
      OR rekap.anomali_28 = 1 
      OR rekap.anomali_29 = 1 
      OR rekap.anomali_30 = 1 
      
/* Anomali 31-34 Blok Dana Pensiun
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_31 = 1 THEN ',31' ELSE '' END,
                      CASE WHEN rekap.anomali_32 = 1 THEN ',32' ELSE '' END,
                      CASE WHEN rekap.anomali_33 = 1 THEN ',33' ELSE '' END,
                      CASE WHEN rekap.anomali_34 = 1 THEN ',34' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_31,rekap.anomali_32,rekap.anomali_33,rekap.anomali_34
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_31.anomali_arr IS NULL AND art.r407 < 17 AND (root.r1004a_value = 1 OR root.r1004b_value = 1 )),1,0) AS anomali_31
               ,IIF((anomali_32.anomali_arr IS NULL 
                    AND root.r1004a_value = 1  AND root.r1006ai_value = 5 AND root.r1006aii_value = 5 AND root.r1006aiii_value = 5
                    AND root.r1006aiv_value = 5 AND root.r1006av_value = 5 AND root.r1006avi_value = 5),1,0) AS anomali_32
               ,IIF((anomali_33.anomali_arr IS NULL 
                    AND root.r1004b_value = 1  AND root.r1006bi_value = 5 AND root.r1006bii_value = 5 AND root.r1006biii_value = 5
                    AND root.r1006biv_value = 5 AND root.r1006bv_value = 5 AND root.r1006bvi_value = 5),1,0) AS anomali_33
               ,IIF((anomali_34.anomali_arr IS NULL 
                    AND (root.r1004a_value = 1 OR root.r1004b_value = 1 ) AND root.r1007a_value = 5 AND root.r1007b_value = 5 
                    AND root.r1007c_value = 5 AND root.r1007d_value = 5 ),1,0) AS anomali_34
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_31.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_31
                  ON root.assignment_id = anomali_31.assignment_id AND anomali_31.anomali_arr = '31'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_32
                  ON root.assignment_id = anomali_32.assignment_id AND anomali_32.anomali_arr = '32'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_33
                  ON root.assignment_id = anomali_33.assignment_id AND anomali_33.anomali_arr = '33'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_34
                  ON root.assignment_id = anomali_34.assignment_id AND anomali_34.anomali_arr = '34'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_31.anomali_arr IS NULL
            AND anomali_32.anomali_arr IS NULL
            AND anomali_33.anomali_arr IS NULL
            AND anomali_34.anomali_arr IS NULL) rekap
WHERE rekap.anomali_31 = 1 
      OR rekap.anomali_32 = 1 
      OR rekap.anomali_33 = 1 
      OR rekap.anomali_34 = 1 
      
/* Anomali 35-38 Blok Pergadaian
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_35 = 1 THEN ',35' ELSE '' END,
                      CASE WHEN rekap.anomali_36 = 1 THEN ',36' ELSE '' END,
                      CASE WHEN rekap.anomali_37 = 1 THEN ',37' ELSE '' END,
                      CASE WHEN rekap.anomali_38 = 1 THEN ',38' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_35,rekap.anomali_36,rekap.anomali_37,rekap.anomali_38
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_35.anomali_arr IS NULL AND art.r407 < 17 AND (root.r1104a_value = 1 OR root.r1104b_value = 1 )),1,0) AS anomali_35
               ,IIF((anomali_36.anomali_arr IS NULL 
                    AND root.r1104a_value = 1  AND root.r1106ai_value = 5 AND root.r1106aii_value = 5 AND root.r1106aiii_value = 5
                    AND root.r1106aiv_value = 5 AND root.r1106av_value = 5 AND root.r1106avi_value = 5),1,0) AS anomali_36
               ,IIF((anomali_37.anomali_arr IS NULL 
                    AND root.r1104b_value = 1  AND root.r1106bi_value = 5 AND root.r1106bii_value = 5 AND root.r1106biii_value = 5
                    AND root.r1106biv_value = 5 AND root.r1106bv_value = 5 AND root.r1106bvi_value = 5),1,0) AS anomali_37
               ,IIF((anomali_38.anomali_arr IS NULL 
                    AND (root.r1104a_value = 1 OR root.r1104b_value = 1 ) AND root.r1107a_value = 5 AND root.r1107b_value = 5 
                    AND root.r1107c_value = 5 AND root.r1107d_value = 5 AND root.r1107e_value = 5 ),1,0) AS anomali_38
            
               ,usr.PPL
               ,usr.PML        
            
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_35.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_35
                  ON root.assignment_id = anomali_35.assignment_id AND anomali_35.anomali_arr = '35'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_36
                  ON root.assignment_id = anomali_36.assignment_id AND anomali_36.anomali_arr = '36'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_37
                  ON root.assignment_id = anomali_37.assignment_id AND anomali_37.anomali_arr = '37'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_38
                  ON root.assignment_id = anomali_38.assignment_id AND anomali_38.anomali_arr = '38'

            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id                  

            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_35.anomali_arr IS NULL
            AND anomali_36.anomali_arr IS NULL
            AND anomali_37.anomali_arr IS NULL
            AND anomali_38.anomali_arr IS NULL) rekap
WHERE rekap.anomali_35 = 1 
      OR rekap.anomali_36 = 1 
      OR rekap.anomali_37 = 1 
      OR rekap.anomali_38 = 1 
      
/* Anomali 39-43 Blok LKM
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_39 = 1 THEN ',39' ELSE '' END,
                      CASE WHEN rekap.anomali_40 = 1 THEN ',40' ELSE '' END,
                      CASE WHEN rekap.anomali_41 = 1 THEN ',41' ELSE '' END,
                      CASE WHEN rekap.anomali_42 = 1 THEN ',42' ELSE '' END,
                      CASE WHEN rekap.anomali_43 = 1 THEN ',43' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_39,rekap.anomali_40,rekap.anomali_41,rekap.anomali_42,rekap.anomali_43
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               ,IIF((anomali_39.anomali_arr IS NULL AND root.r1201b_value = 5 AND pair_d.pair_value = 'D'),1,0) AS anomali_39
               ,IIF((anomali_40.anomali_arr IS NULL AND art.r407 < 17 AND (root.r1204a_value = 1 OR root.r1204b_value = 1 )),1,0) AS anomali_40
               ,IIF((anomali_41.anomali_arr IS NULL 
                    AND root.r1204a_value = 1  AND root.r1206ai_value = 5 AND root.r1206aii_value = 5 AND root.r1206aiii_value = 5
                    AND root.r1206aiv_value = 5 AND root.r1206av_value = 5 AND root.r1206avi_value = 5),1,0) AS anomali_41
               ,IIF((anomali_42.anomali_arr IS NULL 
                    AND root.r1204b_value = 1  AND root.r1206bi_value = 5 AND root.r1206bii_value = 5 AND root.r1206biii_value = 5
                    AND root.r1206biv_value = 5 AND root.r1206bv_value = 5 AND root.r1206bvi_value = 5),1,0) AS anomali_42
               ,IIF((anomali_43.anomali_arr IS NULL 
                    AND (root.r1204a_value = 1 OR root.r1204b_value = 1 ) AND root.r1207a_value = 5 AND root.r1207b_value = 5 
                    AND root.r1207c_value = 5 ),1,0) AS anomali_43
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_39.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_39
                  ON root.assignment_id = anomali_39.assignment_id AND anomali_39.anomali_arr = '39'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_40
                  ON root.assignment_id = anomali_40.assignment_id AND anomali_40.anomali_arr = '40'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_41
                  ON root.assignment_id = anomali_41.assignment_id AND anomali_41.anomali_arr = '41'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_42
                  ON root.assignment_id = anomali_42.assignment_id AND anomali_42.anomali_arr = '42'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_43
                  ON root.assignment_id = anomali_43.assignment_id AND anomali_43.anomali_arr = '43'
                  
            LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_d
                  ON root.assignment_id = pair_d.assignment_id AND pair_d.data_key = 'r414' AND pair_d.pair_value = 'D'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_39.anomali_arr IS NULL
            AND anomali_40.anomali_arr IS NULL
            AND anomali_41.anomali_arr IS NULL
            AND anomali_42.anomali_arr IS NULL
            AND anomali_43.anomali_arr IS NULL) rekap
WHERE rekap.anomali_39 = 1 
      OR rekap.anomali_40 = 1 
      OR rekap.anomali_41 = 1 
      OR rekap.anomali_42 = 1 
      OR rekap.anomali_43 = 1 

/* Anomali 44-47 Blok Fintech Lending 
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_44 = 1 THEN ',44' ELSE '' END,
                      CASE WHEN rekap.anomali_45 = 1 THEN ',45' ELSE '' END,
                      CASE WHEN rekap.anomali_46 = 1 THEN ',46' ELSE '' END,
                      CASE WHEN rekap.anomali_47 = 1 THEN ',47' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_44,rekap.anomali_45,rekap.anomali_46,rekap.anomali_47
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               
               ,IIF((anomali_44.anomali_arr IS NULL AND art.r407 < 17 AND (root.r1304a_value = 1 OR root.r1304b_value = 1 )),1,0) AS anomali_44
               ,IIF((anomali_45.anomali_arr IS NULL 
                    AND root.r1304a_value = 1  AND root.r1306ai_value = 5 AND root.r1306aii_value = 5 AND root.r1306aiii_value = 5
                    AND root.r1306aiv_value = 5 AND root.r1306av_value = 5 AND root.r1306avi_value = 5),1,0) AS anomali_45
               ,IIF((anomali_46.anomali_arr IS NULL 
                    AND root.r1304b_value = 1  AND root.r1306bi_value = 5 AND root.r1306bii_value = 5 AND root.r1306biii_value = 5
                    AND root.r1306biv_value = 5 AND root.r1306bv_value = 5 AND root.r1306bvi_value = 5),1,0) AS anomali_46
               ,IIF((anomali_47.anomali_arr IS NULL 
                    AND (root.r1304a_value = 1 OR root.r1304b_value = 1 ) AND root.r1307a_value = 5 AND root.r1307b_value = 5 
                    AND root.r1307c_value = 5 ),1,0) AS anomali_47
                    
               ,usr.PPL
               ,usr.PML
              
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_44.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_44
                  ON root.assignment_id = anomali_44.assignment_id AND anomali_44.anomali_arr = '44'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_45
                  ON root.assignment_id = anomali_45.assignment_id AND anomali_45.anomali_arr = '45'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_46
                  ON root.assignment_id = anomali_46.assignment_id AND anomali_46.anomali_arr = '46'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_47
                  ON root.assignment_id = anomali_47.assignment_id AND anomali_47.anomali_arr = '47'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_44.anomali_arr IS NULL
            AND anomali_45.anomali_arr IS NULL
            AND anomali_46.anomali_arr IS NULL
            AND anomali_47.anomali_arr IS NULL) rekap
WHERE rekap.anomali_44 = 1 
      OR rekap.anomali_45 = 1 
      OR rekap.anomali_46 = 1 
      OR rekap.anomali_47 = 1 
      
/* Anomali 48-54 Blok LJK Lainnya
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_48 = 1 THEN ',48' ELSE '' END,
                      CASE WHEN rekap.anomali_49 = 1 THEN ',49' ELSE '' END,
                      CASE WHEN rekap.anomali_50 = 1 THEN ',50' ELSE '' END,
                      CASE WHEN rekap.anomali_51 = 1 THEN ',51' ELSE '' END,
                      CASE WHEN rekap.anomali_52 = 1 THEN ',52' ELSE '' END,
                      CASE WHEN rekap.anomali_53 = 1 THEN ',53' ELSE '' END,
                      CASE WHEN rekap.anomali_54 = 1 THEN ',54' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_48,rekap.anomali_49,rekap.anomali_50,rekap.anomali_51,rekap.anomali_52,rekap.anomali_53,rekap.anomali_54
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               ,IIF((anomali_48.anomali_arr IS NULL AND root.r1401c_value = 5 AND pair_c.pair_value = 'C'),1,0) AS anomali_48
               ,IIF((anomali_49.anomali_arr IS NULL AND art.r407 < 17 AND (root.r1404a_value = 1 OR root.r1404b_value = 1 
                    OR root.r1404c_value = 1  OR root2.r1404d_value = 1 )),1,0) AS anomali_49
               ,IIF((anomali_50.anomali_arr IS NULL 
                    AND root.r1404a_value = 1  AND root.r1406ai_value = 5 AND root.r1406aii_value = 5 AND root.r1406aiii_value = 5
                    AND root.r1406aiv_value = 5 AND root.r1406av_value = 5 AND root.r1406avi_value = 5),1,0) AS anomali_50
               ,IIF((anomali_51.anomali_arr IS NULL 
                    AND root.r1404b_value = 1  AND root.r1406bi_value = 5 AND root.r1406bii_value = 5 AND root.r1406biii_value = 5
                    AND root.r1406biv_value = 5 AND root.r1406bv_value = 5 AND root.r1406bvi_value = 5),1,0) AS anomali_51
               ,IIF((anomali_52.anomali_arr IS NULL 
                    AND root.r1404c_value = 1  AND root.r1406ci_value = 5 AND root.r1406cii_value = 5 AND root.r1406ciii_value = 5
                    AND root.r1406civ_value = 5 AND root.r1406v_value = 5 AND root.r1406cvi_value = 5),1,0) AS anomali_52
               ,IIF((anomali_53.anomali_arr IS NULL 
                    AND root2.r1404d_value = 1  AND root2.r1406di_value = 5 AND root2.r1406dii_value = 5 AND root2.r1406diii_value = 5
                    AND root2.r1406div_value = 5 AND root2.r1406dv_value = 5 AND root2.r1406dvi_value = 5),1,0) AS anomali_53
               ,IIF((anomali_54.anomali_arr IS NULL 
                    AND (root.r1404a_value = 1 OR root.r1404b_value = 1 OR root.r1404c_value = 1 OR root2.r1404d_value = 1 )
                    AND root.r1407a_value = 5 AND root.r1407b_value = 5 AND root.r1407c_value = 5 ),1,0) AS anomali_54
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_48.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 root2 
                  ON root.assignment_id = root2.assignment_id       
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_48
                  ON root.assignment_id = anomali_48.assignment_id AND anomali_48.anomali_arr = '48'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_49
                  ON root.assignment_id = anomali_49.assignment_id AND anomali_49.anomali_arr = '49'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_50
                  ON root.assignment_id = anomali_50.assignment_id AND anomali_50.anomali_arr = '50'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_51
                  ON root.assignment_id = anomali_51.assignment_id AND anomali_51.anomali_arr = '51'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_52
                  ON root.assignment_id = anomali_52.assignment_id AND anomali_52.anomali_arr = '52'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_53
                  ON root.assignment_id = anomali_53.assignment_id AND anomali_53.anomali_arr = '53'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_54
                  ON root.assignment_id = anomali_54.assignment_id AND anomali_54.anomali_arr = '54'
            
            LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_c
                  ON root.assignment_id = pair_c.assignment_id AND pair_c.data_key = 'r414' AND pair_c.pair_value = 'C'      
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_48.anomali_arr IS NULL
            AND anomali_49.anomali_arr IS NULL
            AND anomali_50.anomali_arr IS NULL
            AND anomali_51.anomali_arr IS NULL
            AND anomali_52.anomali_arr IS NULL
            AND anomali_53.anomali_arr IS NULL
            AND anomali_54.anomali_arr IS NULL) rekap
WHERE rekap.anomali_48 = 1 
      OR rekap.anomali_49 = 1 
      OR rekap.anomali_50 = 1 
      OR rekap.anomali_51 = 1 
      OR rekap.anomali_52 = 1 
      OR rekap.anomali_53 = 1 
      OR rekap.anomali_54 = 1 

/* Anomali 55-56 Blok PSP
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_55 = 1 THEN ',55' ELSE '' END,
                      CASE WHEN rekap.anomali_56 = 1 THEN ',56' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_55,rekap.anomali_56
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               ,IIF((anomali_55.anomali_arr IS NULL 
                    AND root.r1504_value = 1  AND root.r1506i_value = 5 AND root.r1506ii_value = 5 AND root.r1506iii_value = 5
                    AND root.r1506iv_value = 5 AND root.r1506v_value = 5 AND root.r1506vi_value = 5),1,0) AS anomali_55
               ,IIF((anomali_56.anomali_arr IS NULL 
                    AND root.r1504_value = 1 AND root.r1507a_value = 5 AND root.r1507b_value = 5 AND root.r1507c_value = 5 
                    AND root.r1507d_value = 5 AND root.r1507e_value = 5  ),1,0) AS anomali_56
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_55.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_55
                  ON root.assignment_id = anomali_55.assignment_id AND anomali_55.anomali_arr = '55'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_56
                  ON root.assignment_id = anomali_56.assignment_id AND anomali_56.anomali_arr = '56'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_55.anomali_arr IS NULL
            AND anomali_56.anomali_arr IS NULL) rekap
WHERE rekap.anomali_55 = 1 
      OR rekap.anomali_56 = 1 

/* Anomali 57-58 Blok 16
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_57 = 1 THEN ',57' ELSE '' END,
                      CASE WHEN rekap.anomali_58 = 1 THEN ',58' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_57,rekap.anomali_58
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               ,IIF((anomali_57.anomali_arr IS NULL 
                    AND (root.r503a_value = 1 OR root.r603a_value = 1 OR root.r803a_value = 1 OR root.r903a_value = 1 
                    OR root.r1003a_value = 1 OR root.r1103a_value = 1 OR root.r1203a_value = 1 OR root.r1303a_value = 1 
                    OR root.r1403a_value = 1 OR root.r1503_value = 1 ) 
                    AND root.r505a_value = 5 AND root.r605a_value = 5 AND root.r805a_value = 5 AND root.r905a_value = 5
                    AND root.r1005a_value = 5 AND root.r1105a_value = 5 AND root.r1205a_value = 5 AND root.r1305a_value = 5
                    AND root.r1405a_value = 5 AND root.r1405b_value = 5 AND root.r1503_value = 5 
                    AND root2.r1601ai_value = 5 AND root2.r1601aii_value = 5 AND root2.r1601aiii_value = 5 AND root2.r1601aiv_value = 5 
                    AND root2.r1601av_value = 5 AND root2.r1601avi_value = 5 AND root2.r1601avii_value = 5 AND root2.r1601aviii_value = 5),1,0) AS anomali_57
               ,IIF((anomali_58.anomali_arr IS NULL 
                    AND (root.r503b_value = 1 OR root.r603b_value = 1 OR root.r803b_value = 1 OR root.r903b_value = 1 
                    OR root.r1003b_value = 1 OR root.r1103b_value = 1 OR root.r1203b_value = 1 OR root.r1303b_value = 1 
                    OR root2.r1403d_value = 1 ) 
                    AND root.r505b_value = 5 AND root.r605b_value = 5 AND root.r805b_value = 5 AND root.r905b_value = 5
                    AND root.r1005b_value = 5 AND root.r1105b_value = 5 AND root.r1205b_value = 5 AND root.r1305b_value = 5
                    AND root2.r1405d_value = 5  
                    AND root2.r1601bi_value = 5 AND root2.r1601bii_value = 5 AND root2.r1601biii_value = 5 AND root2.r1601biv_value = 5 
                    AND root2.r1601bv_value = 5 AND root2.r1601bvi_value = 5 AND root2.r1601bvii_value = 5 AND root2.r1601bviii_value = 5),1,0) AS anomali_58
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_57.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
                  
            LEFT JOIN tyo_93d2145f.root_table_2 root2 
                  ON root.assignment_id = root2.assignment_id           
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_57
                  ON root.assignment_id = anomali_57.assignment_id AND anomali_57.anomali_arr = '57'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_58
                  ON root.assignment_id = anomali_58.assignment_id AND anomali_58.anomali_arr = '58'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_57.anomali_arr IS NULL
            AND anomali_58.anomali_arr IS NULL) rekap
WHERE rekap.anomali_57 = 1 
      OR rekap.anomali_58 = 1 

/* Anomali 59-61 Blok 17
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_59 = 1 THEN ',59' ELSE '' END,
                      CASE WHEN rekap.anomali_60 = 1 THEN ',60' ELSE '' END,
                      CASE WHEN rekap.anomali_61 = 1 THEN ',61' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_59,rekap.anomali_60,rekap.anomali_61
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
              
               ,IIF((anomali_59.anomali_arr IS NULL 
                    AND (root.r412_value = '03' OR root.r412_value = '06' OR root.r412_value = '08')
                    AND root.r1701a_value = 5 AND root.r1701b_value = 5 AND root2.r1701c_value = 5 
                    AND root2.r1701d_value = 5 AND root2.r1701e_value = 5 AND root2.r1701f_value = 5 ),1,0) AS anomali_59
               ,IIF((anomali_60.anomali_arr IS NULL 
                    AND art.r408_value > 5 AND root.r1701a_value = 5 AND root.r1701b_value = 5 AND root2.r1701c_value = 5 
                    AND root2.r1701d_value = 5 AND root2.r1701e_value = 5 AND root2.r1701f_value = 5 ),1,0) AS anomali_60
               ,IIF((anomali_61.anomali_arr IS NULL 
                    AND art.r408_value > 5 AND root2.r1702_value != 2 ),1,0) AS anomali_61
                    
               ,usr.PPL
               ,usr.PML
              
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_59.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
            LEFT JOIN tyo_93d2145f.nested_art art
                  ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
                  
            LEFT JOIN tyo_93d2145f.root_table_2 root2 
                  ON root.assignment_id = root2.assignment_id      
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_59
                  ON root.assignment_id = anomali_59.assignment_id AND anomali_59.anomali_arr = '59'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_60
                  ON root.assignment_id = anomali_60.assignment_id AND anomali_60.anomali_arr = '60'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_61
                  ON root.assignment_id = anomali_61.assignment_id AND anomali_61.anomali_arr = '61'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_59.anomali_arr IS NULL
            AND anomali_60.anomali_arr IS NULL
            AND anomali_61.anomali_arr IS NULL) rekap
WHERE rekap.anomali_59 = 1 
      OR rekap.anomali_60 = 1 
      OR rekap.anomali_61 = 1 

/* Anomali 62-64 Blok Perbankan
  Link list anomali: http://s.bps.go.id/List-Anomali-SNLIK2026
*/

SELECT  rekap.assignment_id
        ,rekap.level_1_full_code  AS [Kode Prov]
        ,rekap.level_1_name       AS [Provinsi]
        ,rekap.level_2_full_code  AS [Kode Kab/Kota]
        ,rekap.level_2_name       AS [Kab/Kota]
        ,rekap.level_3_full_code  AS [Kode Kecamatan]
        ,rekap.level_3_name       AS [Kecamatan]
        ,rekap.level_4_full_code  AS [Kode Desa]
        ,rekap.level_4_name       AS [Desa]
        ,rekap.level_6_full_code  AS [Kode SLS]
        ,rekap.nks_baru           AS [NKS]
        ,rekap.nu_sampel          AS [NUS]
        ,rekap.bersedia_value
        ,rekap.bersedia_label
        ,rekap.r110               AS [KRT]
        ,rekap.responden_terpilih
        ,rekap.PPL
        ,rekap.PML
        ,rekap.date AS [Date Modified]
        
        ,LTRIM(
            STUFF(
              CONCAT(
                      CASE WHEN rekap.anomali_62 = 1 THEN ',62' ELSE '' END,
                      CASE WHEN rekap.anomali_63 = 1 THEN ',63' ELSE '' END,
                      CASE WHEN rekap.anomali_64 = 1 THEN ',64' ELSE '' END
                    ),
              1, 1, ''
            )
        ) AS rekap_anomali
        
        ,rekap.[Link]
        ,rekap.catatan
        ,rekap.is_active
        ,rekap.survey_period_id
        
        ,rekap.level_1_full_code  
        ,rekap.level_2_full_code
        ,rekap.level_3_full_code 
        ,rekap.level_4_full_code 
        ,rekap.level_6_full_code 
        ,rekap.anomali_62,rekap.anomali_63,rekap.anomali_64
               

    FROM (SELECT  root.assignment_id
               ,root.level_1_full_code  
               ,root.level_1_name       
               ,root.level_2_full_code  
               ,root.level_2_name       
               ,root.level_3_full_code  
               ,root.level_3_name       
               ,root.level_4_full_code  
               ,root.level_4_name       
               ,root.level_6_full_code  
               ,root.nks_baru           
               ,root.nu_sampel         
               ,root.bersedia_value
               ,root.bersedia_label
               ,root.r110              
               ,root.responden_terpilih
               
               ,IIF((anomali_62.anomali_arr IS NULL 
                    AND root.r501a_value = 5 AND root.r501b_value = 5
                    AND (root.r601a_value = 1 OR root.r601b_value = 1 OR root.r801a_value = 1 OR root.r801b_value = 1 
                    OR root.r901a_value = 1 OR root.r901b_value = 1 OR root.r1001a_value = 1 OR root.r1001b_value = 1 
                    OR root.r1101a_value = 1 OR root.r1101b_value = 1 OR root.r1201a_value = 1 OR root.r1201b_value = 1 
                    OR root.r1301a_value = 1 OR root.r1301b_value = 1 OR root.r1401a_value = 1 OR root.r1401b_value = 1
                    OR root2.r1401d_value = 1 OR root.r1501_value = 1 )),1,0) AS anomali_62
               ,IIF((anomali_63.anomali_arr IS NULL 
                    AND root.r501a_value = 5 AND root.r501b_value = 5
                    AND (root.r603a_value = 1 OR root.r603b_value = 1 OR root.r803a_value = 1 OR root.r803b_value = 1 
                    OR root.r903a_value = 1 OR root.r903b_value = 1 OR root.r1003a_value = 1 OR root.r1003b_value = 1 
                    OR root.r1103a_value = 1 OR root.r1103b_value = 1 OR root.r1203a_value = 1 OR root.r1203b_value = 1 
                    OR root.r1303a_value = 1 OR root.r1303b_value = 1 OR root.r1403a_value = 1 OR root.r1403b_value = 1
                    OR root2.r1403d_value = 1 OR root.r1503_value = 1 )),1,0) AS anomali_63
               ,IIF((anomali_64.anomali_arr IS NULL 
                    AND root.r503a_value = 5 AND root.r503b_value = 5
                    AND (root.r605a_value = 1 OR root.r605b_value = 1 OR root.r805a_value = 1 OR root.r805b_value = 1 
                    OR root.r905a_value = 1 OR root.r905b_value = 1 OR root.r1005a_value = 1 OR root.r1005b_value = 1 
                    OR root.r1105a_value = 1 OR root.r1105b_value = 1 OR root.r1205a_value = 1 OR root.r1205b_value = 1 
                    OR root.r1305a_value = 1 OR root.r1305b_value = 1 OR root.r1405a_value = 1 OR root.r1405b_value = 1
                    OR root2.r1405d_value = 1 OR root.r1505_value = 1 )),1,0) AS anomali_64
                    
               ,usr.PPL
               ,usr.PML
               
               ,DATEADD(HOUR,7,base.date_modified) AS date
               ,CONCAT('<a href = "https://fasih-sm.bps.go.id/survey-collection/assignment-detail/',
                          root.assignment_id,
                          '/4a8b0310-7424-419d-980a-72efe84408a1" target = "_blank">Link Assignment</a>') AS [Link]
               
               ,anomali_62.catatan
               ,base.is_active
               ,base.survey_period_id
               
      FROM tyo_93d2145f.root_table root
      
            LEFT JOIN tyo_93d2145f.root_table_2 root2 
                  ON root.assignment_id = root2.assignment_id    
                  
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_62
                  ON root.assignment_id = anomali_62.assignment_id AND anomali_62.anomali_arr = '62'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_63
                  ON root.assignment_id = anomali_63.assignment_id AND anomali_63.anomali_arr = '63'
            LEFT JOIN tyo_93d2145f.root_table_2 anomali_64
                  ON root.assignment_id = anomali_64.assignment_id AND anomali_64.anomali_arr = '64'
                  
            LEFT JOIN tyo_93d2145f.petugas usr
                  ON root.assignment_id = usr.assignment_id
                  
            LEFT JOIN tyo_93d2145f.base_table_assignment base
                  ON base.id = root.assignment_id
  
      WHERE (base.is_active = 1 AND root.bersedia_value != 3 AND (base.assignment_status_alias = 'APPROVED BY Pengawas' OR base.assignment_status_alias = 'COMPLETED BY Pengawas'))
            AND anomali_62.anomali_arr IS NULL
            AND anomali_63.anomali_arr IS NULL
            AND anomali_64.anomali_arr IS NULL) rekap
WHERE rekap.anomali_62 = 1 
      OR rekap.anomali_63 = 1 
      OR rekap.anomali_64 = 1 