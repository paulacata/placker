import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


//per mostrar el pop up un cop s'ha acabat cada tipus de temps
void RegisterPopup(BuildContext context, String statusText, String nextAction) async {
  
  //que soni una notificació
  final audio = AudioPlayer();
  await audio.play(AssetSource('audio.wav'));

  //mostrar el text corresponent
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, 

        title: Center(
          child: Text(
            statusText,
            style: const TextStyle(
              color: Color(0xff506EA4),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFCDE7FF),
              side: const BorderSide(color: Color(0xff506EA4), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            ),
            child: Text(
              nextAction,
              style: const TextStyle(color: Color(0xff506EA4), fontSize: 17, fontWeight: FontWeight.normal),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}