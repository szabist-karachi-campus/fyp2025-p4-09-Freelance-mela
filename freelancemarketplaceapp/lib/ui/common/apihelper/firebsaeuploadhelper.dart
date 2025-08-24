// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;


class FirebaseHelper {
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
}
