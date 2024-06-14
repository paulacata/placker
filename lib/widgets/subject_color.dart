import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:placker/widgets/widgets.dart';


//per seleccionar el color de l'assignatura
class SubjectColor extends StatefulWidget {
  
  final String text;
  final String? value;
  final Function(String?) onChanged;

  const SubjectColor({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SubjectColorState createState() => _SubjectColorState();
}

class _SubjectColorState extends State<SubjectColor> {
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.value != null ? Color(int.parse(widget.value!)) : null;
  }

  //diàleg per seleccionar un color
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: MaterialColorPicker(
              selectedColor: _selectedColor,
              onMainColorChange: (ColorSwatch<dynamic>? colorSwatch) {
                if (colorSwatch != null) {
                  
                  //agafa la tonalitat concreta
                  Color color = colorSwatch[500]!;
                  setState(() {
                    _selectedColor = color;
                  });
                }
              },
              allowShades: false,

              //colors disponibles
              colors: [
              ColorSwatch(const Color(0xFF506EA4).value, const {500:  Color(0xFF506EA4)}),
              ColorSwatch(Colors.red.shade300.value, {500: Colors.red.shade300}),
              ColorSwatch(Colors.cyan.shade200.value, {500: Colors.cyan.shade200}),
              ColorSwatch(Colors.yellow.shade300.value, {500: Colors.yellow.shade300}),
              ColorSwatch(Colors.pink.shade200.value, {500: Colors.pink.shade200}),
              ColorSwatch(Colors.green.shade200.value, {500: Colors.green.shade200}),
              ColorSwatch(const Color(0xFFCE82DB).value, const {500:  Color(0xFFCE82DB)}),
              ColorSwatch(const Color(0xFFECB87A).value, const {500:  Color(0xFFECB87A)}),
              ],
            ),
          ),

          actions: <Widget>[

            //botó de cancel·lar del diàleg
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: const Color(0xFF506EA4),
              ), 
              child: const Text('Cancelar', style: TextStyle (color: Color(0xFF506EA4))),
            ),

            //botó d'acceptar del diàleg
            ElevatedButton(
              onPressed: () {
                String? colorString = '0x${_selectedColor!.value.toRadixString(16)}';
                widget.onChanged(colorString);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: const Color(0xFF506EA4),
              ),           
              child: const Text('ACEPTAR', style: TextStyle (color: Color(0xFF506EA4))),
            ),
          ],
        );
      },
    );
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
                child: GestureDetector(
                  onTap: () => _showColorPicker(context),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: _selectedColor,
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