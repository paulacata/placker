import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:placker/services/services.dart';
import 'package:placker/widgets/widgets.dart';


//pantalla principal del llistat
class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final tasksService = Provider.of<TasksService>(context);
    final subjectsService = Provider.of<SubjectsService>(context);
    final filtersService = Provider.of<FiltersService>(context);

    final filteredTasks = tasksService.tasks.where((task) {
      final matchesSubject = filtersService.selectedSubjects.isEmpty || filtersService.selectedSubjects.contains(task.subject);
      final matchesEtiqueta = filtersService.selectedEtiquetas.isEmpty || filtersService.selectedEtiquetas.contains(task.etiqueta);
      final matchesPrioritat = filtersService.selectedPrioritats.isEmpty || filtersService.selectedPrioritats.contains(task.prioritat);
      final matchesCompleted = filtersService.showCompletedTasks || task.isDone!;
      final matchesPending = filtersService.showPendingTasks || !task.isDone!;
      return matchesSubject && matchesEtiqueta && matchesPrioritat && matchesCompleted && matchesPending;
    }).toList();

    //per mostrar totes les assignatures
    return Column(
      children: [
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
            itemCount: subjectsService.subjects.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < subjectsService.subjects.length) {
                final subject = subjectsService.subjects[index];
                final relatedTasks = filteredTasks.where((task) => task.subject == subject.assignatura).toList();
                final subjectColor = Color(int.tryParse(subject.color!) ?? 0xFF506EA4);

                //rectangle
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: subjectColor,
                        width: 3,
                      ),
                    ),
                    
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Expanded(
                                
                                //noms de les assignatures
                                child: GestureDetector(
                                  onTap: () {
                                    subjectsService.selectedSubject = subjectsService.subjects[index].copy();
                                    
                                    //al prémer sobre l'assignatura, s'obre un pop up per editar o eliminar
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return OverlayEditSubject(subject: subject);
                                      },
                                    );
                                  },

                                  child: Text(
                                    subject.assignatura!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: subjectColor
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 15),

                              //botó d'objectius
                              Container(
                                decoration: BoxDecoration(
                                  color: subjectColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  child: GestureDetector(
                                    onTap: () {
                                      subjectsService.selectedSubject = subjectsService.subjects[index].copy();
                                      Navigator.pushNamed(context, 'ViewObjectives');
                                    },
                                    child: const Text(
                                      'OBJECTIUS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //línea per dividir assignatura de tasca
                        if (relatedTasks.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: Divider(
                              color: subjectColor,
                              thickness: 3,
                            ),
                          ),

                          //per cada assignatura, les tasques associades
                          ...relatedTasks.map((task) {
                          final originalIndex = tasksService.tasks.indexOf(task);
                          return GestureDetector(
                            onTap: () {
                              tasksService.selectedTask = tasksService.tasks[originalIndex].copy();
                              
                              //al prémer sobre la tasca, s'obre un pop up per editar o eliminar
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return OverlayEditTask(task: task);
                                },
                              );
                            },
                            child: Row(
                              children: [
                                if (task.isDone ?? false)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF506EA4),
                                    ),
                                  ),
                                Expanded(child: ListItem(task: task)),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              }

              //si la tasca no té assignatura associada, es dibuixa a sota
              else {
                final tasksWithoutSubject = filteredTasks.where((task) => task.subject == null || task.subject!.isEmpty).toList();
                if (tasksWithoutSubject.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        ...tasksWithoutSubject.map((task) {
                          final originalIndex = tasksService.tasks.indexOf(task);
                          return GestureDetector(
                            onTap: () {
                              tasksService.selectedTask = tasksService.tasks[originalIndex].copy();

                              //al prémer sobre la tasca, s'obre un pop up per editar o eliminar
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return OverlayEditTask(task: task);
                                },
                              );
                            },
                            child: Row(
                              children: [
                                if (task.isDone == true)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF506EA4),
                                    ),
                                  ),
                                Expanded(child: ListItem(task: task)),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }
            },
          ),
        ),
        
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
    );
  }
}