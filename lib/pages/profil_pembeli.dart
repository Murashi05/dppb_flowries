import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'dart:convert';

class ProfilPembeli extends StatefulWidget {
  final User user;

  const ProfilPembeli({super.key, required this.user});

  @override
  State<ProfilPembeli> createState() => _ProfilPembeliState();
}

class _ProfilPembeliState extends State<ProfilPembeli> {
  late User currentUser;
  final String _userStorageKey = 'user_profile_data';

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _loadUserData();
  }

  // Load user data dari SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userStorageKey);
      
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        setState(() {
          currentUser = User.fromJson(userData);
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Save user data ke SharedPreferences
  Future<void> _saveUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userStorageKey, jsonEncode(user.toJson()));
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  void _showEditDialog() {
    final namaController = TextEditingController(text: currentUser.nama);
    final emailController = TextEditingController(text: currentUser.email);
    final noTeleponController = TextEditingController(text: currentUser.noTelepon);
    final alamatController = TextEditingController(text: currentUser.alamat);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noTeleponController,
                decoration: InputDecoration(
                  labelText: 'No. Telepon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: alamatController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
            ),
            onPressed: () {
              // Update user data
              final updatedUser = User(
                id: currentUser.id,
                nama: namaController.text,
                email: emailController.text,
                noTelepon: noTeleponController.text,
                alamat: alamatController.text,
                tipeUser: currentUser.tipeUser,
                password: currentUser.password,
                createdAt: currentUser.createdAt,
              );

              // Simpan ke storage
              _saveUserData(updatedUser);

              // Update state parent menggunakan setState dari parent context
              setState(() {
                currentUser = updatedUser;
              });

              // Close dialog
              Navigator.pop(dialogContext);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil berhasil diperbarui dan tersimpan'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  currentUser.nama[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Profile Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Nama', currentUser.nama),
                  const Divider(),
                  _buildInfoRow('Email', currentUser.email),
                  const Divider(),
                  _buildInfoRow('No. Telepon', currentUser.noTelepon),
                  const Divider(),
                  _buildInfoRow('Alamat', currentUser.alamat),
                  const Divider(),
                  _buildInfoRow(
                    'Tipe User',
                    currentUser.tipeUser,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                onPressed: _showEditDialog,
                child: const Text(
                  'Edit Profil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Apakah Anda yakin ingin logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
