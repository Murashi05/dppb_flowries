import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final noTeleponController = TextEditingController();
  final alamatController = TextEditingController();

  final authService = AuthService();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String _selectedRole = 'pembeli'; // pembeli atau admin

  void _handleRegister() {
    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final password = passController.text;
    final confirmPass = confirmPassController.text;

    // Validasi
    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama, email, dan password harus diisi!")),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 6 karakter!")),
      );
      return;
    }

    if (password != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak cocok!")),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email tidak valid!")),
      );
      return;
    }

    // Registrasi instant
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
    );
    Navigator.pop(context); // Kembali ke login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                color: Color(0xFFFFCDE6),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Flowries",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Buat Akun Baru",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Pilih Role
                  const Text(
                    "Pilih Tipe Akun",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedRole = 'pembeli');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: _selectedRole == 'pembeli'
                                  ? const Color(0xFFE91E63)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _selectedRole == 'pembeli'
                                    ? const Color(0xFFE91E63)
                                    : Colors.grey,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_bag,
                                  color: _selectedRole == 'pembeli'
                                      ? Colors.white
                                      : Colors.grey,
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Pembeli",
                                  style: TextStyle(
                                    color: _selectedRole == 'pembeli'
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedRole = 'admin');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: _selectedRole == 'admin'
                                  ? const Color(0xFFE91E63)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _selectedRole == 'admin'
                                    ? const Color(0xFFE91E63)
                                    : Colors.grey,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.admin_panel_settings,
                                  color: _selectedRole == 'admin'
                                      ? Colors.white
                                      : Colors.grey,
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Admin",
                                  style: TextStyle(
                                    color: _selectedRole == 'admin'
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Form Fields
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: "Nama Lengkap",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: noTeleponController,
                    decoration: InputDecoration(
                      labelText: "No. Telepon",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: alamatController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Alamat",
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: confirmPassController,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Konfirmasi Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() =>
                              _showConfirmPassword = !_showConfirmPassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _handleRegister,
                    child: Text(
                      "Daftar sebagai ${_selectedRole == 'admin' ? 'Admin' : 'Pembeli'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login di sini",
                          style: TextStyle(
                            color: Color(0xFFE91E63),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    noTeleponController.dispose();
    alamatController.dispose();
    super.dispose();
  }
}
