import 'package:flutter/material.dart';

//aquest codi ha estat adaptat del vídeo Pomodoro App From Scratch de Roberto Fernandes https://www.youtube.com/watch?v=pATGCf191to&list=PL-BjWplAXDCB2gH-R0tuM85RvuFWArZzL 

//per mostrar les icones de les sessions que estan realitzades i que queden per realitzar
class SessionsIcons extends StatelessWidget {

  final int sessions;
  final int sessionsRealitzades;

  const SessionsIcons({Key? key, required this.sessions, required this.sessionsRealitzades}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    
    List<Icon> icons = [];

    for (int i=0; i<sessions; i++) {
      if (i < sessionsRealitzades) {
        icons.add(const Icon(Icons.check_circle_rounded, color:Color(0xff506EA4), size: 45));
      }
      else {
        icons.add(const Icon(Icons.check_circle_outline_rounded, color: Color(0xff506EA4), size: 45));
      }
    }

    return Wrap(
      children: icons,
    );
  }
}