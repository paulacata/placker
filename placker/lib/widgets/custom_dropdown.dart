import 'package:flutter/material.dart';


//definició del desplegable 
class CustomDropdown extends StatelessWidget {
  
  final String? dropdownValue;
  final Function(String?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.dropdownValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
            
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 2),
          borderRadius: BorderRadius.circular(6.0),
        ),
            
        child: DropdownButton(
          items: const [
            DropdownMenuItem(value: 'Mensual', child: Center(child: Text('Mensual', style: TextStyle(color: Colors.grey)))),
            DropdownMenuItem(value: 'Setmanal', child: Center(child: Text('Setmanal', style: TextStyle(color: Colors.grey)))),
            DropdownMenuItem(value: 'Diari', child: Center(child: Text('Diari', style: TextStyle(color: Colors.grey)))),
          ],
              
          iconSize: 40,
          iconEnabledColor: Colors.grey.shade400,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          isExpanded: true,
          underline: const SizedBox(),
          dropdownColor: Colors.white,
              
          value: dropdownValue,
          onChanged: onChanged,
        )
      )
    );
  }
}