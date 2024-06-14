import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:placker/models/models.dart';
import 'package:placker/widgets/widgets.dart';


//pantalla que mostra l'informe de la tasca relacionada o l'informe del registre realitzat
class InformeTascaScreen extends StatelessWidget {

  final String totalInverted;
  final String focusInverted;
  final String pausaInverted;
  final String? taskDuration;
  final Task? task;
  final TimerController? timerController;

  InformeTascaScreen({
    Key? key,
    required this.totalInverted,
    required this.focusInverted,
    required this.pausaInverted,
    this.taskDuration,
    this.task,
    this.timerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //en cas que hi hagi tasca es mostra la tasca
                if (task != null)
                  TaskDefinitionRegister(task: task!),
        
                const SizedBox(height: 25),

                //en cas que hi hagi tasca es mostra la duració total de la tasca
                if (taskDuration != null)
                  Text('Temps total de la tasca: $taskDuration', style: const TextStyle(color: Colors.grey, fontSize: 18)),
                  
                Text('Temps total invertit: $totalInverted', style: const TextStyle(color: Colors.grey, fontSize: 18)),
                Text('Temps de focus: $focusInverted', style: const TextStyle(color: Colors.grey, fontSize: 18)),
                Text('Temps de pausa: $pausaInverted', style: const TextStyle(color: Colors.grey, fontSize: 18)),

                const SizedBox(height: 30),

                TaskGraphic(
                  taskDuration != null ? convertTimeToDecimal(taskDuration!) : convertTimeToDecimal(totalInverted),
                  convertTimeToDecimal(totalInverted),
                  convertTimeToDecimal(focusInverted),
                  convertTimeToDecimal(pausaInverted),
                ),
            
              const SizedBox(height: 30),

              //botó per anar a tots els registres
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'TotsInformes');
                    },
              
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF96BDEC), width: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  foregroundColor: const Color(0xFF96BDEC),
                  minimumSize: const Size(250, 40),
                ),

                child: const Text('TOTS ELS INFORMES', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 10),

              ],
            ),
          ]
        ),
      ),
    );
  }
}

class TaskGraphic extends StatelessWidget {

  final double decimalTaskDuration;
  final double decimalTotalInverted;
  final double decimalFocusInverted;
  final double decimalPausaInverted;

  TaskGraphic(this.decimalTaskDuration, this.decimalTotalInverted, this.decimalFocusInverted, this.decimalPausaInverted);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 100,
        height: 270,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,

            //el màxim al que arriba és la duració de la tasca
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
                  interval: 0.2,
                  reservedSize: 50,
                ),
              ),
            ),
            gridData: const FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 0.2,
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