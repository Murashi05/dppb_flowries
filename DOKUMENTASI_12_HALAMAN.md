# Dokumentasi Sistem 12 Halaman Flowries Bouquet

## Daftar 12 Halaman Aplikasi

### **HALAMAN PEMBELI (7 Halaman)**

#### 1. **Halaman Login** ✅
- **File:** `lib/pages/login_page.dart`
- **Deskripsi:** Halaman awal untuk login yang bisa membedakan user sebagai admin atau pembeli
- **Fitur:**
  - Input email dan password
  - Toggle password visibility
  - Validasi login berdasarkan email dan password
  - Demo data untuk testing
  - Navigasi otomatis ke dashboard sesuai tipe user

**Demo Akun:**
```
PEMBELI:
Email: pembeli@flowries.com
Password: password123

ADMIN:
Email: admin@flowries.com
Password: admin123
```

---

#### 2. **Halaman Home Pembeli** ✅
- **File:** `lib/pages/home_pembeli.dart`
- **Deskripsi:** Dashboard utama pembeli dengan voucher dan menu cepat
- **Fitur:**
  - Welcome greeting untuk user
  - Carousel voucher aktif dengan detail diskon
  - Menu cepat (Katalog, Keranjang, Riwayat, Profil, Ulasan, Logout)
  - Notifikasi icon di AppBar

---

#### 3. **Halaman Katalog Produk** ✅
- **File:** `lib/pages/katalog_produk.dart`
- **Deskripsi:** Daftar semua produk dengan fitur pencarian dan sorting
- **Fitur:**
  - Search produk berdasarkan nama/deskripsi
  - Sort: Terbaru, Termurah, Termahal, Rating Tertinggi
  - Grid view produk dengan gambar, nama, harga, rating, stok
  - Click untuk ke halaman detail produk
  - 6 produk dummy (Mawar, Tulip, Matahari, Sakura, Lily, Mixed Bouquet)

---

#### 4. **Halaman Detail Produk** ✅
- **File:** `lib/pages/detail_produk_page.dart`
- **Deskripsi:** Detail lengkap produk dengan review dan opsi pembelian
- **Fitur:**
  - Gambar produk besar
  - Nama, harga, rating, dan stok
  - Deskripsi lengkap
  - Quantity selector dengan tombol +/-
  - List review dari pembeli lain
  - Tombol "Tambah Keranjang" dan "Beli Langsung"

---

#### 5. **Halaman Keranjang** ✅
- **File:** `lib/pages/keranjang_page_new.dart`
- **Deskripsi:** Menampilkan item dalam keranjang dengan quantity control
- **Fitur:**
  - List item keranjang dengan gambar, nama, harga
  - Quantity control +/- dan tombol delete
  - Subtotal per item
  - Total harga keranjang
  - Tombol "Lanjut Belanja" dan "Checkout"
  - Pesan ketika keranjang kosong

---

#### 6. **Halaman Pembayaran** ✅
- **File:** `lib/pages/pembayaran_page_new.dart`
- **Deskripsi:** Proses checkout dengan voucher, alamat, dan metode pembayaran
- **Fitur:**
  - Ringkasan pesanan dengan detail item dan harga
  - Pilihan voucher dengan preview diskon
  - Input alamat pengiriman
  - Pilihan metode pembayaran (Transfer, E-Wallet, Cicilan, COD)
  - Konfirmasi pembayaran sebelum transaksi
  - Notifikasi berhasil dan navigasi ke riwayat

---

#### 7. **Halaman Riwayat Transaksi** ✅
- **File:** `lib/pages/riwayat_transaksi.dart`
- **Deskripsi:** List transaksi pembeli dengan status dan opsi ulasan
- **Fitur:**
  - Filter status: Semua, Menunggu, Diproses, Selesai, Dibatalkan
  - Tampilan transaksi dengan ID, item, total, status
  - Tombol "Tambah Ulasan" untuk transaksi selesai
  - Color-coded status (hijau=selesai, orange=diproses, blue=menunggu, merah=dibatalkan)

