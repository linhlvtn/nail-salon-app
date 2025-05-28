import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool rememberMe = false;
  String? errorMessage;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadSavedPhone();
  }

  Future<void> _loadSavedPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('phone');
    if (savedPhone != null) {
      _phoneController.text = savedPhone;
      setState(() => rememberMe = true);
    }
  }

  Future<void> _signIn() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Vui lòng nhập số điện thoại và mật khẩu');
      return;
    }
    try {
      await _authService.signIn(_phoneController.text, _passwordController.text);
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('phone', _phoneController.text);
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      setState(() => errorMessage = 'Đăng nhập thất bại: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nail Salon', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) => setState(() => rememberMe = value!),
                ),
                const Text('Ghi nhớ tài khoản'),
              ],
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Đăng nhập', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
              child: const Text('Đăng ký', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      ),
    );
  }
}