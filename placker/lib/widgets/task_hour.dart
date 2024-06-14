import 'package:flutter/material.dart';

import 'package:placker/widgets/widgets.dart';


//per triar les hores d'inici i final de la tasca
class TaskHour extends StatefulWidget {
  
  final String text;
  final String? startValue;
  final String? endValue;
  final Function(String?, String?) onChanged;

  const TaskHour({
    Key? key,
    required this.text,
    required this.startValue,
    required this.endValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TaskHourState createState() => _TaskHourState();
}

class _TaskHourState extends State<TaskHour> {
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  //passar del tipus string del Firebase a TimeOfDay
  TimeOfDay? _parseTimeString(String? timeString) {

    if (timeString == null) return TimeOfDay.now();

    List<String> parts = timeString.split(':');
    
    if (timeString.split(':').length != 2) return TimeOfDay.now();

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void initState() {
    super.initState();

    //s'estableixen unes hores per defecte
    if (widget.startValue == null && widget.endValue == null) {
      _selectedStartTime = TimeOfDay.now();
      final endTimeHour = TimeOfDay.now().hour + 1;
      final endHour = endTimeHour > 23 ? 23 : endTimeHour;
      final endMinute = endTimeHour > 23 ? 59 : TimeOfDay.now().minute; 
      _selectedEndTime = TimeOfDay(hour: endHour, minute: endMinute);
    }
    
    else {
      _selectedStartTime = _parseTimeString(widget.startValue);
      _selectedEndTime = _parseTimeString(widget.endValue);
    }
  }

  //diàleg per seleccionar les hores
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      
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

    //passar del tipus TimeOfDay a string del Firebase
    String? _formatTimeOfDay(TimeOfDay? timeOfDay) {
      String hourString = timeOfDay!.hour.toString().padLeft(2, '0');
      String minuteString = timeOfDay.minute.toString().padLeft(2, '0');
      return '$hourString:$minuteString';
    }

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = pickedTime;
        } else {
          _selectedEndTime = pickedTime;
        }
      });
      
      String? horaStartString = _formatTimeOfDay(_selectedStartTime);
      String? horaEndString = _formatTimeOfDay(_selectedEndTime);
      
      widget.onChanged(horaStartString, horaEndString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          BuildTaskText(text: widget.text),

          //hora d'inici
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
                  onTap: () => _selectTime(context, true),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _selectedStartTime == null
                          ? _formatTime(TimeOfDay.now())
                          : _formatTime(_selectedStartTime!),
                      style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const Text('-', style: TextStyle(color: Colors.grey, fontSize: 24)),

          //hora de fi
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
                  onTap: () => _selectTime(context, false),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _selectedEndTime == null
                          ? _formatTime(TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute))
                          : _formatTime(_selectedEndTime!),
                      style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//perquè afegeixi el 0 a l'esquerra als minuts
String _formatTime(TimeOfDay timeOfDay) {

  final hour = timeOfDay.hour.toString().padLeft(2, '0');
  final minute = timeOfDay.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}
