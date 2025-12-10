# 🚀 Quick Start Guide

## Cara Menjalankan Aplikasi

### 1. **Jalankan App**
```powershell
cd d:\Semester 3\DPBB\Tubes\flutter_application_1
flutter clean
flutter pub get
flutter run
```

### 2. **Login sebagai Admin**
- Pilih tab **"Admin"**
- Email: `admin@gmail.com`
- Password: `admin123`
- Klik **"Login Admin"**

### 3. **Kelola Produk**
- Klik **"Kelola Produk"**
- Isi form:
  - Nama Produk
  - Harga (angka)
  - Stok (angka)
  - Path Gambar (default: `assets/images/flower1.png`)
- Klik **"Tambah Produk"**

### 4. **Logout & Login sebagai Pembeli**
- Klik icon **Logout** (atas kanan)
- Pilih tab **"Pembeli"**
- Email: `user@email.com` (apapun)
- Password: minimal 6 karakter
- Klik **"Login Pembeli"**

### 5. **Lihat Produk di Katalog**
- Produk yang ditambahkan admin otomatis muncul!
- Bisa dilihat di GridView katalog
- Klik produk untuk melihat detail
- Tambah ke keranjang dan checkout

---

## 📁 File-File Penting

### Services (Core Logic):
- ✅ `lib/services/auth_service.dart` - **NEW** Autentikasi
- ✅ `lib/services/product_service.dart` - Data produk (EXISTING)
- ✅ `lib/services/keranjang_service.dart` - Data keranjang (EXISTING)

### Pages (UI):
- ✅ `lib/pages/login_page.dart` - **NEW** Login screen
- ✅ `lib/pages/admin_dashboard.dart` - **NEW** Admin panel
- ✅ `lib/pages/katalog_page.dart` - **UPDATED** Customer catalog
- ✅ `lib/pages/keranjang_page.dart` - **UPDATED** Cart page

### Entry Point:
- ✅ `lib/main.dart` - **UPDATED** Unified entry point

### Widgets:
- ✅ `lib/widgets/navbar.dart` - **UPDATED** Navigation bar

---

## 🔑 Key Codes

### Singleton Pattern (ProductService & AuthService):
```dart
// Satu instance untuk seluruh aplikasi
factory ProductService() => _instance;
```

### Real-time Sync:
```dart
// Admin menambah produk
await productService.addProduct(...);

// Customer langsung lihat di katalog
final products = productService.products;
```

### Login Check:
```dart
// AuthWrapper otomatis route ke halaman yang tepat
final authService = AuthService();
if (!authService.isLoggedIn()) {
  return LoginPage();
}
```

---

## 🧪 Testing Scenarios

### Scenario 1: Admin Tambah Produk
```
1. Login Admin
2. Kelola Produk → Tambah Produk
3. Logout
4. Login Pembeli
5. ✅ Produk baru terlihat di katalog
```

### Scenario 2: Admin Edit Produk
```
1. Login Admin
2. Kelola Produk → Klik Edit
3. Ubah data
4. Simpan
5. ✅ Perubahan langsung terlihat
```

### Scenario 3: Admin Hapus Produk
```
1. Login Admin
2. Kelola Produk → Klik Hapus
3. Confirm
4. ✅ Produk hilang dari katalog pembeli
```

---

## 🎓 Konsep yang Digunakan

| Konsep | File | Deskripsi |
|--------|------|-----------|
| **Singleton** | `*_service.dart` | Satu instance untuk sinkronisasi data |
| **Collections** | `_products: List` | Menyimpan data produk |
| **Classes** | `ProductService` | Encapsulation logic |
| **Try-Catch** | Services | Error handling |
| **StatefulWidget** | Pages | UI yang bisa di-update |
| **Widgets** | Material Widgets | UI components |
| **Layout** | Column, Row, etc | Arrange widgets |
| **Navigation** | Named routes | Pindah halaman |

---

## 📝 Catatan

✅ **Fitur Berhasil Diimplementasi:**
- Unified authentication system
- Admin dashboard untuk manage produk
- Real-time product sync
- Persistent data storage
- Customer catalog dengan produk terbaru

⚙️ **Teknologi:**
- Flutter Material Design
- Singleton Pattern
- SharedPreferences untuk persistence
- Collections (List) untuk data
- StatefulWidget untuk state management

🔒 **Keamanan:**
- Password admin tersimpan (hanya demo)
- SharedPreferences untuk session persistence
- Role-based access control

---

## ❓ FAQ

**Q: Apakah perubahan produk admin langsung terlihat di pembeli?**
A: Ya! ProductService menggunakan Singleton dan SharedPreferences, jadi sinkronisasi real-time.

**Q: Apakah data tersimpan setelah app ditutup?**
A: Ya! SharedPreferences menjamin data persisten.

**Q: Bisakah ganti password admin?**
A: Bisa, edit di `auth_service.dart` fungsi `loginAdmin()`.

**Q: Bagaimana jika lupa password pembeli?**
A: Bisa login ulang dengan email & password apapun (minimal 6 karakter).

---

## 📞 Troubleshooting

**Error: "Target of URI doesn't exist"**
```
→ Jalankan: flutter clean && flutter pub get
```

**App tidak rebuild saat produk ditambah**
```
→ Pastikan menggunakan setState() di admin page
→ KatalogPage otomatis update saat rebuild
```

**Produk tidak tersimpan setelah ditutup app**
```
→ Check: SharedPreferences sudah di-initialize?
→ Pastikan call: await ProductService().initialize()
```

---

**Enjoy coding! 🎉**
