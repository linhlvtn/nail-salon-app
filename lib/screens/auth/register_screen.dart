import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _register() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password != confirm) {
      setState(() => _errorMessage = 'Mật khẩu không khớp');
      return;
    }

    setState(() => _loading = true);

    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '$phone@nailsalon.com',
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        'uid': userCred.user!.uid,
        'phone': phone,
        'role': 'staff',
        'approved': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() => _errorMessage = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thành công. Chờ admin duyệt.')),
      );
      Navigator.pop(context); // về màn login
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký nhân viên')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
              ),
              TextFormField(
                controller: _confirmController,
                decoration: InputDecoration(labelText: 'Nhập lại mật khẩu'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading
                    ? CircularProgressIndicator()
                    : Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
