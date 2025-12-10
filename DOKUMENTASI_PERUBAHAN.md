# Dokumentasi Sistem Auth & Product Management Flowries

## 📋 Ringkasan Perubahan

Aplikasi Flowries sekarang memiliki sistem autentikasi terpadu (unified) yang menghubungkan main.dart dan main_admin.dart dengan satu entry point. Produk yang ditambahkan atau diubah admin akan langsung terlihat di katalog pembeli.

## 🔐 Sistem Autentikasi (Auth Service)

File: `lib/services/auth_service.dart`

### Fitur Utama:
- **Singleton Pattern**: Satu instance yang digunakan di seluruh aplikasi
- **Persistent Login**: Data login disimpan di SharedPreferences
- **Dua Role**: Admin dan Customer

### Metode Penting:
```dart
// Login untuk Admin
Future<bool> loginAdmin(String email, String password)
// Email: admin@gmail.com, Password: admin123

// Login untuk Customer (Pembeli)
Future<bool> loginCustomer(String email, String password)
// Email: apapun, Password: minimal 6 karakter

// Logout
Future<void> logout()

// Cek status
bool isLoggedIn()
bool isAdmin()
bool isCustomer()
```

## 📦 Product Service (Shared)

File: `lib/services/product_service.dart`

### Fitur:
- **Singleton Pattern**: Satu data produk untuk admin dan customer
- **Persistent Storage**: Semua perubahan disimpan otomatis
- **Real-time Update**: Perubahan langsung terlihat di semua halaman

### Fungsi:
```dart
addProduct()      // Tambah produk baru
updateProduct()   // Edit produk
deleteProduct()   // Hapus produk
getProductById()  // Cari produk berdasarkan ID
```

## 🔄 Alur Navigasi

```
1. App Launch (main.dart)
   ↓
2. Initialize Services (Auth & Product)
   ↓
3. AuthWrapper Check
   ├─ Not Logged In → LoginPage
   ├─ Is Admin → AdminDashboard
   └─ Is Customer → KatalogPage
```

## 📄 File-File Baru

### 1. **lib/services/auth_service.dart**
Mengelola autentikasi dan role user. Menggunakan SharedPreferences untuk menyimpan session.

### 2. **lib/pages/login_page.dart**
Halaman login bersama dengan tab switch untuk memilih role (Admin/Pembeli).

### 3. **lib/pages/admin_dashboard.dart**
Dashboard admin yang menggabungkan:
- `AdminDashboard`: Halaman utama admin
- `AdminManageProductsPage`: Form tambah/edit/hapus produk
- `AdminProductListPage`: Daftar grid produk

## ✨ Perubahan di File Existing

### **main.dart**
- Sekarang entry point utama (bukan main_admin.dart)
- Menambah initialization untuk services
- Menggunakan AuthWrapper untuk conditional routing

### **katalog_page.dart**
- Berubah dari StatelessWidget → StatefulWidget
- Setiap refresh, data produk selalu fresh
- Mendukung logout button di navbar

### **navbar.dart**
- Menambah import AuthService
- Tambah logout button
- Fix routing ke '/customer-home'

### **keranjang_page.dart**
- Hapus unused import

## 🔗 Bagaimana Perubahan Produk Sync?

1. **Admin menambah/edit/hapus produk**
   - Disimpan ke ProductService
   - ProductService menyimpan ke SharedPreferences
   
2. **Customer melihat katalog**
   - KatalogPage membaca dari ProductService
   - Saat page rebuild (setState), data selalu fresh
   - Semua perubahan langsung terlihat

## 🎯 Use Case: Admin Menambah Produk

```
1. Admin login → AdminDashboard
2. Klik "Kelola Produk" → AdminManageProductsPage
3. Isi form (nama, harga, stok, gambar)
4. Klik "Tambah Produk"
   ├─ ProductService.addProduct() dipanggil
   ├─ Data disimpan ke SharedPreferences
   └─ setState() trigger rebuild
5. Customer di halaman katalog otomatis melihat produk baru
```

## 🎯 Use Case: Customer Berbelanja

```
1. Customer login → KatalogPage (Katalog Produk)
2. Lihat semua produk dari ProductService
3. Tambah ke keranjang
4. Checkout
5. Logout atau lanjut belanja
```

## 🔄 Login Credentials

### Admin:
- Email: `admin@gmail.com`
- Password: `admin123`

### Customer:
- Email: apapun (misal: `user@email.com`)
- Password: minimal 6 karakter

## 📱 Teknologi yang Digunakan (Sesuai Requirement)

✅ **Collections** - Menggunakan List untuk produk dan keranjang
✅ **Kelas (Class)** - ProductService, AuthService, Widget classes
✅ **Try-Catch** - Error handling di services
✅ **Widgets** - MaterialApp, Scaffold, GridView, ListView, etc
✅ **Layout** - Column, Row, Expanded, Container, Card
✅ **Navigasi** - Named routes, Navigator.push, pushReplacement

## 🚀 Testing App

```powershell
# Build dan jalankan
flutter clean
flutter pub get
flutter run

# Test flow:
1. Klik "Admin" tab
2. Login: admin@gmail.com / admin123
3. Klik "Kelola Produk"
4. Tambah produk baru (e.g., "Mawar Merah")
5. Logout
6. Login sebagai pembeli dengan role "Pembeli"
7. Lihat produk baru muncul di katalog
```

## 📝 Catatan Penting

- ProductService menggunakan Singleton, jadi semua perubahan langsung tersinkronisasi
- SharedPreferences menjamin data persisten walaupun app ditutup
- AuthWrapper memastikan user selalu di route yang tepat sesuai role
- Tidak perlu restart app, perubahan langsung terlihat (real-time)
