import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/services/services.dart';
import 'package:placker/widgets/widgets.dart';


//pantalla principal del calendari
class CalendarScreen extends StatefulWidget {

  final String dropdownValue;
  final DateTime? selectedDate;

  const CalendarScreen({Key? key, required this.dropdownValue, this.selectedDate}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  String? _dropdownValue;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.dropdownValue;
    _selectedDate = widget.selectedDate;
  }

  void switchToDailyView(DateTime selectedDate) {
    setState(() {
      _dropdownValue = 'Diari';
      _selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {

    final tasksService = Provider.of<TasksService>(context);
    final filtersService = Provider.of<FiltersService>(context);

    final filteredTasks = tasksService.tasks.where((task) {
      final matchesSubject = filtersService.selectedSubjects.isEmpty || filtersService.selectedSubjects.contains(task.subject);
      final matchesEtiqueta = filtersService.selectedEtiquetas.isEmpty || filtersService.selectedEtiquetas.contains(task.etiqueta);
      final matchesPrioritat = filtersService.selectedPrioritats.isEmpty || filtersService.selectedPrioritats.contains(task.prioritat);
      final matchesCompleted = filtersService.showCompletedTasks || task.isDone!;
      final matchesPending = filtersService.showPendingTasks || !task.isDone!;
      return matchesSubject && matchesEtiqueta && matchesPrioritat && matchesCompleted && matchesPending;
    }).toList();

    return Container(
      
      margin: const EdgeInsets.only(top: 45),
      
      child: Column(
        children: [

          //desplegable amb les opcions de calendari
          CustomDropdown(
            dropdownValue: _dropdownValue,
            
            //actualitza el valor seleccionat i envia la data al calendari diari
            onChanged: (newValue) {
              setState(() {
                _dropdownValue = newValue;
                _selectedDate = (newValue == 'Diari') ? null : _selectedDate;
              });
            },
          ),

          const SizedBox(height: 15),

          //depenent de l'opció del desplegable es mostra el calendari corresponent
          if (_dropdownValue == 'Mensual') ...[
            Expanded(
              child: CalendarMonth(tasks: filteredTasks, switchToDailyView: switchToDailyView,),
            )

          ] else if (_dropdownValue == 'Setmanal') ...[
            Expanded(
              child: CalendarWeek(tasks: filteredTasks),
            )

          ] else if (_dropdownValue == 'Diari') ...[
            Expanded(
              child: CalendarDay(tasks: filteredTasks, selectedDate: _selectedDate),
            )
          ],

          SizedBox(
            height: 70,
            child: Stack(
              children: [
                
                //botó dels filtres
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FiltersOverlay();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCDE7FF),
                      elevation: 0,
                      foregroundColor: const Color(0xFF506EA4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Color(0xFF506EA4), width: 2),
                      ),
                    ),

                    child: const Text('FILTRES', style: TextStyle(fontSize: 18)),
                  ),
                ),
            
                //botó per afegir
                Positioned(
                  right: 10,
                  bottom: 5,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return OverlaySubjectTask();
                          },
                        );
                      },
                    backgroundColor: const Color(0xFF506EA4),
                    elevation: 0,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}