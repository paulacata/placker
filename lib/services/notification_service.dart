import 'package:flutter/material.dart';

//aquest codi ha estat adaptat del curs Legacy – Flutter: Tu guia completa para IOS y Android de Fernando Herrera https://www.udemy.com/course/flutter-ios-android-fernando-herrera/

//per mostrar missatges sense haver de passar referències de context
class NotificationService {

  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {

    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white, fontSize: 20)),
    );

    messengerKey.currentState!.showSnackBar(snackBar);

  }
}