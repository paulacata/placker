import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/screens/screens.dart';
import 'package:placker/services/services.dart';


//verifica si l'usuari ha iniciat sessió
class CheckAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            
            //mentre encara no es té el token
            if (!snapshot.hasData) {            
              return Container();
            }

            //si l'usuari no té un token, va a la pàgina d'iniciar sessió 
            if (snapshot.data == '') {
              Future.microtask(() {

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_ , __ , ___) => LoginScreen(),
                  transitionDuration: Duration(seconds: 0)
                  )
                );

              });

            //si l'usuari té un token, va a la pàgina home
            } else {

              Future.microtask(() {

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_ , __ , ___) => HomeScreen(),
                  transitionDuration: Duration(seconds: 0)
                  )
                );
              });
            }

            return Container();

          },
        ),
     ),
   );
  }
}