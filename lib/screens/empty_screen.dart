import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/providers/providers.dart';
import 'package:placker/screens/screens.dart';
import 'package:placker/widgets/widgets.dart';


//pantalla buida per cridar les diferents pàgines (calendari, llistat, registrar i perfil)
class EmptyScreen extends StatelessWidget {
  const EmptyScreen ({super.key});

  @override
  Widget build(BuildContext context) {

    final uiProvider = Provider.of<UiProvider>(context);
    final int currentIndex = uiProvider.selectedMenuOption;

    Widget body;

    switch(currentIndex) {
      case 0: 
        body = CalendarScreen(dropdownValue: 'Mensual');
        break;

      case 1:
        body = ListScreen();
        break;
      
      case 2: 
        body = RegisterScreen();
        break;
      
      case 3: 
        body = ProfileScreen();
        break;

      default:
        body = CalendarScreen(dropdownValue: 'Mensual');
        break;
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}