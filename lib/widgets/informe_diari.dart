import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:placker/services/services.dart';
import 'package:placker/models/models.dart';
import 'package:placker/widgets/widgets.dart';


//mostrar l'informe i els gràfics diaris
class InformeDiari extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<TasksService>(
              builder: (context, tasksService, child) {
            
                //per obtenir tots els dies
                final allDays = tasksService.getAllDays();

                //perquè es mostri el dia actual per defecte
                final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
                
                final indexToday = allDays.indexOf(today);
                final controller = PageController(initialPage: indexToday);
            
                return SizedBox(
                  height: MediaQuery.of(context).size.height,

                  //per veure cada dia a una pàgina
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: controller,
                        itemCount: allDays.length,
                        itemBuilder: (context, index) {
                          String day = allDays[index];
                      
                          //per obtenir totes les tasques en un dia
                          List<Task> tasksForDay = tasksService.getTasksForDay(day);
                                      
                          int tempsTotalFinal = 0;
                          int tempsFocusFinal = 0;
                          int tempsPausaFinal = 0;
                          int taskDurationFinal = 0;
                      
                          tasksForDay.forEach((task) {  
                            int tempsTotalDecimal = convertStringToTime(task.tempsTotal ?? '');
                            int tempsFocusDecimal = convertStringToTime(task.tempsFocus ?? '');
                            int tempsPausaDecimal = convertStringToTime(task.tempsPausa ?? '');
                            String taskDurationString = calculateTaskDuration(task);
                            int taskDurationInt = convertStringToTime(taskDurationString);
                           
                            tempsTotalFinal += tempsTotalDecimal;
                            tempsFocusFinal += tempsFocusDecimal;
                            tempsPausaFinal += tempsPausaDecimal;
                            taskDurationFinal += taskDurationInt;
                          });
                      
                          //es mostra per pantalla el total        
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(day, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
                                  const SizedBox(height: 15),
                                  Text('Temps total de les tasques: ${convertTimeToString(taskDurationFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps total invertit: ${convertTimeToString(tempsTotalFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps de focus: ${convertTimeToString(tempsFocusFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps de pausa: ${convertTimeToString(tempsPausaFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  
                                  const SizedBox(height: 30),
                              
                                  TaskGraphicDiari(
                                    convertTimeToDecimal(convertTimeToString(taskDurationFinal)),
                                    convertTimeToDecimal(convertTimeToString(tempsTotalFinal)),
                                    convertTimeToDecimal(convertTimeToString(tempsFocusFinal)),
                                    convertTimeToDecimal(convertTimeToString(tempsPausaFinal)),
                                  ),
                              
                                  const SizedBox(height: 10),
                                  
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      Positioned(
                        left: 1,
                        top: MediaQuery.of(context).size.height / 2 - 20,
                        child: GestureDetector(
                          onTap: () {
                            if (controller.page! > 0) {
                              controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }
                          },
                          child: Icon(Icons.arrow_left_rounded, size: 50, color: Colors.grey.shade300),
                        ),
                      ),

                      Positioned(
                        right: 1,
                        top: MediaQuery.of(context).size.height / 2 - 20,
                        child: GestureDetector(
                          onTap: () {
                            if (controller.page! < allDays.length - 1) {
                              controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }
                          },
                          child: Icon(Icons.arrow_right_rounded, size: 50, color: Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

  class TaskGraphicDiari extends StatelessWidget {

  final double decimalTaskDuration;
  final double decimalTotalInverted;
  final double decimalFocusInverted;
  final double decimalPausaInverted;

  TaskGraphicDiari(this.decimalTaskDuration, this.decimalTotalInverted, this.decimalFocusInverted, this.decimalPausaInverted);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 100,
        height: 350,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            
            //el màxim al que arriba és la duració de la suma de tasques
            maxY: decimalTaskDuration,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                )
              ),   
              topTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                )
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                )
              ),

              //per mostrar els valors a l'eix
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    if (value > 0.001 && value != decimalTaskDuration) {
                      return Text(
                        '${value.toStringAsFixed(1)} h',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      );
                    }
                    else {
                      return const Text('');
                    }
                  },
                  interval: 0.49999999,
                  reservedSize: 50,
                ),
              ),
            ),
            gridData: const FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 0.49999999,
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: decimalTaskDuration,
                    color: Colors.white,
                    width: 70,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                    borderSide: const BorderSide(width: 3, color: Color(0xff506EA4)),
                    rodStackItems: [

                      //blau fosc pel temps de focus
                      BarChartRodStackItem(0, decimalFocusInverted, const Color(0xff506EA4)),
                      
                      //blau clar pel temps de pausa
                      BarChartRodStackItem(decimalFocusInverted, decimalFocusInverted + decimalPausaInverted, const Color(0xFF96BDEC)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}