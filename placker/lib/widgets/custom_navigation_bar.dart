import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/providers/providers.dart';


//barra inferior per seleccionar les diferents opcions
class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    
    //obtenir la opció de menú seleccionada
    final uiProvider = Provider.of<UiProvider>(context);

    return BottomNavigationBar(
      onTap: (int i) => uiProvider.selectedMenuOption = i,
      currentIndex: uiProvider.selectedMenuOption,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      backgroundColor: Colors.white,
      items: [
        _CustomNavavigationItem(Icons.calendar_month_outlined, uiProvider, 0),
        _CustomNavavigationItem(Icons.list_alt, uiProvider, 1),
        _CustomNavavigationItem(Icons.watch_later_outlined, uiProvider, 2),
        _CustomNavavigationItem(Icons.person_outline, uiProvider, 3),
      ],
    );
  }

  //estil de cadascuna de les opcions
  BottomNavigationBarItem _CustomNavavigationItem(IconData icon, uiProvider, index) {
    
    return BottomNavigationBarItem(

      icon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: uiProvider.selectedMenuOption == index ? const Color.fromARGB(255, 193, 215, 238) : Colors.white,
          border: Border.all(
            color: const Color.fromARGB(255, 193, 215, 238),
            width: 3,
          ),
        ),
        child: Icon(
          icon,
          color: uiProvider.selectedMenuOption == index ? Colors.white : const Color.fromARGB(255, 193, 215, 238),
          size: 40,
        ),
      ),
      label: '',
    );
  }
}