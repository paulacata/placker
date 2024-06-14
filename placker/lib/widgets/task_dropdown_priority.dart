import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/services/services.dart';
import 'package:placker/widgets/widgets.dart';


//per triar la prioritat de la tasca
class TaskDropdownPrioritat extends StatefulWidget {
  
  final String text;
  final List<String?> options;
  final String? value;
  final Function(String?) onChanged;
  
  const TaskDropdownPrioritat({
    Key? key,
    required this.text,
    required this.options,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TaskDropdownPrioritatState createState() => _TaskDropdownPrioritatState();
}

class _TaskDropdownPrioritatState extends State<TaskDropdownPrioritat> {

  String? finalValue;

  @override
  void initState() {
    super.initState();
    updateFinalValue();
  }

  @override
  void didUpdateWidget(covariant TaskDropdownPrioritat oldWidget) {
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

    final prioritatProvider = Provider.of<PrioritatService>(context);
    final prioritats = prioritatProvider.prioritats.map((prioritat) => prioritat.nom).toList();

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
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.white,
                ),
              
                //definició del desplegable
                child: DropdownButton(
                  items: [
                    const DropdownMenuItem(value: '', child: SizedBox()),
                    ...prioritats.map((option) {
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

          //botó per editar la configuració de la prioritat
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.grey,
            onPressed: () => Navigator.pushNamed(context, 'AddPrioritat'),
          ),
        ],
      ),
    );
  }
}