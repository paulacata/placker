import 'package:flutter/material.dart';


//configuració dels estils dels camps d'entrada del formulari 
class InputDecorations {

  static InputDecoration LoginInputDecoration({required String hintText}) {
    
    return InputDecoration(
        
      //defineix la vora quan no es prem sobre el camp
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color:  Color.fromARGB(255, 193, 215, 238),
        ),
      ),
      
      //defineix la vora quan es prem sobre el camp
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color:  Color.fromARGB(255, 193, 215, 238),
          width: 3
        )
      ),
      
      //per mostrar el text que apareix abans d'escriure
      hintText: hintText,
    );
  }  
}