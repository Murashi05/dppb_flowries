# 🔄 Alur Lengkap Aplikasi Flowries

## 1️⃣ STARTUP FLOW

```
┌──────────────────────────────────────┐
│  main() Dipanggil                    │
├──────────────────────────────────────┤
│  WidgetsFlutterBinding.ensureInit()  │
│  ProductService().initialize()       │ ← Load produk dari storage
│  AuthService().initialize()          │ ← Load session dari storage
│  runApp(FlowriesApp())               │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  MaterialApp (FlowriesApp)           │
│  ├─ theme: pink theme                │
│  ├─ home: AuthWrapper                │
│  └─ routes: named routes             │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  AuthWrapper Check                   │
│  if (isLoggedIn) {                   │
│    if (isAdmin) → AdminDashboard()   │
│    else → KatalogPage()              │
│  } else {                            │
│    → LoginPage()                     │
│  }                                   │
└──────────┬───────────────────────────┘
           │
   ┌───────┴────────┬───────────┐
   │                │           │
   ↓                ↓           ↓
 Login         Admin Home   Customer Home
 Page          Dashboard    Katalog
```

## 2️⃣ LOGIN FLOW (Admin)

```
User Launch App
   │
   ├─ Not Logged In
   │  ↓
   └─→ LoginPage
       │
       ├─ Choose Tab: "Admin"
       │
       ├─ Input:
       │  Email: admin@gmail.com
       │  Password: admin123
       │
       ├─ Click "Login Admin"
       │
       ├─ AuthService.loginAdmin()
       │  ├─ Validasi email & password
       │  ├─ Set _currentRole = 'admin'
       │  ├─ Set _currentUserName = 'Admin'
       │  └─ Save to SharedPreferences
       │     (Persisten!)
       │
       └─ Navigate to AdminDashboard
          └─ Welcome message: "Selamat Datang, Admin!"
```

## 3️⃣ ADMIN: TAMBAH PRODUK FLOW

```
AdminDashboard
   │
   └─ Click "Kelola Produk"
      │
      └─→ AdminManageProductsPage (StatefulWidget)
          │
          ├─ Form Input:
          │  ├─ nameController
          │  ├─ priceController
          │  ├─ stockController
          │  └─ imageController
          │
          └─ Click "Tambah Produk"
             │
             ├─ addProduct()
             │  │
             │  ├─ Validasi tidak kosong
             │  │
             │  ├─ productService.addProduct(
             │  │    name, price, stock, image)
             │  │
             │  ├─ ProductService:
             │  │  ├─ Create Map baru
             │  │  ├─ Add ke _products list
             │  │  └─ Call _saveToStorage()
             │  │      │
             │  │      ├─ JSON encode _products
             │  │      └─ prefs.setString(
             │  │          _storageKey,
             │  │          productsJson)
             │  │         (SharedPreferences Save!)
             │  │
             │  ├─ setState(() {}) ← Rebuild page
             │  │
             │  └─ Show SnackBar:
             │     "Produk berhasil ditambahkan!"
             │
             └─ ListView rebuild dengan produk baru
```

## 4️⃣ SYNC: PRODUCT MUNCUL DI KATALOG

```
Admin Tambah Produk
└─ ProductService._products = [... + new product]
   └─ SharedPreferences.setString(json_data)
      └─ Data Tersimpan ✓

Customer Buka KatalogPage
└─ KatalogPage.build()
   │
   ├─ ProductService productService = ProductService()
   │  (Singleton! → Same instance sebagai admin)
   │
   ├─ final products = productService.products
   │  (Fresh copy dari _products list)
   │
   ├─ GridView.builder(
   │    itemCount: products.length
   │  )
   │
   └─ Display all products including new one ✓
      (REAL-TIME SYNC!)
```

## 5️⃣ LOGIN FLOW (Customer/Pembeli)

```
LoginPage
├─ Choose Tab: "Pembeli"
│
├─ Input:
│  Email: user@email.com (apapun)
│  Password: minimal 6 karakter
│
├─ Click "Login Pembeli"
│
├─ AuthService.loginCustomer()
│  ├─ Validasi email & password length
│  ├─ Set _currentRole = 'customer'
│  ├─ Set _currentUserName = email prefix
│  └─ Save to SharedPreferences
│
└─ Navigate to KatalogPage
   └─ GridView tampil dengan produk
      (dari ProductService yang sama!)
```

## 6️⃣ CUSTOMER: BELI PRODUK FLOW