---

#### 8. **Halaman Tambah Ulasan** ✅
- **File:** `lib/pages/tambah_ulasan_page.dart`
- **Deskripsi:** Form untuk menambah ulasan produk dari transaksi selesai
- **Fitur:**
  - Progress bar untuk multiple items
  - Display product info yang direview
  - Rating star selector (1-5)
  - Input komentar multi-line
  - Navigation previous/next untuk item berikutnya
  - Simpan semua ulasan sekaligus

---

#### 9. **Halaman Daftar Ulasan Pribadi** ✅
- **File:** `lib/pages/daftar_ulasan.dart`
- **Deskripsi:** Daftar ulasan yang telah dibuat user
- **Fitur:**
  - List ulasan dengan produk info dan rating
  - Tombol Edit dan Hapus per ulasan
  - Konfirmasi sebelum hapus
  - Pesan jika belum ada ulasan

---

#### 10. **Halaman Profil Pembeli** ✅
- **File:** `lib/pages/profil_pembeli.dart`
- **Deskripsi:** Menampilkan data profil user pembeli
- **Fitur:**
  - Avatar dengan inisial nama
  - Display semua data user (nama, email, telepon, alamat, tipe)
  - Tombol Edit Profil (placeholder)
  - Tombol Logout dengan konfirmasi

---

### **HALAMAN ADMIN (5 Halaman)**

#### 11. **Halaman Admin Dashboard** ✅
- **File:** `lib/pages/admin_dashboard_page.dart`
- **Deskripsi:** Dashboard utama admin dengan statistik dan menu
- **Fitur:**
  - Welcome greeting untuk admin
  - 4 statistik cards (Produk, Transaksi, Total Penjualan, Total Pembeli)
  - 4 menu administrasi dengan icon dan deskripsi:
    - Kelola Produk
    - Kelola Voucher
    - Kelola Transaksi
    - Lihat Ulasan
  - Logout button di AppBar

---

#### 12. **Halaman Kelola Produk** ✅
- **File:** `lib/pages/kelola_produk.dart`
- **Deskripsi:** CRUD produk - admin bisa add, edit, delete produk
- **Fitur:**
  - List produk dengan info nama, harga, stok
  - Tombol Edit dan Delete per produk
  - FAB untuk tambah produk baru
  - Dialog form untuk Add/Edit produk
  - Input: Nama, Deskripsi, Harga, Stok

---

#### 13. **Halaman Kelola Voucher** ✅
- **File:** `lib/pages/kelola_voucher.dart`
- **Deskripsi:** CRUD voucher - admin bisa add, edit, delete voucher
- **Fitur:**
  - List voucher dengan gradient background
  - Display: Kode, Deskripsi, Tipe Diskon, Nilai, Min Belanja, Kuota
  - Status aktif/nonaktif
  - Tombol Edit dan Delete
  - FAB untuk tambah voucher baru
  - Dialog form dengan opsi tipe diskon

---

#### 14. **Halaman Kelola Transaksi** ✅
- **File:** `lib/pages/kelola_transaksi.dart`
- **Deskripsi:** Admin melihat dan update status transaksi pembeli
- **Fitur:**
  - Filter status transaksi
  - List transaksi dengan ID, item, total, metode pembayaran
  - Dropdown untuk update status (menunggu → diproses → selesai)
  - Color-coded status badges
  - Real-time update tanggal selesai

---

#### 15. **Halaman Lihat Ulasan** ✅
- **File:** `lib/pages/lihat_ulasan.dart`
- **Deskripsi:** Admin melihat semua ulasan produk dari pembeli
- **Fitur:**
  - List ulasan dengan nama pembeli, produk, rating, komentar
  - Sort: Terbaru, Rating Tertinggi, Rating Terendah
  - Filter rating: Semua, 5★, 4★, 3★, 2★, 1★
  - Tombol Lihat dan Hapus ulasan
  - Color-coded rating badges

