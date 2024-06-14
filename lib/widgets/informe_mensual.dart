import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:placker/services/services.dart';
import 'package:placker/models/models.dart';
import 'package:placker/widgets/widgets.dart';


//mostrar l'informe i els gràfics mensuals
class InformeMensual extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<TasksService>(
              builder: (context, tasksService, child) {
            
                //per obtenir tots els mesos
                final allMonths = tasksService.getAllMonths();

                //perquè es mostri el mes actual per defecte
                final now = DateTime.now();
                final currentMonthIndex = allMonths.indexWhere((month) {
                  final startDate = DateFormat('dd-MM-yyyy').parse(month);
                  return now.year == startDate.year && now.month == startDate.month;
                });

                final controller = PageController(initialPage: currentMonthIndex);
            
                return SizedBox(
                  height: MediaQuery.of(context).size.height,

                  //per veure cada mes a una pàgina
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: controller,
                        itemCount: allMonths.length,
                        itemBuilder: (context, index) {
                          String startOfMonth = allMonths[index];
                          
                          //per obtenir totes les tasques
                          List<Task> tasksForMonth = tasksService.getTasksForMonth(startOfMonth);
                                      
                          int tempsTotalFinal = 0;
                          int tempsFocusFinal = 0;
                          int tempsPausaFinal = 0;
                          int taskDurationFinal = 0;
                                  
                          Map<String, List<double>> weeklyTimes = {};
                          List<String> weeklyLabels = [];
                                                                        
                          DateTime startOfMonthDate = DateFormat('dd-MM-yyyy').parse(startOfMonth);
                          DateTime endOfMonthDate = DateTime(startOfMonthDate.year, startOfMonthDate.month + 1, 0);
                          DateTime firstMonday = startOfMonthDate.subtract(Duration(days: startOfMonthDate.weekday - 1));
                                      
                          for (DateTime date = firstMonday; date.isBefore(endOfMonthDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 7))) {
                            String weekStart = DateFormat('dd-MM-yyyy').format(date);
                            weeklyTimes[weekStart] = List.filled(4, 0.0);
                            weeklyLabels.add(weekStart);
                          }
                                      
                          tasksForMonth.forEach((task) {
                            int tempsTotalDecimal = convertStringToTime(task.tempsTotal ?? '00:00:00');
                            int tempsFocusDecimal = convertStringToTime(task.tempsFocus ?? '00:00:00');
                            int tempsPausaDecimal = convertStringToTime(task.tempsPausa ?? '00:00:00');
                            String taskDurationString = calculateTaskDuration(task);
                            int taskDurationInt = convertStringToTime(taskDurationString);
                                  
                            tempsTotalFinal += tempsTotalDecimal;
                            tempsFocusFinal += tempsFocusDecimal;
                            tempsPausaFinal += tempsPausaDecimal;
                            taskDurationFinal += taskDurationInt;
                                  
                            DateTime taskDate = DateFormat('yyyy-MM-dd').parse(task.dia!);
                            DateTime weekStartDate = taskDate.subtract(Duration(days: taskDate.weekday - 1));
                            String weekStart = DateFormat('dd-MM-yyyy').format(weekStartDate);
                                      
                            if (weeklyTimes.containsKey(weekStart)) {
                              weeklyTimes[weekStart]![0] += taskDurationInt / 3600;
                              weeklyTimes[weekStart]![1] += tempsTotalDecimal / 3600;
                              weeklyTimes[weekStart]![2] += tempsFocusDecimal / 3600;
                              weeklyTimes[weekStart]![3] += tempsPausaDecimal / 3600;
                            }
                          });
                                  
                          String endOfMonth = DateFormat('dd-MM-yyyy').format(endOfMonthDate);
                                  
                          //es mostra per pantalla el total
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('$startOfMonth - $endOfMonth', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
                                  const SizedBox(height: 15),
                                  Text('Temps total de les tasques: ${convertTimeToString(taskDurationFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps total invertit: ${convertTimeToString(tempsTotalFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps de focus: ${convertTimeToString(tempsFocusFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  Text('Temps de pausa: ${convertTimeToString(tempsPausaFinal)}', style: const TextStyle(color: Color(0xff506EA4), fontSize: 15)),
                                  
                                  const SizedBox(height: 30),
                                  
                                  TaskGraphicMensual(weeklyTimes, weeklyLabels),
                                  
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
                            if (controller.page! < allMonths.length - 1) {
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

class TaskGraphicMensual extends StatelessWidget {

  final Map<String, List<double>> weeklyTimes;
  final List<String> weekLabels;

  TaskGraphicMensual(this.weeklyTimes, this.weekLabels);

  @override
  Widget build(BuildContext context) {

    double maxY = weeklyTimes.values
        .map((times) => times[0])
        .reduce((a, b) => a > b ? a : b);

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
                    final start = DateFormat('dd-MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(weekLabels[value.toInt()]));
                    final end = DateFormat('dd-MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(weekLabels[value.toInt()]).add(Duration(days: 6)));
                    
                    //es mostren els valors inferiors inclinats
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Transform.rotate(
                        angle: -45 * (3.1415926535897932 / 180),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                start,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8,
                                ),
                              ),
                              Text(
                                end,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8,
                                ),
                              ),
                            ],
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
                  showTitles: false
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false
                ),
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
            barGroups: List.generate(weeklyTimes.length, (i) {
              final weekData = weeklyTimes[weekLabels[i]]!;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: weekData[0],
                    color: Colors.white,
                    width: 35,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                    borderSide: const BorderSide(width: 3, color: Color(0xff506EA4)),
                    rodStackItems: [

                      //blau fosc pel temps de focus
                      BarChartRodStackItem(0, weekData[2], const Color(0xff506EA4)),
                      
                      //blau clar pel temps de pausa
                      BarChartRodStackItem(weekData[2], weekData[2] + weekData[3], const Color(0xFF96BDEC)),
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