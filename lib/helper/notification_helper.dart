import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> onBackGroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseMessagingUtils.handleMessage(message);
}

class FirebaseMessagingUtils {
  static final String NOTIFICATION_CHANNEL = 'notification_channel';
  static final String SCHEDULE_CHANNEL = 'schedule_channel';
  static final firebaseMessaging = FirebaseMessaging.instance;
  static final localNotifications = FlutterLocalNotificationsPlugin();
  static final androidChannel = AndroidNotificationChannel(
      NOTIFICATION_CHANNEL, 'General Alerts',
      importance: Importance.high);

  static Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    initPushNotifications();
    initLocalNotifications();
  }

  static Future<void> initPushNotifications() async {
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(onBackGroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      print('onMessgaeFireBase ${message.toString()}');
      FirebaseMessagingUtils.handleMessage(message);
      FirebaseMessagingUtils.showLocalNotification(message);
    });

    final fcmToken = await firebaseMessaging.getToken();
    print('Firebase FCM Token $fcmToken');
  }

  static Future<void> initLocalNotifications() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('mipmap/launcher_icon');
    const settings = InitializationSettings(android: android, iOS: ios);

    await localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {});

    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  static void handleMessage(RemoteMessage? message) {
    print('dataHandle ${message!.data}');
  }

  static void showLocalNotification(RemoteMessage remoteMessage) {
    print('showLocalNotification ${remoteMessage.notification}');
    RemoteNotification? notification = remoteMessage.notification;
    if (notification != null) {
      localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidChannel.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
          ),
        ),
        payload: jsonEncode(remoteMessage.toMap()),
      );
    }
  }

  static Future<bool> checkIfNotificationsAreEnabled() async {
    if (Platform.isAndroid) {
      final bool granted = await localNotifications
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      return granted;
    } else {
      final bool granted = await localNotifications
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;
      return granted;
    }
  }
}
