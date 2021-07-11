
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/auth_widget.dart';
import 'package:get_up_park/app/home/home_page.dart';
import 'package:get_up_park/app/onboarding/onboarding_page.dart';
import 'package:get_up_park/app/onboarding/onboarding_view_modal.dart';
import 'package:get_up_park/app/sign_in/sign_in_page.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/push_notifications.dart';
import 'package:get_up_park/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Declared as global, outside of any class
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {


  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  if(
  !StringUtils.isNullOrEmpty(message.notification?.title, considerWhiteSpaceAsEmpty: true) ||
      !StringUtils.isNullOrEmpty(message.notification?.body, considerWhiteSpaceAsEmpty: true)
  ){
    print('message also contained a notification: ${message.notification}');

    String? imageUrl;
    imageUrl ??= message.notification!.android?.imageUrl;
    imageUrl ??= message.notification!.apple?.imageUrl;

    Map<String, dynamic> notificationAdapter = {
      NOTIFICATION_CHANNEL_KEY: 'basic_channel',
      NOTIFICATION_ID:
      message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_ID] ??
          message.messageId ??
          Random().nextInt(2147483647),
      NOTIFICATION_TITLE:
      message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_TITLE] ??
          message.notification?.title,
      NOTIFICATION_BODY:
      message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_BODY] ??
          message.notification?.body ,
      NOTIFICATION_LAYOUT:
      StringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
      NOTIFICATION_BIG_PICTURE: imageUrl
    };

    AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
  }
  else {
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }

  // Use this method to automatically convert the push data, in case you gonna use our data standard
  // AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();
  // PushNotificationsManager().init();
  // await Future.delayed(const Duration(seconds: 15));

  await FirebaseMessaging.instance.subscribeToTopic("News");

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelKey: 'news_channel',
            channelName: 'All News Notifications',
            channelDescription: 'Notification channel for news',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white
        )
      ]
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });


  runApp(ProviderScope(

    overrides: [
      sharedPreferencesServiceProvider.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black, // Color for Android
        statusBarBrightness: Brightness.light // Dark == white status bar -- for IOS.
    ));
    final firebaseAuth = context.read(firebaseAuthProvider);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWidget(
        nonSignedInBuilder: (_) =>
            Consumer(
              builder: (context, watch, _) {
                return SignInPage();
                // final didCompleteOnboarding =
                // watch(onboardingViewModelProvider);
                // return didCompleteOnboarding
                //     ? SignInPage()
                //     : OnboardingPage(); //Onboarding Page Call
              },
            ),
        signedInBuilder: (_) => HomePage(),
      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}

