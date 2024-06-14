import 'package:flutter/material.dart';

import 'package:placker/widgets/widgets.dart';


//per indicar el nom de la tasca (obligatori)
class TaskTasca extends StatelessWidget {
  
  final String text;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  
  const TaskTasca({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            BuildTaskText(text: text),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                
                  //formulari
                  child: TextFormField(
                    initialValue: value,
                    autocorrect: false,
                    cursorColor: const Color.fromARGB(255, 170, 170, 170),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal),
                    onChanged: onChanged,
                    validator: validator,
                  )
                ),
              ),
            ),
          ],
        ),
    );
  }
}