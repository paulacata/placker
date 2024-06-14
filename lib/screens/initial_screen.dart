import 'package:flutter/material.dart';


//pantalla inicial on apareix la icona de l'aplicació
class InitialScreen extends StatelessWidget {
   
  const InitialScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    //navegar a la pàgina de login al prémer qualsevol part de la pantalla
    return GestureDetector(
      onTap:(){
        Navigator.pushReplacementNamed(context, 'Login');
      },
      child: Container (
        color: const Color.fromARGB(255, 193, 215, 238),
        width: double.infinity,
        height: double.infinity,
        child: Image.asset('assets/logo-without-background.png'),
      )
    );
  }
}