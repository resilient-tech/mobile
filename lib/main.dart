import 'dart:ui';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frappe_app/app.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/utils/http.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  await resetValues();
  await initDb();
  await FlutterDownloader.initialize();
  FlutterDownloader.registerCallback(downloadCallback);
  await initApiConfig();
  await initLocalNotifications();
  // await initAutoSync();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => FrappeApp(),
    ),
  );
}

void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final send = IsolateNameServer.lookupPortByName('downloader_send_port');
  if (send == null) return;
  send.send([id, status, progress]);
}
