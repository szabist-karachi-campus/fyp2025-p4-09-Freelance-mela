// ignore_for_file: depend_on_referenced_packages

import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freelancemarketplace/ui/common/apihelper/apihelper.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

import '../../../app/app.locator.dart';
import '../../../services/fire_service.dart';

class FirebaseHelper {
  static Future<String> uploadFile(html.File? file, String phone) async {
    final fireService = locator<FireService>();

    String filename = path.basename(file!.name);
    String extension = path.extension(file.name);
    String randomChars = DateTime.now().millisecondsSinceEpoch.toString();
    String uniqueFilename = '$filename-$randomChars$extension';

    UploadTask uploadTask = fireService.storage
        .child('user')
        .child(phone)
        .child(uniqueFilename)
        .putBlob(file);

    await uploadTask;

    String downloadURL = await fireService.storage
        .child('user')
        .child(phone)
        .child(uniqueFilename)
        .getDownloadURL();

    return downloadURL;
  }

  static Future<void> sendPushMessage(
      String recipientToken, String title, String body) async {
    try {
      final jsonCredentials =
      await rootBundle.loadString('assets/freelancing.json');
      final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);
      final client = await auth.clientViaServiceAccount(
        creds,
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      const String projectId = 'freelancing-f0bd1';

      final notificationData = {
        'message': {
          'token': recipientToken,
          'notification': {'title': title, 'body': body}
        },
      };

      await client.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(notificationData),
      );

      client.close();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> sendNotificationToAllUser(String title, String body) async {
    List m = await ApiHelper.allusers();
    m.forEach((element) async {
      print(element['deviceid']);
      await sendPushMessage(element['deviceid'], title, body);
    });
  }
}
