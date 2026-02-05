SELECT
    *
FROM (
    SELECT
        ROW_NUMBER() OVER (ORDER BY KODE_DAERAH, DSRT, NO_ART) AS "NO.",
        *
    FROM (
        SELECT
            -- Informasi Wilayah dan ART
            art.level_1_code AS KODE_PROV,
            art.level_1_name AS PROV,
            art.level_2_code AS KODE_KAB,
            art.level_2_name AS KAB,
            art.level_3_code AS KODE_KEC,
            art.level_3_name AS KEC,
            art.level_4_code AS KODE_DESA,
            art.level_4_name AS DESA,
            art.level_5_code AS SLS,
            art.level_6_code AS SUBSLS,
            art.level_6_full_code AS KODE_DAERAH,
            RIGHT('0' + CAST(root.no_dsrt AS VARCHAR(2)), 2) AS DSRT,
            root.namakrt AS NAMA_KRT,
            art.ppno AS NO_ART,
            art.dem_name AS NAMA_ART,
            art.dem_age AS UMUR,
            root.flag AS JENIS_SAMPEL,

            
            -- ANOMALI PUSAT (A1 - A28)
            -- Anomali A1
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value IN (59111, 59121, 59131, 60101, 60201, 63911, 78411, 78419, 85111, 85112, 85131, 85210, 85230, 85311, 85312, 85331, 85430, 86101, 86102, 86104, 87301, 87901, 88101, 88991, 91011, 91021, 91023) OR (mjj_kbli_value >= 84111 AND mjj_kbli_value <= 84300)) AND mjj_emprel_value IS NOT NULL AND mju_ins_value IS NOT NULL AND mjc_contra_value IS NOT NULL AND (mjj_emprel_value IN (2, 3) OR mju_ins_value <> 1)) THEN 1 ELSE 0 END AS A1,
            -- Anomali A2
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value >= 84111 AND mjj_kbli_value <= 84300) AND mjj_kbji_value IS NOT NULL AND mjj_kbji_value IN (1111, 1112, 2612) AND dem_edl_value IS NOT NULL AND dem_edl_value < 8) THEN 1 ELSE 0 END AS A2,
            -- Anomali A4
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IN (3351, 3352, 3353, 3354, 3359, 5411, 5413, 8311) AND ((mju_ins_value IS NOT NULL AND mju_ins_value <> 1) OR (mjj_kbli_value IS NOT NULL AND (mjj_kbli_value < 84111 OR mjj_kbli_value > 84300)) OR (dem_edl_value IS NOT NULL AND dem_edl_value < 4))) THEN 1 ELSE 0 END AS A4,
            -- Anomali A5
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND sjb_text_value = 2 AND mjj_kbli_value IS NOT NULL AND mjj_kbli_value >= 05100 AND (agf_chk_a_value = 1 OR agf_chk_b_value = 1 OR agf_chk_c_value = 1 OR agf_chk_d_value = 1 OR agf_chk_e_value = 1 OR agf_chk_f_value = 1 OR agf_chk_g_value = 1)) THEN 1 ELSE 0 END AS A5,
            -- Anomali A6
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND sjb_text_value = 2 AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value >= 01111 AND mjj_kbli_value <= 03279) AND agf_chk_h_value = 1) THEN 1 ELSE 0 END AS A6,
            -- Anomali A7
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND dem_edl_value = 4 AND dem_edf_kd_value IS NOT NULL AND (dem_edf_kd_value > 4 AND dem_edf_kd_value < 998)) THEN 1 ELSE 0 END AS A7,
            -- Anomali A8
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND dem_edl_value IN (5, 6) AND dem_edf_kd_value IS NOT NULL AND dem_edf_kd_value > 52 AND dem_edf_kd_value < 998) THEN 1 ELSE 0 END AS A8,
            -- Anomali A9
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND dem_edl_value = 7 AND dem_pnylgr_value = 4 AND dem_edf_kd_value IS NOT NULL AND dem_edf_kd_value <> 999) THEN 1 ELSE 0 END AS A9,
            -- Anomali A10
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND dem_edl_value = 8 AND dem_pnylgr_value = 4 AND dem_edf_kd_value IS NOT NULL AND dem_edf_kd_value <> 999) THEN 1 ELSE 0 END AS A10,
            -- Anomali A11
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND (dem_edl_value >= 9 AND dem_edl_value <= 12) AND dem_pnylgr_value = 4 AND dem_edf_kd_value IS NOT NULL AND dem_edf_kd_value <> 999) THEN 1 ELSE 0 END AS A11,
            -- Anomali A12
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND ((mjj_kbli_value >= 64110 AND mjj_kbli_value <= 64132) OR (mjj_kbli_value >= 84111 AND mjj_kbli_value <= 84234) OR mjj_kbli_value = 99000) AND dem_edl_value = 1) THEN 1 ELSE 0 END AS A12,
            -- Anomali A13
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IN (111, 112, 113, 114, 115) AND dem_edl_value < 4) THEN 1 ELSE 0 END AS A13,
            -- Anomali A14
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IN (211, 212, 213, 214, 215, 311, 312, 313, 314, 315) AND dem_edl_value < 3) THEN 1 ELSE 0 END AS A14,
            -- Anomali A15
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IS NOT NULL AND ((mjj_kbji_value >= 1111 AND mjj_kbji_value <= 1112) OR (mjj_kbji_value >= 2111 AND mjj_kbji_value <= 2356) OR (mjj_kbji_value >= 2411 AND mjj_kbji_value <= 2643)) AND dem_edl_value < 4) THEN 1 ELSE 0 END AS A15,
            -- Anomali A16
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IS NOT NULL AND (mjj_kbji_value >= 1113 AND mjj_kbji_value <= 1431) AND dem_edl_value < 2) THEN 1 ELSE 0 END AS A16,
            -- Anomali A17
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IN (111, 112, 113, 114, 115) AND dem_age < 18) THEN 1 ELSE 0 END AS A17,
            -- Anomali A18
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IN (211, 212, 213, 214, 215, 311, 312, 313, 314, 315) AND dem_age < 16) THEN 1 ELSE 0 END AS A18,
            -- Anomali A19
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND ((mjj_kbji_value >= 1111 AND mjj_kbji_value <= 1431) OR (mjj_kbji_value >= 2111 AND mjj_kbji_value <= 2356) OR (mjj_kbji_value >= 2411 AND mjj_kbji_value <= 2643) OR (mjj_kbji_value >= 3111 AND mjj_kbji_value <= 3413)) AND dem_age < 15) THEN 1 ELSE 0 END AS A19,
            -- Anomali A20
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbli_value IS NOT NULL AND ((mjj_kbji_value >= 111 AND mjj_kbji_value <= 315) AND (mjj_kbli_value < 84221 OR mjj_kbli_value > 84233))) THEN 1 ELSE 0 END AS A20,
            -- Anomali A21
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IS NOT NULL AND (mjj_kbji_value IN (1311, 1312, 3142, 3143) OR (mjj_kbji_value >= 6111 AND mjj_kbji_value <= 6340) OR (mjj_kbji_value >= 9211 AND mjj_kbji_value <= 9216)) AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value < 1111 OR mjj_kbli_value > 3279)) THEN 1 ELSE 0 END AS A21,
            -- Anomali A22
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbli_value IS NOT NULL AND mjj_kbji_value = 2320 AND (mjj_kbli_value < 85230 OR (mjj_kbli_value > 85230 AND mjj_kbli_value < 85240) OR (mjj_kbli_value > 85240 AND mjj_kbli_value < 85311) OR (mjj_kbli_value > 85312 AND mjj_kbli_value < 85321) OR mjj_kbli_value > 85322)) THEN 1 ELSE 0 END AS A22,
            -- Anomali A23
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value IS NOT NULL AND mjj_kbji_value = 2330 AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value < 85112 OR (mjj_kbli_value > 85112 AND mjj_kbli_value < 85122) OR (mjj_kbli_value > 85122 AND mjj_kbli_value < 85210) OR (mjj_kbli_value > 85210 AND mjj_kbli_value < 85220) OR (mjj_kbli_value > 85220 AND mjj_kbli_value < 85230) OR (mjj_kbli_value > 85230 AND mjj_kbli_value < 85240) OR (mjj_kbli_value > 85240 AND mjj_kbli_value < 85251) OR (mjj_kbli_value > 85251 AND mjj_kbli_value < 85252) OR (mjj_kbli_value > 85252 AND mjj_kbli_value < 85270) OR mjj_kbli_value > 85270)) THEN 1 ELSE 0 END AS A23,
            -- Anomali A24
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value >= 84111 AND mjj_kbli_value <= 84300) AND mjj_emprel_value IS NOT NULL AND mjj_emprel_value IN (2, 3)) THEN 1 ELSE 0 END AS A24,
            -- Anomali A25
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbji_value = 2612 AND mjj_kbli_value IS NOT NULL AND mjj_kbli_value <> 84233) THEN 1 ELSE 0 END AS A25,
            -- Anomali A26
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value >= 84111 AND mjj_kbli_value <= 84300) AND mjj_emprel_value IS NOT NULL AND mjj_emprel_value = 1 AND mig_ctz_value IS NOT NULL AND mig_ctz_value = 2) THEN 1 ELSE 0 END AS A26,
            -- Anomali A27
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value >= 84111 AND mjj_kbli_value <= 84300) AND mjj_rem_ta_value = 2) THEN 1 ELSE 0 END AS A27,
            -- Anomali A28
            CASE WHEN (base.is_active = 1 AND dem_age >= 5 AND mjj_kbli_value IS NOT NULL AND (mjj_kbli_value >= 84111 AND mjj_kbli_value <= 84300) AND mjj_emprel_value IS NOT NULL AND mjj_p_uph_value IS NOT NULL AND mjj_p_uph_value <> 1) THEN 1 ELSE 0 END AS A28,
            
            -- Penambahan kolom Catatan dan Link
            root.catatan AS CATATAN,
            CONCAT('<a href="https://fasih-sm.bps.go.id/survey-collection/assignment-detail/', art.assignment_id , '/b2b58665-73d7-44ff-86b2-c05d64cf36f1" target="_blank">Link Assignment</a>') AS Link
        FROM
            trf_7c5f684c.art_roster AS art
        LEFT JOIN
            trf_7c5f684c.root_table root ON root.assignment_id = art.assignment_id
        LEFT JOIN
            trf_7c5f684c.base_table_assignment base ON base.id = art.assignment_id
    ) AS subquery
) AS subquery2