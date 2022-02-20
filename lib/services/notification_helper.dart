import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medsreminder/components/dialogs.dart';
import 'package:medsreminder/providers/appointments_provider.dart';
import 'package:medsreminder/screens/appointment_details.dart';
import 'package:medsreminder/appdata/application_data.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class NotificationHelper {
  //NotificationHelper a singleton object
  static final NotificationHelper _NotificationHelper =
      NotificationHelper._internal();

  factory NotificationHelper() {
    return _NotificationHelper;
  }

  NotificationHelper._internal();

  // Android notification details defaults
  static const _channelId = 'meds_notify';
  static const _channelName = 'MedsReminder';
  static const _channelDescription = 'MedsReminder\'s notification channel';
  static const _notificationIcon = "@drawable/app_icon";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(_notificationIcon);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // this is triggered on notification tap
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        dynamic data = jsonDecode(payload);
        // case 1 - appointments
        if (data["type"] == "appointment") {
          await Navigator.of(navigatorKey.currentContext!).push(
              MaterialPageRoute(
                  builder: (context) => AppointmentDetails(
                      appointment: Provider.of<AppointmentsProvider>(context,
                              listen: false)
                          .selectByNotificationId(data["id"]))));
        } else {
          await Dialogs.pillDialog(navigatorKey.currentContext!, data['id']);
        }
      }
    });
  }

  // generic notif. setup
  final AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: _channelDescription,
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  // medications notif. setup
  final AndroidNotificationDetails _medsNotificationDetails =
      AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: _channelDescription,
    color: ApplicationData.notificationsColor["medication"],
    //colorized: true,
    //ledColor: ApplicationData.notificationsColor["medication"],
    largeIcon: ApplicationData.notificationsIcons["medication"],
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  // appointment notif. setup
  final AndroidNotificationDetails _appoNotificationDetails =
      AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: _channelDescription,
    color: ApplicationData.notificationsColor["appointment"],
    //colorized: true,
    //ledColor: ApplicationData.notificationsColor["appointment"],
    largeIcon: ApplicationData.notificationsIcons["appointment"],
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> showNotifications(
      int id, String? title, String? body, String? payload) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title ?? "",
      body ?? "",
      NotificationDetails(android: _androidNotificationDetails),
      payload: payload,
    );
  }

  Future<void> scheduleNotifications(int id, String? title, String? body,
      DateTime date, String? payload) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title ?? "",
        body ?? "",
        tz.TZDateTime.from(date, tz.local),
        NotificationDetails(android: _appoNotificationDetails),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> scheduleNotificationsDaily(int id, String? title, String? body,
      DateTime time, String? payload) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title ?? "",
        body ?? "",
        tz.TZDateTime.from(time, tz.local),
        NotificationDetails(android: _medsNotificationDetails),
        androidAllowWhileIdle: true,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
