/* Anomali SNLIK Prov Lampung (Non-Approve Version)
   Query ini menggabungkan logika pengecekan Prov 1-4 tanpa filter status dokumen.
*/

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
            
            -- STATUS DOKUMEN (Penting untuk versi Non-Approve)
            base.assignment_status_alias AS STATUS_DOKUMEN,

            -- ANOMALI PROVINSI (1-4)
            -- Prov 01: (R504a=1 ATAU R504b=1) DAN R1503=5
            CASE WHEN (
                (root.r504a_value = 1 OR root.r504b_value = 1) 
                AND root.r1503_value = 5
            ) THEN 1 ELSE 0 END AS PROV_01,

            -- Prov 02: (R504a=1 ATAU R504b=1) DAN R1504=5
            CASE WHEN (
                (root.r504a_value = 1 OR root.r504b_value = 1) 
                AND root.r1504_value = 5
            ) THEN 1 ELSE 0 END AS PROV_02,

            -- Prov 03: (R504a=1 ATAU R504b=1) DAN R1504=5
            CASE WHEN (
                (root.r504a_value = 1 OR root.r504b_value = 1) 
                AND root.r1504_value = 5
            ) THEN 1 ELSE 0 END AS PROV_03,

            -- Prov 04: (R504a=5 ATAU R504b=5) DAN R703=1
            CASE WHEN (
                (root.r504a_value = 5 OR root.r504b_value = 5) 
                AND root.r703_value = 1
            ) THEN 1 ELSE 0 END AS PROV_04,

            -- EXTRA
            root2.catatan AS CATATAN,
            CONCAT('<a href="https://fasih-sm.bps.go.id/survey-collection/assignment-detail/', root.assignment_id, '/4a8b0310-7424-419d-980a-72efe84408a1" target="_blank">Link Assignment</a>') AS Link

        FROM tyo_93d2145f.root_table root
        
        -- Join ke ART
        LEFT JOIN tyo_93d2145f.nested_art art 
            ON root.assignment_id = art.assignment_id AND art.r401 = root.no_urut_terpilih
        
        -- Join Informasi Petugas
        LEFT JOIN tyo_93d2145f.petugas usr
            ON root.assignment_id = usr.assignment_id

        -- Join Status Assignment
        LEFT JOIN tyo_93d2145f.base_table_assignment base ON base.id = root.assignment_id

        -- FILTER DATA (Hanya Aktif & Bersedia, TANPA filter Status)
        WHERE base.is_active = 1 
          AND root.bersedia_value != 3 

    ) AS subquery
) AS subquery2