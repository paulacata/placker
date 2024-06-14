import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/widgets/widgets.dart';
import 'package:placker/services/services.dart';


//per triar l'assignatura de la tasca
class TaskDropdownSubject extends StatefulWidget {
  
  final String text;
  final List<String?> options;
  final String? value;
  final Function(String?) onChanged;
  
  const TaskDropdownSubject({
    Key? key,
    required this.text,
    required this.options,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TaskDropdownSubjectState createState() => _TaskDropdownSubjectState();
}

class _TaskDropdownSubjectState extends State<TaskDropdownSubject> {

  String? finalValue;

  @override
  void initState() {
    super.initState();
    updateFinalValue();
  }

  @override
  void didUpdateWidget(covariant TaskDropdownSubject oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateFinalValue();
  }

  void updateFinalValue() {
    if (widget.options.contains(widget.value)) {
      finalValue = widget.value;
    } else {
      finalValue = '';
      widget.onChanged(finalValue);
    }
  }

  @override
  Widget build(BuildContext context) {

    final subjectProvider = Provider.of<SubjectsService>(context);
    final subjects = subjectProvider.subjects.map((subject) => subject.assignatura).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              
                //definició del desplegable
                child: DropdownButton(
                  items: [
                    const DropdownMenuItem(value: '', child: SizedBox()),
                    ...subjects.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Center(child: Text(option?.toString() ?? '', style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal))),
                      );
                    })
                  ],
                        
                  iconSize: 40,
                  iconEnabledColor: Colors.grey.shade400,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: Colors.white,
                  value: finalValue,
                  onChanged: (String? newValue) => setState(() {
                  finalValue = newValue!;
                  widget.onChanged(finalValue);
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