```
KatalogPage
   │
   ├─ GridView dari ProductService.products
   │
   └─ Setiap Produk:
      │
      ├─ View Detail
      │  └─ Click "Detail" button
      │     └─ Navigate /detail dengan product data
      │
      └─ Tambah ke Keranjang
         └─ Click cart icon
            │
            ├─ KeranjangService.tambahKeKeranjang()
            │  ├─ Add item to _keranjangItems
            │  └─ Save to SharedPreferences
            │
            ├─ Show SnackBar: "Ditambahkan ke keranjang"
            │
            └─ Navigate to KeranjangPage
               │
               ├─ Lihat keranjang items
               ├─ Adjust quantity
               ├─ Hapus item
               │
               └─ Click "Checkout"
                  └─ Navigate to PembayaranPage
                     └─ Process pembayaran
```

## 7️⃣ LOGOUT FLOW

```
Navbar (KatalogPage/AdminDashboard)
   │
   └─ Click Logout Icon
      │
      ├─ authService.logout()
      │  ├─ Clear _currentRole
      │  ├─ Clear _currentUserName
      │  └─ Save to SharedPreferences (clear session)
      │
      └─ Navigator.pushReplacementNamed(context, '/')
         │
         └─ AuthWrapper check lagi
            │
            └─ isLoggedIn() = false
               │
               └─ Return LoginPage()
                  (Back to login!)
```

## 8️⃣ DATA PERSISTENCE FLOW

```
SharedPreferences Storage:

┌─────────────────────────────────────┐
│  products_data                      │
├─────────────────────────────────────┤
│ [{                                  │
│   "id": "1",                        │
│   "name": "Bouquet 1",              │
│   "price": 85000,                   │
│   "stock": 11,                      │
│   "image": "assets/.../flower1.png" │
│ }, ...]                             │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  user_role                          │
├─────────────────────────────────────┤
│ "admin" atau "customer"             │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  user_name                          │
├─────────────────────────────────────┤
│ "Admin" atau "user@email.com"       │
└─────────────────────────────────────┘

Saat App Start:
ProductService.initialize()
└─ Load dari SharedPreferences
   └─ _products = parsed json data

AuthService.initialize()
└─ Load dari SharedPreferences
   └─ _currentRole & _currentUserName restored
```

## 9️⃣ EDIT PRODUK FLOW (Admin)

```
AdminManageProductsPage
   │
   └─ ListView dengan setiap produk
      │
      └─ Klik Edit Icon
         │
         ├─ editProduct(index)
         │  ├─ Get product dari list
         │  ├─ Fill form controllers
         │  │
         │  └─ Show AlertDialog
         │     │
         │     ├─ TextField untuk edit
         │     │
         │     └─ Klik "Simpan"
         │        │
         │        ├─ productService.updateProduct(
         │        │    id, name, price, stock, image)
         │        │
         │        ├─ ProductService:
         │        │  ├─ Find product by id
         │        │  ├─ Update values
         │        │  └─ Save to SharedPreferences
         │        │
         │        ├─ setState(() {}) rebuild
         │        │
         │        └─ Show SnackBar "Berhasil update"
         │
         └─ Customer lihat perubahan di katalog
            (Otomatis! Singleton sync)
```

## 🔟 DELETE PRODUK FLOW (Admin)

```
AdminManageProductsPage
   │
   └─ Klik Delete Icon
      │
      ├─ deleteProduct(index)
      │  │
      │  └─ Show Confirm Dialog
      │     │
      │     └─ Klik "Hapus"
      │        │
      │        ├─ productService.deleteProduct(id)
      │        │  ├─ Remove dari _products list
      │        │  └─ Save to SharedPreferences
      │        │
      │        ├─ setState(() {}) rebuild
      │        │
      │        └─ Show SnackBar "Berhasil hapus"
      │
      └─ Produk hilang dari:
         ├─ Admin list
         └─ Customer katalog (Otomatis!)
```

---

## 📊 STATE DIAGRAM

```
                    ┌─────────────────┐
                    │   NO SESSION    │
                    │   (Not Logged)  │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │   Login Page    │
                    └────────┬────────┘
                             │
                ┌────────────┴────────────┐
                │                        │
        ┌───────▼──────┐        ┌───────▼──────┐
        │ Admin Login  │        │ Customer Login
        └───────┬──────┘        └───────┬──────┘
                │                        │
        ┌───────▼──────────────────────┐│
        │    AUTHENTICATED SESSION      ││
        │  (Saved in SharedPreferences) ││
        └───────┬──────────────────────┘│
                │                       │
        ┌───────▼──────┐       ┌────────▼─────┐
        │ AdminDashbrd │       │ KatalogPage  │
        │ ├─Manage Prod│       │ ├─View Prod  │
        │ └─View All   │       │ ├─Add Cart   │
        │              │       │ └─Checkout   │
        └───────┬──────┘       └────────┬─────┘
                │                       │
        ┌───────┴───────────────────────┴─────┐
        │  Can Logout (Clear Session)         │
        └─────────────────────────────────────┘
                         │
                         ↓
                    NO SESSION AGAIN
```

---

Ini adalah alur lengkap aplikasi Flowries yang menghubungkan semua komponen! 🎯
