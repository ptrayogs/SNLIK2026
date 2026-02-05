import streamlit as st
import pandas as pd
import io
import os
import datetime

# --- PENGATURAN PATH FILE SQL ---
# Pastikan file SQL gabungan yang saya buatkan sebelumnya disimpan di path ini
SQL_FILE_PATH = "queries/anomali_pusat.sql" 
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

def generate_sql_queries(total_art, chunk_size=1000):
    """Fungsi untuk memecah query menjadi beberapa bagian berdasarkan baris."""
    base_sql_template = load_sql_template(SQL_FILE_PATH)
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
        df_combined = pd.concat(list_df, ignore_index