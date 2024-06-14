import 'package:flutter/material.dart';
import 'package:placker/widgets/widgets.dart';

import 'package:intl/intl.dart';


//per triar el dia de la tasca
class TaskDay extends StatefulWidget {

  final String text;
  final String? value;
  final Function(String?) onChanged;
  
  const TaskDay({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TaskDayState createState() => _TaskDayState();
}

class _TaskDayState extends State<TaskDay> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    
    //s'estableix el dia d'avui per defecte
    _selectedDate = widget.value != null ? DateTime.parse(widget.value! + ' 00:00:00') : DateTime.now();
  }

  //diàleg per seleccionar un dia
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),

      //per canviar l'estil de les opcions de dates que s'obre
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF506EA4),
            ),
          ),

          //per assegurar-nos que no serà nul
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      String? dateString = pickedDate.toString().substring(0, 10);
      widget.onChanged(dateString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          BuildTaskText(text: widget.text),
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
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _selectedDate == null
                        ? DateFormat('dd/MM/yyyy').format(DateTime.now())
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.normal),
                    ), 
                  ), 
                ), 
              ),
            ),
          ),
        ]
      ) 
    ); 
  }
}
