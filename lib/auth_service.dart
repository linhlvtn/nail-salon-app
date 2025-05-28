import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAdminAccount() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: 'admin@salonapp.com',
        password: 'admin123',
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'phone': 'admin',
        'role': 'admin',
        'approved': true,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Lỗi tạo tài khoản Admin: $e');
    }
  }

  Future<void> signUp(String phone, String password) async {
    try {
      if (phone.isEmpty || password.length < 6) {
        throw Exception('Số điện thoại không được trống và mật khẩu phải có ít nhất 6 ký tự');
      }
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: '$phone@salonapp.com',
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'phone': phone,
        'role': 'employee',
        'approved': false,
        'createdAt': Timestamp.now(),
      });
      await _firestore.collection('notifications').add({
        'userId': userCredential.user!.uid,
        'phone': phone,
        'type': 'approval_request',
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Lỗi đăng ký: $e');
      rethrow;
    }
  }

  Future<void> signIn(String phone, String password) async {
    try {
      if (phone.isEmpty || password.isEmpty) {
        throw Exception('Số điện thoại và mật khẩu không được trống');
      }
      await _auth.signInWithEmailAndPassword(
        email: '$phone@salonapp.com',
        password: password,
      );
      final userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      if (!userDoc.exists || !userDoc['approved']) {
        await _auth.signOut();
        throw Exception('Tài khoản chưa được phê duyệt');
      }
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      rethrow;
    }
  }
}