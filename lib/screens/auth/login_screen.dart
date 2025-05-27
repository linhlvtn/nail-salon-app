Future<void> _login() async {
  setState(() => _loading = true);
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: '${_phoneController.text}@yourapp.com',
      password: _passwordController.text,
    );

    final doc = await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();
    if (!doc.exists || !(doc['approved'] ?? false)) {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tài khoản chưa được duyệt')));
      return;
    }

    // ✅ Đã duyệt: chuyển tới Home
    Navigator.pushReplacementNamed(context, '/home');
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Lỗi đăng nhập')));
  } finally {
    setState(() => _loading = false);
  }
}
