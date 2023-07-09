import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:um_core/um_core.dart';
import 'package:user_management_web/firebase_options.dart';
import 'package:user_management_web/pages/auth_pages/login_page.dart';
import 'package:user_management_web/pages/sidebar_with_panel/main_panel.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppData.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final String ? userId = AppData.getUserId('id');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.data,
      home: userId != null ? const MainPanelScreen() : const LoginScreen(),
    );
  }
}
