import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- 1. Yeh import add karein
import 'package:inneed_practice/Providers/Emergency_contact/emergency_provider.dart';
import 'package:inneed_practice/Providers/FirstAid_provider/first_aid_provider.dart';
import 'package:inneed_practice/Providers/Hospital_Provider/hospital_provider.dart';
import 'package:inneed_practice/constant/color.dart';
import 'package:inneed_practice/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:inneed_practice/views/alert_popup/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// background message handler ( will receive here when the app closed)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Dotenv load karein taake app start hone se pehle keys read ho sakein
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Dotenv load error: $e");
  }

  // Firebase initialize
  await Firebase.initializeApp();

  // Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Notification initialize
  try {
    await NotificationService.initialize();
  } catch (e) {
    print("Notification initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
        ChangeNotifierProvider(create: (_) => FirstAidProvider()),
        ChangeNotifierProvider(create: (_) => HospitalProvider()),
      ],
      child: MaterialApp(
          title: 'IN NEED',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Roboto',
            primaryColor: AppColors.primaryRed,
            scaffoldBackgroundColor: AppColors.backgroundLight,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryRed),
          ),
          home: SplashScreen()
      ),
    );
  }
}