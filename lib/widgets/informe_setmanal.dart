import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:placker/services/services.dart';
import 'package:placker/models/models.dart';
import 'package:placker/widgets/widgets.dart';


//mostrar l'informe i els gràfics setmanals
class InformeSetmanal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<TasksService>(
              builder: (context, tasksService, child) {
            
                //per obtenir totes les setmanes
                final allWeeks = tasksService.getAllWeeks();

                //perquè es mostri la setmana actual per defecte
                final now = DateTime.now();
                final currentWeekIndex = allWeeks.indexWhere((week) {
                  final startDate = DateFormat('dd-MM-yyyy').parse(week);
                  final endDate = startDate.add(const Duration(days: 6));
                  return now.isAfter(startDate.subtract(const Duration(days: 1))) && now.isBefore(endDate.add(const Duration(days: 1)));});
                
                final initialPage = currentWeekIndex != -1 ? currentWeekIndex : 0;
                final controller = PageController(initialPage: initialPage);
            
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  
                  //per veure cada setmana a una pàgina
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: controller,
                        itemCount: allWeeks.length,
                        itemBuilder: (context, index) {
                          String startOfWeek = allWeeks[index];
                      
                          //per obtenir totes les tasques
                          List<Task> tasksForWeek = tasksService.getTasksForWeek(startOfWeek);
                                      
                          int tempsTotalFinal = 0;
                          int tempsFocusFinal = 0;
                          int tempsPausaFinal = 0;
                          int taskDurationFinal = 0;
                                  
                          List<double> dailyTaskDurations = List.filled(7, 0);
                          List<double> dailyTotalTimes = List.filled(7, 0);
                          List<double> dailyFocusTimes = List.filled(7, 0);
                          List<double> dailyPauseTimes = List.filled(7, 0);
                          List<String> dailyLabels = List.generate(7, (i) => 
                            DateFormat('dd-MM').format(DateFormat('dd-MM-yyyy').parse(startOfWeek).add(Duration(days: i)))
                          );
                                      
                          tasksForWeek.forEach((task) {
                            int tempsTotalDecimal = convertStringToTime(task.tempsTotal ?? '00:00:00');
                            int tempsFocusDecimal = convertStringToTime(task.tempsFocus ?? '00:00:00');
                            int tempsPausaDecimal = convertStringToTime(task.tempsPausa ?? '00:00:00');
                            String taskDurationString = calculateTaskDuration(task);
                            int taskDurationInt = convertStringToTime(taskDurationString);
                           
                            tempsTotalFinal += tempsTotalDecimal;
                            tempsFocusFinal += tempsFocusDecimal;
                            tempsPausaFinal += tempsPausaDecimal;
                            taskDurationFinal += taskDurationInt;
                                  
                            String taskDay = DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(task.dia!));
                            int dayIndex = DateFormat('dd-MM-yyyy').parse(taskDay).difference(DateFormat('dd-MM-yyyy').parse(startOfWeek)).inDays;
                                  
                            dailyTotalTimes[dayIndex] += tempsTotalDecimal / 3600;
                            dailyFocusTimes[dayIndex] += tempsFocusDecimal / 3600;
                            dailyPauseTimes[dayIndex] += tempsPausaDecimal / 3600;
                            dailyTaskDurations[dayIndex] += taskDurationInt / 3600;
                          });
                                      
                          String endOfWeek = DateFormat('dd-MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(startOfWeek).add(const Duration(days: 6)));
                          
                          //es mostra per pantalla el total
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$startOfWeek - $endOfWeek', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
                                  const SizedBox(height: 15),
                                  Text('Temps total de les tasques: ${convertTimeToString(taskDurationFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps total invertit: ${convertTimeToString(tempsTotalFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps de focus: ${convertTimeToString(tempsFocusFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps de pausa: ${convertTimeToString(tempsPausaFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  
                                  const SizedBox(height: 30),
                                  
                                  TaskGraphicSetmanal(dailyTaskDurations, dailyTotalTimes, dailyFocusTimes, dailyPauseTimes, dailyLabels),
                                  
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
                            if (controller.page! < allWeeks.length - 1) {
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

class TaskGraphicSetmanal extends StatelessWidget {
  
  final List<double> taskDurations;
  final List<double> totalTimes;
  final List<double> focusTimes;
  final List<double> pauseTimes;
  final List<String> dayLabels;

  TaskGraphicSetmanal(this.taskDurations, this.totalTimes, this.focusTimes, this.pauseTimes, this.dayLabels);

  @override
  Widget build(BuildContext context) {

    double maxY = taskDurations.reduce((a, b) => a > b ? a : b);
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        height: 350,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            
            //el màxim al que arriba és la duració de la suma de tasques
            maxY: maxY,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final text = dayLabels[value.toInt()];
                    
                    //es mostren els valors inferiors inclinats
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Transform.rotate(
                        angle: -45 * (3.1415926535897932 / 180),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, right: 30),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  reservedSize: 40,
                ),
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
                    if (value > 0.001 && value != maxY) {
                      return Text(
                        '${value.toStringAsFixed(1)} h',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      );
                    } else {
                      return const Text('');
                    }
                  },
                  interval: 1,
                  reservedSize: 50,
                ),
              ),
            ),
            gridData: const FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(7, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: taskDurations[i],
                    color: Colors.white,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                    borderSide: const BorderSide(width: 3, color: Color(0xff506EA4)),
                    rodStackItems: [

                      //blau fosc pel temps de focus
                      BarChartRodStackItem(0, focusTimes[i], const Color(0xff506EA4)),
                      
                      //blau clar pel temps de pausa
                      BarChartRodStackItem(focusTimes[i], focusTimes[i] + pauseTimes[i], const Color(0xFF96BDEC)),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}