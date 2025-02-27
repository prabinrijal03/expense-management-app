// Notification Handler
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  void initialize() {
    _messaging.requestPermission();
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final context = navigatorKey.currentContext!;
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message.notification?.title ?? 'New Notification'),
        content: Text(message.notification?.body ?? ''),
      ),
    );
  }

  static Future<void> sendStatusUpdateNotification({
    required String userId, 
    required String expenseId,
    required String status,
  }) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': userId,
      'message': 'Your expense $expenseId was $status',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}