---

## **RINGKASAN DATA FLOW**

### **Pembeli:**
1. Login → Home Pembeli → Katalog → Detail Produk → Keranjang → Pembayaran → Riwayat → Tambah Ulasan → Daftar Ulasan
2. Akses Profil dari Home dengan dropdown menu

### **Admin:**
1. Login → Dashboard → Kelola Produk/Voucher/Transaksi/Ulasan
2. Kelola Produk bisa dilihat juga di katalog pembeli (sync data)

---

## **MODEL DATA**

### User Model
```dart
- id: String
- email: String
- password: String
- nama: String
- noTelepon: String
- alamat: String
- tipeUser: 'admin' | 'pembeli'
- createdAt: DateTime
```

### Product Model
```dart
- id: String
- nama: String
- deskripsi: String
- harga: double
- gambar: String (emoji)
- stok: int
- rating: double
- jumlahUlasan: int
- createdAt: DateTime
- createdBy: String
```

### CartItem Model
```dart
- id: String
- productId: String
- productNama: String
- productHarga: double
- productGambar: String
- quantity: int
```

### Voucher Model
```dart
- id: String
- kode: String
- deskripsi: String
- diskon: double
- tipeDiskon: 'persen' | 'nominal'
- minimalPembelian: double
- kuota: int
- kuotaTerpakai: int
- berlakuMulai: DateTime
- berlakuAkhir: DateTime
- aktif: bool
```

### Transaction Model
```dart
- id: String
- userId: String
- items: List<CartItem>
- totalSebelomDiskon: double
- diskonNominal: double
- totalSetelahDiskon: double
- voucherId: String
- voucherKode: String?
- status: 'menunggu' | 'diproses' | 'selesai' | 'dibatalkan'
- tanggalPemesanan: DateTime
- tanggalSelesai: DateTime?
- metodePembayaran: String
- alamatPengiriman: String
```

### Review Model
```dart
- id: String
- productId: String
- userId: String
- rating: int (1-5)
- komentar: String
- createdAt: DateTime
```

---

## **FITUR KHUSUS**

✅ **Login Terpadu** - 1 halaman login untuk admin dan pembeli, dibedakan di email
✅ **Voucher di Home** - Carousel voucher aktif dengan detail
✅ **Pembayaran Fleksibel** - Dari detail produk, keranjang, atau dengan voucher
✅ **Review System** - Hanya bisa ulasan jika transaksi sudah selesai
✅ **Admin Sync** - Produk yang dikelola admin langsung muncul di katalog pembeli
✅ **Status Management** - Admin bisa tracking dan update status transaksi
✅ **Multiple Items** - Beli banyak item sekaligus dan review semua

---

## **ROUTING LENGKAP**

```dart
/login → LoginPage
/home-pembeli → HomePembeli
/katalog → KatalogProduk
/detail-produk → DetailProdukPage
/keranjang → KeranjangPage
/pembayaran → PembayaranPage
/riwayat → RiwayatTransaksiPage
/tambah-ulasan → TambahUlasanPage
/profil-pembeli → ProfilPembeli
/daftar-ulasan → DaftarUlasanPage
/admin-dashboard → AdminDashboardPage
/kelola-produk → KelolaProduk
/kelola-voucher → KelolaVoucher
/kelola-transaksi → KelolaTransaksi
/lihat-ulasan → LihatUlasan
```

---

## **CARA TESTING**

1. **Pembeli Mode:**
   - Login dengan email: `pembeli@flowries.com`, password: `password123`
   - Jelajahi katalog, tambah keranjang, proses pembayaran
   - Lihat riwayat dan buat ulasan untuk transaksi selesai

2. **Admin Mode:**
   - Login dengan email: `admin@flowries.com`, password: `admin123`
   - Kelola produk (add/edit/delete)
   - Kelola voucher (buat diskon)
   - Update status transaksi
   - Lihat dan manage ulasan

---

**Total: 12 Halaman Fungsional Lengkap ✅**
