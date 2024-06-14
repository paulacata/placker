import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/services/services.dart';


//pantalla principal del perfil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    //instància per l'autenticació
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder(
      future: authService.readUID(),
      builder: (context, AsyncSnapshot<String> uidSnapshot) {
        if (uidSnapshot.connectionState == ConnectionState.done && uidSnapshot.hasData) {
          final uid = uidSnapshot.data!;

          return FutureBuilder(
            future: authService.getUserEmail(uid),
            builder: (context, AsyncSnapshot<String> emailSnapshot) {
              if (emailSnapshot.connectionState == ConnectionState.done && emailSnapshot.hasData) {
                final email = emailSnapshot.data!;
                final initial = email.isNotEmpty ? email[0].toUpperCase() : '';

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade400,
                              child: Text(
                                initial,
                                style: const TextStyle(fontSize: 50, color: Colors.white),
                              ),
                            ),

                            const SizedBox(width: 25),

                            Expanded(
                              child: Text(
                                email,
                                style: const TextStyle(fontSize: 18, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 55),

                        ElevatedButton.icon(
                          onPressed: () async {
                            await authService.logoutUser();
                            Navigator.pushReplacementNamed(context, 'Login');
                          },
                          icon: const Icon(Icons.logout, size: 20),
                          label: const Text(
                            'Tancar sessió',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xff506EA4),
                            backgroundColor: const Color(0xFFCDE7FF),
                            padding: const EdgeInsets.all(15),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),

                        const SizedBox(height: 20),
                        
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}