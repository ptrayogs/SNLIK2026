import streamlit as st
import pandas as pd
import io
import os
import datetime

# --- PENGATURAN PATH FILE SQL ---
# Pastikan kedua file ini ada di folder queries/
SQL_APPROVED_PATH = "queries/anomali_pusat.sql" 
SQL_NON_APPROVED_PATH = "queries/anomali_pusat_non_approved.sql"
SQL_PROVINSI_APP = "queries/anomali_provinsi_approved.sql"
SQL_PROVINSI_NON_APP = "queries/anomali_provinsi_non_approved.sql"
DESKRIPSI_PATH = "Deskripsi.xlsx"

# --------------------------------------------------------------------------
# --- FUNGSI-FUNGSI LOGIKA ---
# --------------------------------------------------------------------------

def load_sql_template(filepath):
    """Membaca isi file SQL dan mengembalikan string query yang sudah bersih."""
    if not os.path.exists(filepath):
        st.error(f"❌ File SQL tidak ditemukan: {filepath}")
        return None
    try:
        with open(filepath, 'r') as f:
            return f.read().strip() 
    except Exception as e:
        st.error(f"❌ Gagal membaca file SQL {filepath}: {e}")
        return None

def generate_sql_queries(total_art, sql_filepath, chunk_size=1000):
    """
    Fungsi untuk memecah query menjadi beberapa bagian berdasarkan baris.
    Updated: Sekarang menerima parameter sql_filepath agar dinamis.
    """
    base_sql_template = load_sql_template(sql_filepath)
    if base_sql_template is None:
        return []
        
    generated_queries = []
    # Loop untuk membagi query per 1000 baris (atau sesuai chunk_size)
    for start_row in range(1, total_art + 1, chunk_size):
        end_row = min(start_row + chunk_size - 1, total_art)
        # Menambahkan WHERE clause di bagian paling luar query wrapper
        where_clause = f'WHERE "NO." BETWEEN {start_row} AND {end_row};'
        full_query = f"{base_sql_template}\n{where_clause}"
        generated_queries.append(full_query)
    return generated_queries

def proses_rekap_anomali(list_uploaded_csv, deskripsi_filepath):
    """
    Fungsi untuk menggabungkan CSV, mencocokkan dengan deskripsi anomali,
    dan membuat file Excel rekapitulasi.
    """
    try:
        # 1. Gabungkan semua file CSV yang diunggah
        list_df = [pd.read_csv(file, encoding='latin-1') for file in list_uploaded_csv]
        df_combined = pd.concat(list_df, ignore_index=True)

        # 2. Membaca file deskripsi anomali
        df_deskripsi = pd.read_excel(deskripsi_filepath)
        # Standarisasi nama kolom kode anomali
        kode_col_name = 'Anomali' if 'Anomali' in df_deskripsi.columns else 'No. Anomali'
        df_deskripsi = df_deskripsi[[kode_col_name, 'Deskripsi']].rename(columns={kode_col_name: 'KODE_ANOMALI'})
        
        # 3. Identifikasi kolom anomali secara dinamis
        list_anomali_codes = df_deskripsi['KODE_ANOMALI'].unique().tolist()
        
        # Cari kolom di CSV yang namanya ada di daftar kode anomali (misal: A1, A2, A57)
        anomali_cols = [col for col in df_combined.columns if col in list_anomali_codes]

        if not anomali_cols:
            raise ValueError("Tidak ditemukan kolom anomali pada CSV yang cocok dengan file Deskripsi. Pastikan header CSV sesuai (misal: A1, A2, dst).")

        # 4. Membuat Sheet "Rekap Anomali"
        # Mengubah data ke format panjang untuk dihitung
        rekap_long = df_combined.melt(value_vars=anomali_cols, var_name='KODE_ANOMALI', value_name='JUMLAH')
        # Hanya ambil yang bernilai 1 (Terkena Anomali)
        rekap_long_filtered = rekap_long[rekap_long['JUMLAH'] == 1]
        
        # Hitung jumlah kejadian per kode anomali
        df_rekap = rekap_long_filtered.groupby('KODE_ANOMALI').agg(JUMLAH=('JUMLAH', 'count')).reset_index()
        # Gabungkan dengan deskripsi agar informatif
        df_rekap_final = pd.merge(df_rekap, df_deskripsi, on='KODE_ANOMALI', how='left')

        # 5. Membuat format panjang untuk rincian
        # Ambil kolom identitas (selain kolom anomali)
        id_vars = [col for col in df_combined.columns if col not in anomali_cols]
        
        df_long_all = df_combined.melt(
            id_vars=id_vars,
            value_vars=anomali_cols,
            var_name='KODE_ANOMALI',
            value_name='FLAG_ANOMALI'
        )
        
        df_long_all_desc = pd.merge(df_long_all, df_deskripsi, on='KODE_ANOMALI', how='left')

        # 6. Membuat Sheet Rincian
        df_rincian_anomali = df_long_all_desc[df_long_all_desc['FLAG_ANOMALI'] == 1].copy()
        
        # 7. Menulis ke buffer Excel
        output_buffer = io.BytesIO()
        with pd.ExcelWriter(output_buffer, engine='openpyxl') as writer:
            df_rekap_final.to_excel(writer, sheet_name='Rekap Anomali', index=False)
            df_rincian_anomali.to_excel(writer, sheet_name='Rincian ART Anomali', index=False)
            # Opsional: Jika ingin sheet mentah per ART (bisa besar ukurannya)
            # df_long_all_desc.to_excel(writer, sheet_name='Per ART', index=False) 
        
        return output_buffer

    except Exception as e:
        st.error(f"Terjadi kesalahan saat memproses file: {e}")
        return None

