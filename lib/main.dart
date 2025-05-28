import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
// import 'auth_service.dart'; // Chỉ import khi cần tạo Admin thủ công

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo binding được khởi tạo
  try {
    await Firebase.initializeApp(); // Khởi tạo Firebase
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Nếu lỗi vẫn xảy ra, kiểm tra console để debug
  }
  // await AuthService().createAdminAccount(); // Chạy thủ công 1 lần nếu cần, sau đó xóa
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.green[400],
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFFE0F7FA),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          const TextTheme(
            headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            bodyMedium: TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}