import 'package:flutter/material.dart';
import '../services/auth_service.dart';

AppBar buildNavbar(BuildContext context) {
  final authService = AuthService();
  
  return AppBar(
    backgroundColor: Colors.pink.shade300,
    title: const Text(
      "Flowries Bouquet",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pushNamed(context, '/customer-home'),
        child: const Text("Produk", style: TextStyle(color: Colors.white)),
      ),
      IconButton(
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/keranjang'),
      ),
      IconButton(
        icon: const Icon(Icons.history, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/riwayat'),
      ),
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () async {
          await authService.logout();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
      ),
    ],
  );
}