# --------------------------------------------------------------------------
# --- ANTARMUKA APLIKASI STREAMLIT ---
# --------------------------------------------------------------------------

st.set_page_config(page_title="Anomali SNLIK 2026", layout="centered")

st.title("🛡️ Anomali SNLIK 2026")
st.info("Created by Tim IPDS 1809 - YCP")
st.divider()

# --- BAGIAN CEK DESKRIPSI ---
with st.expander("📖 Klik untuk Melihat Daftar Anomali (Referensi)"):
    if os.path.exists(DESKRIPSI_PATH):
        try:
            df_desc = pd.read_excel(DESKRIPSI_PATH)
            st.dataframe(df_desc)
        except Exception as e:
            st.error(f"Gagal membaca file deskripsi: {e}")
    else:
        st.warning(f"File '{DESKRIPSI_PATH}' tidak ditemukan. Fitur rekap mungkin tidak berjalan sempurna.")
st.divider()

# --- LANGKAH 1: INPUT TOTAL ART ---
st.subheader("Langkah 1: Hitung Total ART")
st.markdown("Jalankan query ini di SQL Lab untuk mendapatkan jumlah total baris data (ART).")
query_total_art = """
SELECT COUNT(*) AS "Jumlah ART"
FROM tyo_93d2145f.nested_art;
"""
st.code(query_total_art, language='sql')

total_art_input = st.number_input(
    label="**Masukkan hasil 'Jumlah ART' di sini:**",
    min_value=1, step=100, key="total_art_input",
    help="Contoh: Jika hasilnya 2290, masukkan 2290."
)
st.divider()

# --- LANGKAH 2: GENERATE QUERY ---
st.subheader("Langkah 2: Generate Query")
st.markdown("Pilih jenis query yang ingin dihasilkan. Sistem akan memecah query menjadi beberapa bagian.")

col_approved, col_non_approved, col_prov_approved, col_prov_non_approved = st.columns(4)

# Tombol 1: Approved Only
with col_approved:
    if st.button('✅ Generate SQL (Approved)', use_container_width=True, type="primary"):
        if total_art_input:
            queries = generate_sql_queries(int(total_art_input), SQL_APPROVED_PATH)
            if queries:
                st.success(f"Berhasil: {len(queries)} Query (Approved)")
                st.info("Status: APPROVED BY Pengawas / COMPLETED BY Pengawas")
                with st.container(height=300):
                    for i, query in enumerate(queries, 1):
                        with st.expander(f"📄 Query Approved Bagian {i}"):
                            st.code(query, language='sql')
            else:
                st.error(f"Gagal. Cek file: {SQL_APPROVED_PATH}")
        else:
            st.warning("Masukkan jumlah ART dulu.")

