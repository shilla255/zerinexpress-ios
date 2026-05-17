import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:zerin_express/features/splash/screens/splash_screen.dart';
import 'package:zerin_express/helper/notification_helper.dart';
import 'package:zerin_express/helper/di_container.dart' as di;
import 'package:zerin_express/localization/localization_controller.dart';
import 'package:zerin_express/localization/messages.dart';
import 'package:zerin_express/theme/dark_theme.dart';
import 'package:zerin_express/theme/light_theme.dart';
import 'package:zerin_express/theme/theme_controller.dart';
import 'package:zerin_express/util/app_constants.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAg0pkKGzrJcSRv-uWI82JrzSJvyz1h_bY",
          appId: "1:56442076502:android:4e9ab51b5949b147b96af7",
          messagingSenderId: "56442076502",
          projectId: "zerinexpress-1401c",
          storageBucket: "zerinexpress-1401c.appspot.com",
        ),
      );
    }
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  Map<String, Map<String, String>> languages = await di.init();

  try {
    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {
    debugPrint('Messaging init error: $e');
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(languages: languages, notificationData: null));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final Map<String,dynamic>? notificationData;
  const MyApp({super.key, required this.languages, this.notificationData});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return SafeArea(
          top: false,
          child: GetMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},),
              theme: themeController.darkTheme ? darkTheme : lightTheme,
              locale: localizeController.locale,
              home: SplashScreen(notificationData: notificationData),
              translations: Messages(languages: languages),
              fallbackLocale: Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode),
              defaultTransition: Transition.fadeIn,
              transitionDuration: const Duration(milliseconds: 500),
              builder:(context,child){
                return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.95)), child: child!);
              }
          ),
        );
      });
    });
  }
}
