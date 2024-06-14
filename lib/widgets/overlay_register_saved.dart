import 'package:flutter/material.dart';


//pop up que s'obre per indicar que el registre s'ha realitzat correctament
class OverlayRegisterSaved extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    //utilitzar un stack perquè no s'obri com una nova pantalla
    return Stack(
      children: <Widget>[
        
        //la resta de fons amb opacitat i es tanca el stack si prems fora
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.black.withOpacity(0.3),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),

        Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),

            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('REGISTRE REALITZAT CORRECTAMENT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff506EA4)))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}