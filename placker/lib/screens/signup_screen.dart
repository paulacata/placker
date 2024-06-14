import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/services/services.dart';
import 'package:placker/providers/providers.dart';
import 'package:placker/widgets/widgets.dart';


//pantalla per registrar un nou usuari que encara no té compte creat
class SignupScreen extends StatelessWidget {
   
  const SignupScreen({Key? key}) : super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //el fons és el que s'ha definit al login_background
      body: LoginBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 190),

              //s'utilitza la targeta blanca per fer scroll només a ell i no a tota la pantalla
              _CardContainer(
                child: Column(
                  children: [

                    //configuració de la gestió d'estat del formulari
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),

                      //enviar el formulari a la targeta blanca
                      child: _LoginForm(),
                    )
                  ],
                )
              )
            ]
          ),
        )
      )
    );
  }
}


//definició de la targeta blanca
class _CardContainer extends StatelessWidget {

  //s'envia el contingut del formulari perquè estigui dins de la targeta
  final Widget child;
  const _CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(

      //per posar marges a la targeta
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: child,
      ),
    );
  }
}

//formulari del registre
class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //s'utilitza Provider per obtenir una instància
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      
      //s'utilitza la clau de la instància creada per vincular la instància a l'estat del formulari
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      child: Column(
        children: [

          const SizedBox(height: 20),

          //camp de l'usuari
          TextFormField(
            autocorrect: false,
            cursorColor: Color.fromARGB(255, 170, 170, 170),
            decoration: InputDecorations.LoginInputDecoration(hintText: 'USUARI'),
            onChanged: (value) => loginForm.username = value,
          ),
    
          const SizedBox(height: 28),
    
          //camp del correu
          TextFormField(
            autocorrect: false,
            cursorColor: const Color.fromARGB(255, 170, 170, 170),
            decoration: InputDecorations.LoginInputDecoration(hintText: 'CORREU'),
            onChanged: (value) => loginForm.mail = value,
            
            //comprovar que té el format de correu
            validator: (value) {
              String pattern1 = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp1  = new RegExp(pattern1);

              return regExp1.hasMatch(value ?? '')
                ? null
                : 'Correu no vàlid';
            },
          ),
    
          const SizedBox(height: 28),

          //camp de la contrasenya
          TextFormField(
            autocorrect: false,
            cursorColor: const Color.fromARGB(255, 170, 170, 170),
            obscureText: true,
            decoration: InputDecorations.LoginInputDecoration(hintText: 'CONTRASENYA'),
            onChanged: (value) => loginForm.password = value,

            //comprovar que té el format de contrasenya: 1 majúscula, 1 minúscula, 1 número, 1 caràcter especial i mínim 8 caràcters
            validator: (value) {
              String pattern2 = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
              RegExp regExp2  = new RegExp(pattern2);

              return regExp2.hasMatch(value ?? '')
                ? null
                : 'Contrasenya no vàlida\n(8 caràcters, 1 maj, 1 min, 1 num i 1 especial)';
            },
          ),
    
          const SizedBox(height: 28),

          //camp del número de telèfon 
          TextFormField(
            autocorrect: false,
            cursorColor: const Color.fromARGB(255, 170, 170, 170),
            decoration: InputDecorations.LoginInputDecoration(hintText: 'MÒBIL'),
            onChanged: (value) => loginForm.phone = value,

            //comprovar que té el format d'un telèfon de 9 dígits
            validator: (value) {
              String pattern3 = r'^[0-9]{9}$';
              RegExp regExp3  = new RegExp(pattern3);

              return regExp3.hasMatch(value ?? '')
                ? null
                : 'Número de mòbil no vàlid';
            },
          ),
    
          const SizedBox(height: 28),
    
          //botó de registrar-se
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 0,
            color: const Color.fromARGB(255, 193, 215, 238),

              //si el formulari està carregant, el botó no es pot prémer
              onPressed: loginForm.isLoading ? null : () async { 
                
                //amagar el teclat quan el formulari està carregant
                FocusScope.of(context).unfocus();

                final authService = Provider.of<AuthService>(context, listen: false); 

                //si el formulari té algun camp no vàlid, no es fa res
                if(!loginForm.isValidForm()) return;

                //passa a aquest pas si el formulari és correcte
                loginForm.isLoading = true;
                final String? response = await authService.createUser(loginForm.mail, loginForm.password);

                //si conté el token, és un correu nou, va a la següent pantalla
                if (response == null) {
                  Navigator.pushReplacementNamed(context, 'Home');
                }

                //si no conté el token, el correu ja existeix, es mostra un missatge d'error
                else {
                  NotificationService.showSnackbar(response);
                  loginForm.isLoading = false;
                }
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: const Text("Registrar-se", style: TextStyle(color: Color(0xFF506EA4), fontSize: 16)),
            ),
          ),

          const SizedBox(height: 20), 

          //botó per inciar sessió en cas de tenir un compte ja creat
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, 'Login'),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
              shape: MaterialStateProperty.all(const StadiumBorder()),
            ),
            child: const Text('Ja tinc un compte', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)), 
          ),

          const SizedBox(height: 20), 

        ],
      ),
    );
  }
}