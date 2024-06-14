import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/providers/providers.dart';


//pantalla general de l'aplicació un cop s'ha iniciat sessió o registrat
class HomeScreen extends StatelessWidget {
  
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    return Container(
        color: const Color.fromARGB(255, 193, 215, 238),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
          
                const SizedBox(height: 150),

                //calendari
                SizedBox(
                  width: 350,
                  height: 70,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<UiProvider>(context, listen: false).selectedMenuOption = 0;
                      Navigator.pushNamed(context, 'Empty');
                    },
                    icon: const Icon(Icons.calendar_month_outlined, size: 50, color:Color(0xff506EA4)),
                    label: const Text('CALENDARI', style: TextStyle(fontSize: 30, color:Color(0xff506EA4))),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                  )
                ),
            
                const SizedBox(height: 70),
                
                //llistat
                SizedBox(
                  width: 350,
                  height: 70,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<UiProvider>(context, listen: false).selectedMenuOption = 1;
                      Navigator.pushNamed(context, 'Empty', arguments: 1);
                    },
                    icon: const Icon(Icons.list_alt, size: 50, color:Color(0xff506EA4)),
                    label: const Text('LLISTAT', style: TextStyle(fontSize: 30, color:Color(0xff506EA4))),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                  )
                ),
            
                const SizedBox(height: 70),
          
                //registrar
                SizedBox(
                  width: 350,
                  height: 70,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<UiProvider>(context, listen: false).selectedMenuOption = 2;
                      Navigator.pushNamed(context, 'Empty', arguments: 2);
                    },
                    icon: const Icon(Icons.watch_later_outlined, size: 50, color:Color(0xff506EA4)),
                    label: const Text('REGISTRAR', style: TextStyle(fontSize: 30, color:Color(0xff506EA4))),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                  )
                ),
              
                const SizedBox(height: 70),
          
                //perfil
                SizedBox(
                  width: 350,
                  height: 70,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<UiProvider>(context, listen: false).selectedMenuOption = 3;
                      Navigator.pushNamed(context, 'Empty', arguments: 3);
                    },
                    icon: const Icon(Icons.person_outline, size: 50, color:Color(0xff506EA4)),
                    label: const Text('PERFIL', style: TextStyle(fontSize: 30, color:Color(0xff506EA4))),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                  )
                ),

                const SizedBox(height: 150),
                
              ]
            ),
          ), 
        ),
    );
  }
}