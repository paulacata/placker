import 'package:flutter/material.dart';


//fons per les pestanyes de login i registrar usuari, incloent la icona de l'aplicació 
class LoginBackground extends StatelessWidget {
  
  final Widget child;
  const LoginBackground({Key? key, required this.child}) : super(key:key);

@override
  Widget build(BuildContext context) {
    return Container (
      color: const Color.fromARGB(255, 193, 215, 238),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          SafeArea(
            child: Container(
              width: double.infinity,
              height: 180,
              child: Image.asset('assets/logo-without-background.png'),
            )
          ),
          child,
        ],
      ),
    );
  }
}