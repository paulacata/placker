import 'package:flutter/material.dart';


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