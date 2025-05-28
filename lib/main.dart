import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      // Thêm options thủ công nếu cần (lấy từ Firebase Console nếu file cấu hình không hoạt động)
      // options: const FirebaseOptions(
      //   apiKey: "YOUR_API_KEY",
      //   appId: "YOUR_APP_ID",
      //   messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      //   projectId: "YOUR_PROJECT_ID",
      // ),
    );
    await AuthService().createAdminAccount(); // Chạy 1 lần, sau đó xóa dòng này
  } catch (e) {
    print('Lỗi khởi tạo Firebase: $e');
  }
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