# Arsitektur Aplikasi Flowries

## 📊 Struktur Aplikasi

```
┌─────────────────────────────────────────────────────────────┐
│                        main.dart                             │
│                   (Entry Point Utama)                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
        ┌────────────────────────────────┐
        │    Initialize Services         │
        │  - ProductService.initialize() │
        │  - AuthService.initialize()    │
        └────────────────┬───────────────┘
                         │
                         ↓
        ┌────────────────────────────────┐
        │      AuthWrapper Widget         │
        │   (Cek Login Status & Role)    │
        └────┬─────────────┬──────────┬──┘
             │             │          │
    ┌────────┴──┐  ┌───────┴──────┐  └────────┬─────────┐
    │            │  │              │           │         │
    ↓            ↓  ↓              ↓           ↓         ↓
Not Logged   Admin   Customer    (Others)    (Others)  (Others)
    │         │        │
    └─────────┼────────┘
              │
    ┌─────────┴─────────┐
    │                   │
    ↓                   ↓
LoginPage      AuthWrapper
               Check Role
               │
    ┌──────────┴──────────┐
    │                     │
    ↓                     ↓
AdminDashboard      KatalogPage
(Customer)          (Pembeli)
```

## 🏗️ Service Architecture

```
┌────────────────────────────────────────────────────────────┐
│                    SharedPreferences                        │
│              (Persistent Storage - Local)                  │
└──────────────────────┬─────────────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
        ↓                             ↓
┌──────────────────┐        ┌──────────────────┐
│  ProductService  │        │   AuthService    │
│  (Singleton)     │        │  (Singleton)     │
│                  │        │                  │
│ - products[]     │        │ - currentRole    │
│ - addProduct()   │        │ - loginAdmin()   │
│ - updateProduct()│        │ - loginCustomer()│
│ - deleteProduct()│        │ - logout()       │
│ - getProductById│        │ - isLoggedIn()   │
└──────────────────┘        └──────────────────┘
        △                             △
        │                             │
        └─────────┬─────────────────┬─┘
                  │                 │
        ┌─────────┴──────┐  ┌──────┴──────┐
        │                │  │             │
   Admin Pages      Customer Pages   UI Widgets
        │                │
    ┌───┴────────┐   ┌───┴────────┐
    │            │   │            │
    ↓            ↓   ↓            ↓
AdminDash  ManageProducts KatalogPage KeranjangPage
```

## 🔄 Data Flow Diagram

### Saat Admin Menambah Produk:

```
Admin Input Form
        │
        ↓
addProduct() button click
        │
        ↓
ProductService.addProduct()
        │
        ├─→ Add to _products list (in memory)
        │
        └─→ _saveToStorage() 
            ├─→ JSON encode
            └─→ SharedPreferences.setString()
                    │
                    ↓
            ✅ Produk Tersimpan
```

### Saat Customer Melihat Katalog:

```
KatalogPage rebuild
        │
        ↓
ProductService.products (getter)
        │
        ↓
Return List dari memory (_products)
        │
        ↓
GridView.builder() iterate
        │
        ├─→ Display each product
        │
        └─→ ✅ Produk baru terlihat!
```

## 🔐 Authentication Flow

```
1. User buka app
        ↓
2. main() Initialize services
        ↓
3. AuthService.initialize()
   └─→ Load dari SharedPreferences
        ↓
4. AuthWrapper check:
   ├─ isLoggedIn() → false → LoginPage
   ├─ isAdmin() → true → AdminDashboard
   └─ isCustomer() → true → KatalogPage
```

## 📱 Widget Tree Structure

```
FlowriesApp (MaterialApp)
    │
    ├─ theme: ThemeData (pink)
    ├─ home: AuthWrapper
    │
    └─ routes:
        ├─ '/customer-home': KatalogPage
        ├─ '/keranjang': KeranjangPage
        ├─ '/riwayat': RiwayatPage
        ├─ '/bayar': PembayaranPage
        ├─ '/admin-dashboard': AdminDashboard
        └─ '/detail': DetailProdukPage
```

## 🔌 Component Dependencies

```
KatalogPage
    ├─ ProductService (untuk data produk)
    ├─ KeranjangService (untuk cart)
    ├─ navbar widget (untuk header)
    └─ GridView (untuk layout)
        └─ Container → Image + Text (setiap produk)

AdminDashboard
    ├─ ProductService (untuk data produk)
    ├─ AuthService (untuk user info)
    └─ AdminManageProductsPage (navigate)
        ├─ TextField (form input)
        ├─ ListView (daftar produk)
        └─ AlertDialog (edit/hapus confirm)

LoginPage
    ├─ AuthService (untuk login)
    ├─ TextField (email & password)
    └─ Container (layout header)
```

## 📊 Data Model

```
Product (Map<String, dynamic>)
├─ id: String
├─ name: String
├─ price: int
├─ stock: int
└─ image: String (path)

AuthState
├─ currentRole: String (admin/customer)
├─ currentUserName: String
└─ isLoggedIn: bool
```

## 🔄 State Management Pattern

**Singleton Pattern untuk Services:**
```dart
class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();
  
  // Semua akses ProductService() akan return instance yang sama
}
```

**SetState untuk UI Refresh:**
```dart
// Di AdminManageProductsPage
setState(() {
  productService.addProduct(...);
});
// Ini trigger rebuild, yang kemudian baca dari ProductService lagi

// Di KatalogPage
// Setiap kali page build, baca fresh dari ProductService
final products = productService.products;
```

## 🎯 Key Features Summary

| Feature | Implemented | Technology |
|---------|-------------|-----------|
| Unified Auth | ✅ | AuthService (Singleton) |
| Product Management | ✅ | ProductService (Singleton) |
| Admin Dashboard | ✅ | StatefulWidget |
| Customer Katalog | ✅ | StatefulWidget |
| Real-time Sync | ✅ | SharedPreferences |
| Persistent Data | ✅ | SharedPreferences |
| Navigation | ✅ | Named Routes |
| Collections | ✅ | List<Map> |
| Try-Catch | ✅ | Error Handling |
