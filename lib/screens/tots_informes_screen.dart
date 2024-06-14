import 'package:flutter/material.dart';
import 'package:placker/widgets/widgets.dart';


//pantalla per anar mostrant tots els informes (diari, setmanal i mensual) depenent del valor del dropdown
class TotsInformesScreen extends StatefulWidget {

  final String dropdownValue;

  const TotsInformesScreen({Key? key, required this.dropdownValue}) : super(key: key);

  @override
  _TotsInformesScreenState createState() => _TotsInformesScreenState();
}

class _TotsInformesScreenState extends State<TotsInformesScreen> {

  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.dropdownValue;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(        
        child: Column(
          children: [

            //creu a dalt a la dreta per tornar a la pantalla anterior
            Padding(
              padding: const EdgeInsets.only(right: 5, left:5, top: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),
      
            //desplegable amb les opcions
            CustomDropdown(
              dropdownValue: _dropdownValue,
              
              //actualitza el valor seleccionat
              onChanged: (newValue) {
                setState(() {
                  _dropdownValue = newValue;
                });
              },
            ),
      
            const SizedBox(height: 15),
      
            //depenent de l'opció del desplegable es mostra la pàgina corresponent
            if (_dropdownValue == 'Mensual') ...[
              Expanded(
                child: InformeMensual(),
              )
      
            ] else if (_dropdownValue == 'Setmanal') ...[
              Expanded(
                child: InformeSetmanal(),
              )
      
            ] else if (_dropdownValue == 'Diari') ...[
              Expanded(
                child: InformeDiari(),
              )
            ],
          ],
        ),
      ),
    );
  }
}