# Tombol 2: Non-Approved / All Status
with col_non_approved:
    if st.button('⚠️ Generate SQL (Non-Approved)', use_container_width=True):
        if total_art_input:
            queries = generate_sql_queries(int(total_art_input), SQL_NON_APPROVED_PATH)
            if queries:
                st.success(f"Berhasil: {len(queries)} Query (Non-Approved)")
                st.info("Status: SEMUA (Active) termasuk Submitted/Rejected")
                with st.container(height=300):
                    for i, query in enumerate(queries, 1):
                        with st.expander(f"📄 Query Non-Approve Bagian {i}"):
                            st.code(query, language='sql')
            else:
                st.error(f"Gagal. Cek file: {SQL_NON_APPROVED_PATH}")
        else:
            st.warning("Masukkan jumlah ART dulu.")

# Tombol 3: Provinsi Approved Only
with col_prov_approved:
    if st.button('✅ Generate SQL Provinsi (Approved)', use_container_width=True, type="primary"):
        if total_art_input:
            queries = generate_sql_queries(int(total_art_input), SQL_PROVINSI_APP)
            if queries:
                st.success(f"Berhasil: {len(queries)} Query (Approved)")
                st.info("Status: APPROVED BY Pengawas / COMPLETED BY Pengawas")
                with st.container(height=300):
                    for i, query in enumerate(queries, 1):
                        with st.expander(f"📄 Query Approved Bagian {i}"):
                            st.code(query, language='sql')
            else:
                st.error(f"Gagal. Cek file: {SQL_PROVINSI_APP}")
        else:
            st.warning("Masukkan jumlah ART dulu.")

# Tombol 4: Provinsi Non-Approved / All Status
with col_prov_non_approved:
    if st.button('⚠️ Generate SQL Provinsi (Non-Approved)', use_container_width=True):
        if total_art_input:
            queries = generate_sql_queries(int(total_art_input), SQL_PROVINSI_NON_APP)
            if queries:
                st.success(f"Berhasil: {len(queries)} Query (Non-Approved)")
                st.info("Status: SEMUA (Active) termasuk Submitted/Rejected")
                with st.container(height=300):
                    for i, query in enumerate(queries, 1):
                        with st.expander(f"📄 Query Non-Approve Bagian {i}"):
                            st.code(query, language='sql')
            else:
                st.error(f"Gagal. Cek file: {SQL_PROVINSI_NON_APP}")
        else:
            st.warning("Masukkan jumlah ART dulu.")

st.divider()

# --- LANGKAH 3: PROSES CSV ---
st.subheader("Langkah 3: Rekapitulasi Hasil")
st.markdown("Unggah **semua** file CSV hasil download dari SQL Lab.")

uploaded_csvs = st.file_uploader(
    "Upload file CSV di sini (bisa banyak sekaligus)",
    type="csv",
    accept_multiple_files=True,
    key="uploader_csv"
)

if st.button("⚙️ Proses File & Buat Excel", use_container_width=True, key="btn_proses"):
    if not os.path.exists(DESKRIPSI_PATH):
        st.error(f"❌ File '{DESKRIPSI_PATH}' hilang! Harap upload ke folder aplikasi.")
    elif uploaded_csvs:
        with st.spinner("⏳ Sedang menggabungkan data dan mendeteksi anomali..."):
            excel_buffer = proses_rekap_anomali(uploaded_csvs, DESKRIPSI_PATH)
            
            if excel_buffer:
                st.session_state['excel_file'] = excel_buffer
                st.session_state['proses_selesai'] = True
                st.balloons()
    else:
        st.warning("⚠️ Mohon unggah setidaknya satu file CSV.")

# --- BAGIAN DOWNLOAD ---
if 'proses_selesai' in st.session_state and st.session_state['proses_selesai']:
    if st.session_state['excel_file'] is not None:
        st.success("✅ File rekap berhasil dibuat!")

        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        dynamic_filename = f"Hasil_Rekap_Anomali_Gabungan_{timestamp}.xlsx"

        st.download_button(
            label=f"📥 Download {dynamic_filename}",
            data=st.session_state['excel_file'],
            file_name=dynamic_filename,
            mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            use_container_width=True
        )