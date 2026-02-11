SELECT
    *
FROM (
    SELECT
        ROW_NUMBER() OVER (ORDER BY KODE_PROV, KODE_KAB, KODE_KEC, KODE_DESA, KODE_SLS) AS "NO.",
        *
    FROM (
        SELECT
            -- INFORMASI WILAYAH DAN SAMPEL
            root.assignment_id,
            root.level_1_full_code AS KODE_PROV,
            root.level_1_name AS PROVINSI,
            root.level_2_full_code AS KODE_KAB,
            root.level_2_name AS KAB_KOTA,
            root.level_3_full_code AS KODE_KEC,
            root.level_3_name AS KECAMATAN,
            root.level_4_full_code AS KODE_DESA,
            root.level_4_name AS DESA,
            root.level_6_full_code AS KODE_SLS,
            root.nks_baru AS NKS,
            root.nu_sampel AS NUS,
            root.r110 AS NAMA_KRT,
            root.responden_terpilih AS RESPONDEN,
            
            -- INFORMASI PETUGAS
            usr.PPL AS PPL,
            usr.PML AS PML,
            -- STATUS DOKUMEN (Opsional, agar tahu statusnya apa)
            base.assignment_status_alias AS STATUS_DOKUMEN,

            -- ANOMALI 1-8 (BLOK DEMOGRAFI)
            CASE WHEN (art.r407 < 17 AND root.r412_value = '02') THEN 1 ELSE 0 END AS A1,
            CASE WHEN (art.r408_value = 8 AND pair_a.pair_value = 'A') THEN 1 ELSE 0 END AS A2,
            CASE WHEN ((root.r412_value IN ('03','04','06','08')) AND pair_a.pair_value = 'A') THEN 1 ELSE 0 END AS A3,
            CASE WHEN ((root.r412_value IN ('03','04','06','08')) AND pair_b.pair_value = 'B') THEN 1 ELSE 0 END AS A4,
            CASE WHEN (art.r408_value = 8 AND pair_c.pair_value = 'C') THEN 1 ELSE 0 END AS A5,
            CASE WHEN ((root.r412_value IN ('03','04','06','08','13')) AND pair_c.pair_value = 'C') THEN 1 ELSE 0 END AS A6,
            CASE WHEN (art.r408_value = 8 AND pair_d.pair_value = 'D') THEN 1 ELSE 0 END AS A7,
            CASE WHEN ((root.r412_value IN ('03','04','06','08')) AND pair_d.pair_value = 'D') THEN 1 ELSE 0 END AS A8,

            -- ANOMALI 9-15 (BLOK PERBANKAN)
            CASE WHEN (pair_a.pair_value = 'A' AND root.r501a_value = 5 AND root.r501b_value = 5) THEN 1 ELSE 0 END AS A9,
            CASE WHEN (root.r501a_value = 5 AND root.r504a_value = 1) THEN 1 ELSE 0 END AS A10,
            CASE WHEN (root.r501b_value = 5 AND root.r504b_value = 1) THEN 1 ELSE 0 END AS A11,
            CASE WHEN ((root.r412_value IN ('02','03','04','06')) AND (root.r505a_value = 5 OR root.r505a_value IS NULL) AND (root.r505b_value = 5 OR root.r505b_value IS NULL)) THEN 1 ELSE 0 END AS A12,
            CASE WHEN (root.r504a_value = 1 AND root.r506ai_value = 5 AND root.r506aii_value = 5 AND root.r506aiii_value = 5 AND root.r506aiv_value = 5 AND root.r506av_value = 5 AND root.r506avi_value = 5) THEN 1 ELSE 0 END AS A13,
            CASE WHEN (root.r504b_value = 1 AND root.r506bi_value = 5 AND root.r506bii_value = 5 AND root.r506biii_value = 5 AND root.r506biv_value = 5 AND root.r506bv_value = 5 AND root.r506bvi_value = 5) THEN 1 ELSE 0 END AS A14,
            CASE WHEN ((root.r503b_value = 1 AND root.r504b_value = 1) AND root.r507a_value = 5 AND root.r507b_value = 5 AND root.r507c_value = 5 AND root.r507d_value = 5 AND root.r507e_value = 5) THEN 1 ELSE 0 END AS A15,

            -- ANOMALI 16-19 (BLOK PASAR MODAL)
            CASE WHEN (art.r407 < 17 AND (root.r604a_value = 1 OR root.r604b_value = 1)) THEN 1 ELSE 0 END AS A16,
            CASE WHEN (root.r604a_value = 1 AND root.r606ai_value = 5 AND root.r606aii_value = 5 AND root.r606aiii_value = 5 AND root.r606aiv_value = 5 AND root.r606av_value = 5 AND root.r606avi_value = 5) THEN 1 ELSE 0 END AS A17,
            CASE WHEN (root.r604b_value = 1 AND root.r606bi_value = 5 AND root.r606bii_value = 5 AND root.r606biii_value = 5 AND root.r606biv_value = 5 AND root.r606bv_value = 5 AND root.r606bvi_value = 5) THEN 1 ELSE 0 END AS A18,
            CASE WHEN ((root.r604a_value = 1 OR root.r604b_value = 1) AND root.r607a_value = 5 AND root.r607b_value = 5 AND root.r607c_value = 5) THEN 1 ELSE 0 END AS A19,

            -- ANOMALI 20-23 (BLOK BPJS)
            CASE WHEN (root.r701_value = 5 AND pair_b.pair_value = 'B') THEN 1 ELSE 0 END AS A20,
            CASE WHEN ((root.r412_value IN ('03','04')) AND root.r705_value = 5) THEN 1 ELSE 0 END AS A21,
            CASE WHEN (root.r704_value = 1 AND root.r706i_value = 5 AND root.r706ii_value = 5 AND root.r706iii_value = 5 AND root.r706iv_value = 5 AND root.r706v_value = 5 AND root.r706vi_value = 5) THEN 1 ELSE 0 END AS A22,
            CASE WHEN (root.r704_value = 1 AND root.r707a_value = 5 AND root.r707b_value = 5 AND root.r707c_value = 5 AND root.r707d_value = 5 AND root.r707e_value = 5) THEN 1 ELSE 0 END AS A23,

            -- ANOMALI 24-26 (BLOK PERASURANSIAN)
            CASE WHEN (root.r804a_value = 1 AND root.r806ai_value = 5 AND root.r806aii_value = 5 AND root.r806aiii_value = 5 AND root.r806aiv_value = 5 AND root.r806av_value = 5 AND root.r806avi_value = 5) THEN 1 ELSE 0 END AS A24,
            CASE WHEN (root.r804b_value = 1 AND root.r806bi_value = 5 AND root.r806bii_value = 5 AND root.r806biii_value = 5 AND root.r806biv_value = 5 AND root.r806bv_value = 5 AND root.r806bvi_value = 5) THEN 1 ELSE 0 END AS A25,
            CASE WHEN ((root.r804a_value = 1 OR root.r804b_value = 1) AND root.r807a_value = 5 AND root.r807c_value = 5 AND root.r807d_value = 5 AND root.r807e_value = 5) THEN 1 ELSE 0 END AS A26,

            -- ANOMALI 27-30 (BLOK LEMBAGA PEMBIAYAAN)
            CASE WHEN (art.r407 < 17 AND (root.r904a_value = 1 OR root.r904b_value = 1)) THEN 1 ELSE 0 END AS A27,
            CASE WHEN (root.r904a_value = 1 AND root.r906ai_value = 5 AND root.r906aii_value = 5 AND root.r906aiii_value = 5 AND root.r906aiv_value = 5 AND root.r906av_value = 5 AND root.r906avi_value = 5) THEN 1 ELSE 0 END AS A28,
            CASE WHEN (root.r904b_value = 1 AND root.r906bi_value = 5 AND root.r906bii_value = 5 AND root.r906biii_value = 5 AND root.r906biv_value = 5 AND root.r906bv_value = 5 AND root.r906bvi_value = 5) THEN 1 ELSE 0 END AS A29,
            CASE WHEN ((root.r904a_value = 1 OR root.r904b_value = 1) AND root.r907a_value = 5 AND root.r907b_value = 5 AND root.r907c_value = 5 AND root.r907d_value = 5 AND root.r907e_value = 5) THEN 1 ELSE 0 END AS A30,

            -- ANOMALI 31-34 (BLOK DANA PENSIUN)
            CASE WHEN (art.r407 < 17 AND (root.r1004a_value = 1 OR root.r1004b_value = 1)) THEN 1 ELSE 0 END AS A31,
            CASE WHEN (root.r1004a_value = 1 AND root.r1006ai_value = 5 AND root.r1006aii_value = 5 AND root.r1006aiii_value = 5 AND root.r1006aiv_value = 5 AND root.r1006av_value = 5 AND root.r1006avi_value = 5) THEN 1 ELSE 0 END AS A32,
            CASE WHEN (root.r1004b_value = 1 AND root.r1006bi_value = 5 AND root.r1006bii_value = 5 AND root.r1006biii_value = 5 AND root.r1006biv_value = 5 AND root.r1006bv_value = 5 AND root.r1006bvi_value = 5) THEN 1 ELSE 0 END AS A33,
            CASE WHEN ((root.r1004a_value = 1 OR root.r1004b_value = 1) AND root.r1007a_value = 5 AND root.r1007b_value = 5 AND root.r1007c_value = 5 AND root.r1007d_value = 5) THEN 1 ELSE 0 END AS A34,

            -- ANOMALI 35-38 (BLOK PERGADAIAN)
            CASE WHEN (art.r407 < 17 AND (root.r1104a_value = 1 OR root.r1104b_value = 1)) THEN 1 ELSE 0 END AS A35,
            CASE WHEN (root.r1104a_value = 1 AND root.r1106ai_value = 5 AND root.r1106aii_value = 5 AND root.r1106aiii_value = 5 AND root.r1106aiv_value = 5 AND root.r1106av_value = 5 AND root.r1106avi_value = 5) THEN 1 ELSE 0 END AS A36,
            CASE WHEN (root.r1104b_value = 1 AND root.r1106bi_value = 5 AND root.r1106bii_value = 5 AND root.r1106biii_value = 5 AND root.r1106biv_value = 5 AND root.r1106bv_value = 5 AND root.r1106bvi_value = 5) THEN 1 ELSE 0 END AS A37,
            CASE WHEN ((root.r1104a_value = 1 OR root.r1104b_value = 1) AND root.r1107a_value = 5 AND root.r1107b_value = 5 AND root.r1107c_value = 5 AND root.r1107d_value = 5 AND root.r1107e_value = 5) THEN 1 ELSE 0 END AS A38,

            -- ANOMALI 39-43 (BLOK LKM)
            CASE WHEN (root.r1201b_value = 5 AND pair_d.pair_value = 'D') THEN 1 ELSE 0 END AS A39,
            CASE WHEN (art.r407 < 17 AND (root.r1204a_value = 1 OR root.r1204b_value = 1)) THEN 1 ELSE 0 END AS A40,
            CASE WHEN (root.r1204a_value = 1 AND root.r1206ai_value = 5 AND root.r1206aii_value = 5 AND root.r1206aiii_value = 5 AND root.r1206aiv_value = 5 AND root.r1206av_value = 5 AND root.r1206avi_value = 5) THEN 1 ELSE 0 END AS A41,
            CASE WHEN (root.r1204b_value = 1 AND root.r1206bi_value = 5 AND root.r1206bii_value = 5 AND root.r1206biii_value = 5 AND root.r1206biv_value = 5 AND root.r1206bv_value = 5 AND root.r1206bvi_value = 5) THEN 1 ELSE 0 END AS A42,
            CASE WHEN ((root.r1204a_value = 1 OR root.r1204b_value = 1) AND root.r1207a_value = 5 AND root.r1207b_value = 5 AND root.r1207c_value = 5) THEN 1 ELSE 0 END AS A43,

            -- ANOMALI 44-47 (BLOK FINTECH)
            CASE WHEN (art.r407 < 17 AND (root.r1304a_value = 1 OR root.r1304b_value = 1)) THEN 1 ELSE 0 END AS A44,
            CASE WHEN (root.r1304a_value = 1 AND root.r1306ai_value = 5 AND root.r1306aii_value = 5 AND root.r1306aiii_value = 5 AND root.r1306aiv_value = 5 AND root.r1306av_value = 5 AND root.r1306avi_value = 5) THEN 1 ELSE 0 END AS A45,
            CASE WHEN (root.r1304b_value = 1 AND root.r1306bi_value = 5 AND root.r1306bii_value = 5 AND root.r1306biii_value = 5 AND root.r1306biv_value = 5 AND root.r1306bv_value = 5 AND root.r1306bvi_value = 5) THEN 1 ELSE 0 END AS A46,
            CASE WHEN ((root.r1304a_value = 1 OR root.r1304b_value = 1) AND root.r1307a_value = 5 AND root.r1307b_value = 5 AND root.r1307c_value = 5) THEN 1 ELSE 0 END AS A47,

            -- ANOMALI 48-54 (BLOK LJK LAINNYA)
            CASE WHEN (root.r1401c_value = 5 AND pair_c.pair_value = 'C') THEN 1 ELSE 0 END AS A48,
            CASE WHEN (art.r407 < 17 AND (root.r1404a_value = 1 OR root.r1404b_value = 1 OR root.r1404c_value = 1 OR root2.r1404d_value = 1)) THEN 1 ELSE 0 END AS A49,
            CASE WHEN (root.r1404a_value = 1 AND root.r1406ai_value = 5 AND root.r1406aii_value = 5 AND root.r1406aiii_value = 5 AND root.r1406aiv_value = 5 AND root.r1406av_value = 5 AND root.r1406avi_value = 5) THEN 1 ELSE 0 END AS A50,
            CASE WHEN (root.r1404b_value = 1 AND root.r1406bi_value = 5 AND root.r1406bii_value = 5 AND root.r1406biii_value = 5 AND root.r1406biv_value = 5 AND root.r1406bv_value = 5 AND root.r1406bvi_value = 5) THEN 1 ELSE 0 END AS A51,
            CASE WHEN (root.r1404c_value = 1 AND root.r1406ci_value = 5 AND root.r1406cii_value = 5 AND root.r1406ciii_value = 5 AND root.r1406civ_value = 5 AND root.r1406v_value = 5 AND root.r1406cvi_value = 5) THEN 1 ELSE 0 END AS A52,
            CASE WHEN (root2.r1404d_value = 1 AND root2.r1406di_value = 5 AND root2.r1406dii_value = 5 AND root2.r1406diii_value = 5 AND root2.r1406div_value = 5 AND root2.r1406dv_value = 5 AND root2.r1406dvi_value = 5) THEN 1 ELSE 0 END AS A53,
            CASE WHEN ((root.r1404a_value = 1 OR root.r1404b_value = 1 OR root.r1404c_value = 1 OR root2.r1404d_value = 1) AND root.r1407a_value = 5 AND root.r1407b_value = 5 AND root.r1407c_value = 5) THEN 1 ELSE 0 END AS A54,

            -- ANOMALI 55-56 (BLOK PSP)
            CASE WHEN (root.r1504_value = 1 AND root.r1506i_value = 5 AND root.r1506ii_value = 5 AND root.r1506iii_value = 5 AND root.r1506iv_value = 5 AND root.r1506v_value = 5 AND root.r1506vi_value = 5) THEN 1 ELSE 0 END AS A55,
            CASE WHEN (root.r1504_value = 1 AND root.r1507a_value = 5 AND root.r1507b_value = 5 AND root.r1507c_value = 5 AND root.r1507d_value = 5 AND root.r1507e_value = 5) THEN 1 ELSE 0 END AS A56,

            -- ANOMALI 57-58 (BLOK 16)
            CASE WHEN (
                (root.r503a_value = 1 OR root.r603a_value = 1 OR root.r803a_value = 1 OR root.r903a_value = 1 OR root.r1003a_value = 1 OR root.r1103a_value = 1 OR root.r1203a_value = 1 OR root.r1303a_value = 1 OR root.r1403a_value = 1 OR root.r1503_value = 1) 
                AND root.r505a_value = 5 AND root.r605a_value = 5 AND root.r805a_value = 5 AND root.r905a_value = 5 AND root.r1005a_value = 5 AND root.r1105a_value = 5 AND root.r1205a_value = 5 AND root.r1305a_value = 5 AND root.r1405a_value = 5 AND root.r1405b_value = 5 AND root.r1503_value = 5 
                AND root2.r1601ai_value = 5 AND root2.r1601aii_value = 5 AND root2.r1601aiii_value = 5 AND root2.r1601aiv_value = 5 AND root2.r1601av_value = 5 AND root2.r1601avi_value = 5 AND root2.r1601avii_value = 5 AND root2.r1601aviii_value = 5
            ) THEN 1 ELSE 0 END AS A57,
            CASE WHEN (
                (root.r503b_value = 1 OR root.r603b_value = 1 OR root.r803b_value = 1 OR root.r903b_value = 1 OR root.r1003b_value = 1 OR root.r1103b_value = 1 OR root.r1203b_value = 1 OR root.r1303b_value = 1 OR root2.r1403d_value = 1) 
                AND root.r505b_value = 5 AND root.r605b_value = 5 AND root.r805b_value = 5 AND root.r905b_value = 5 AND root.r1005b_value = 5 AND root.r1105b_value = 5 AND root.r1205b_value = 5 AND root.r1305b_value = 5 AND root2.r1405d_value = 5 
                AND root2.r1601bi_value = 5 AND root2.r1601bii_value = 5 AND root2.r1601biii_value = 5 AND root2.r1601biv_value = 5 AND root2.r1601bv_value = 5 AND root2.r1601bvi_value = 5 AND root2.r1601bvii_value = 5 AND root2.r1601bviii_value = 5
            ) THEN 1 ELSE 0 END AS A58,

            -- ANOMALI 59-61 (BLOK 17)
            CASE WHEN ((root.r412_value IN ('03','06','08')) AND root.r1701a_value = 5 AND root.r1701b_value = 5 AND root2.r1701c_value = 5 AND root2.r1701d_value = 5 AND root2.r1701e_value = 5 AND root2.r1701f_value = 5) THEN 1 ELSE 0 END AS A59,
            CASE WHEN (art.r408_value > 5 AND root.r1701a_value = 5 AND root.r1701b_value = 5 AND root2.r1701c_value = 5 AND root2.r1701d_value = 5 AND root2.r1701e_value = 5 AND root2.r1701f_value = 5) THEN 1 ELSE 0 END AS A60,
            CASE WHEN (art.r408_value > 5 AND root2.r1702_value != 2) THEN 1 ELSE 0 END AS A61,

            -- ANOMALI 62-64 (PERBANKAN TAMBAHAN)
            CASE WHEN (
                root.r501a_value = 5 AND root.r501b_value = 5 AND 
                (root.r601a_value = 1 OR root.r601b_value = 1 OR root.r801a_value = 1 OR root.r801b_value = 1 OR root.r901a_value = 1 OR root.r901b_value = 1 OR root.r1001a_value = 1 OR root.r1001b_value = 1 OR root.r1101a_value = 1 OR root.r1101b_value = 1 OR root.r1201a_value = 1 OR root.r1201b_value = 1 OR root.r1301a_value = 1 OR root.r1301b_value = 1 OR root.r1401a_value = 1 OR root.r1401b_value = 1 OR root2.r1401d_value = 1 OR root.r1501_value = 1)
            ) THEN 1 ELSE 0 END AS A62,
            CASE WHEN (
                root.r501a_value = 5 AND root.r501b_value = 5 AND 
                (root.r603a_value = 1 OR root.r603b_value = 1 OR root.r803a_value = 1 OR root.r803b_value = 1 OR root.r903a_value = 1 OR root.r903b_value = 1 OR root.r1003a_value = 1 OR root.r1003b_value = 1 OR root.r1103a_value = 1 OR root.r1103b_value = 1 OR root.r1203a_value = 1 OR root.r1203b_value = 1 OR root.r1303a_value = 1 OR root.r1303b_value = 1 OR root.r1403a_value = 1 OR root.r1403b_value = 1 OR root2.r1403d_value = 1 OR root.r1503_value = 1)
            ) THEN 1 ELSE 0 END AS A63,
            CASE WHEN (
                root.r503a_value = 5 AND root.r503b_value = 5 AND 
                (root.r605a_value = 1 OR root.r605b_value = 1 OR root.r805a_value = 1 OR root.r805b_value = 1 OR root.r905a_value = 1 OR root.r905b_value = 1 OR root.r1005a_value = 1 OR root.r1005b_value = 1 OR root.r1105a_value = 1 OR root.r1105b_value = 1 OR root.r1205a_value = 1 OR root.r1205b_value = 1 OR root.r1305a_value = 1 OR root.r1305b_value = 1 OR root.r1405a_value = 1 OR root.r1405b_value = 1 OR root2.r1405d_value = 1 OR root.r1505_value = 1)
            ) THEN 1 ELSE 0 END AS A64,

            -- EXTRA
            root2.catatan AS CATATAN,
            CONCAT('<a href="https://fasih-sm.bps.go.id/survey-collection/assignment-detail/', root.assignment_id, '/4a8b0310-7424-419d-980a-72efe84408a1" target="_blank">Link Assignment</a>') AS Link

        FROM tyo_93d2145f.root_table root
        
        -- Join ke ART (Untuk data individu, misal Umur r407)
        LEFT JOIN tyo_93d2145f.nested_art art 
            ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
        
        -- Join ke Root Table 2 (Untuk data lanjutan r14xx, r16xx, r17xx)
        LEFT JOIN tyo_93d2145f.root_table_2 root2 
            ON root.assignment_id = root2.assignment_id
        
        -- Join untuk Parameter Loop (A/B/C/D)
        LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_a 
            ON root.assignment_id = pair_a.assignment_id AND pair_a.data_key = 'r414' AND pair_a.pair_value = 'A'
        LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_b 
            ON root.assignment_id = pair_b.assignment_id AND pair_b.data_key = 'r414' AND pair_b.pair_value = 'B'
        LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_c 
            ON root.assignment_id = pair_c.assignment_id AND pair_c.data_key = 'r414' AND pair_c.pair_value = 'C'
        LEFT JOIN tyo_93d2145f.pair_label_value_0 pair_d 
            ON root.assignment_id = pair_d.assignment_id AND pair_d.data_key = 'r414' AND pair_d.pair_value = 'D'

        -- Join Informasi Petugas (Menggunakan tabel tyo_93d2145f.petugas)
        LEFT JOIN tyo_93d2145f.petugas usr
            ON root.assignment_id = usr.assignment_id

        -- Join Status Assignment
        LEFT JOIN tyo_93d2145f.base_table_assignment base ON base.id = root.assignment_id

        -- FILTER: Hanya yang Aktif dan Bersedia (Status apapun: Approved, Completed, Submitted, etc)
        WHERE base.is_active = 1 
          AND root.bersedia_value != 3 
    ) AS subquery
) AS subquery2