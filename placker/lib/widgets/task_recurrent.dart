import 'package:flutter/material.dart';

import 'package:placker/widgets/widgets.dart';


//per triar si la tasca és o no recurrent 
class TaskRecurrent extends StatefulWidget {
  
  final String text;
  final bool? value;
  final Function(bool?) onChanged;
  
  const TaskRecurrent({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TaskRecurrentState createState() => _TaskRecurrentState();
}

class _TaskRecurrentState extends State<TaskRecurrent> {
  bool? _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value ?? false;
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
                  alignment: Alignment.centerLeft,
                  child: Checkbox(
                    splashRadius: 0,
                    side: MaterialStateBorderSide.resolveWith((states) {
                      return const BorderSide(width: 2, color: Colors.grey);
                    }),

                    fillColor: MaterialStateProperty.resolveWith<Color>((states) => states.contains(MaterialState.selected) ? Colors.grey : Colors.white),
                    value: _isChecked,
                    onChanged: (bool? newValue) => setState(() {
                      _isChecked = newValue!;
                      widget.onChanged(_isChecked);
                    }),
                  )
                ),
              ),
            ),
          ],
        ),
    );
  }
}