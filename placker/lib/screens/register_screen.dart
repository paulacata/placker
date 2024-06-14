import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:placker/models/models.dart';
import 'package:placker/widgets/widgets.dart';
import 'package:placker/screens/screens.dart';
import 'package:placker/services/services.dart';
import 'package:provider/provider.dart';


//pantalla principal del registre
class RegisterScreen extends StatefulWidget {

  final Task? task;

  const RegisterScreen({Key? key, this.task}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  late TimerController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = TimerController(setState, context);
  }

  String dateTimeToDayString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String dateTimeToHourString(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {

    String? taskDurationString;
    final tasksService = Provider.of<TasksService>(context);

    String resultTotal;
    String resultFocus;
    String resultPausa;
    
    //calcula la duració de la tasca en cas que hi hagi una tasca
    if (widget.task != null) {
      taskDurationString = calculateTaskDuration(widget.task!);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //creu a dalt a la dreta per tornar a la pantalla anterior si ve d'una tasca
              if (widget.task != null)
                
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
        
              const SizedBox(height: 5),

              if (widget.task == null) 
                const SizedBox(height: 65),

              if (widget.task != null)
                TaskDefinitionRegister(task: widget.task!),
                const SizedBox(height: 30),

              //botó per editar el temps passant els paràmetres corresponents
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditTimeRegisterScreen(
                    sessions: _timerController.sessions,
                    tempsFocus: _timerController.tempsFocus,
                    tempsPausa: _timerController.tempsPausa,
                    timerController: _timerController,
                    updateRemainingTime: (int newRemainingTime) {
                      setState(() {
                        _timerController.remainingTime = newRemainingTime;
                      });
                    }, 
                  )));

                  if (result != null) {
                    setState(() {
                      _timerController.sessions = result['sessions'];
                      _timerController.tempsFocus = result['tempsFocus'];
                      _timerController.tempsPausa = result['tempsPausa'];
                    });
                  }
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

                child: const Text('EDITAR TEMPS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 5),

              //botó per visualitzar l'informe d'aquell registre 
              ElevatedButton(
                onPressed: () {
                  
                  int totalInverted = _timerController.totalInvertedTime + _timerController.currentInvertedTime;
                  int focusInverted = _timerController.totalFocusInvertedTime + _timerController.currentFocusInvertedTime;
                  int pausaInverted = totalInverted - focusInverted;

                  if (widget.task != null) {
                    int sumaTempsTotal = convertStringToTime(widget.task!.tempsTotal ?? '') + totalInverted;
                    resultTotal = convertTimeToString(sumaTempsTotal);

                    int sumaTempsFocus = convertStringToTime(widget.task!.tempsFocus ?? '') + focusInverted;
                    resultFocus = convertTimeToString(sumaTempsFocus);

                    int sumaTempsPausa = convertStringToTime(widget.task!.tempsPausa ?? '') + pausaInverted;
                    resultPausa = convertTimeToString(sumaTempsPausa);
                  }

                  else {
                    resultTotal = convertTimeToString(totalInverted);
                    resultFocus = convertTimeToString(focusInverted);
                    resultPausa = convertTimeToString(pausaInverted);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformeTascaScreen(
                        totalInverted: resultTotal,
                        focusInverted: resultFocus,
                        pausaInverted: resultPausa,
                        taskDuration: taskDurationString,
                        task: widget.task,
                        timerController: _timerController,
                      ),
                    ),
                  );
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

                child: const Text('VISUALITZAR INFORME', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 30),

              //cronòmetre
              CircularPercentIndicator(
                radius: 100,
                lineWidth: 12,
                percent: _timerController.getPercentage(),
                circularStrokeCap: CircularStrokeCap.round,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _timerController.statusText,
                      style: const TextStyle(fontSize: 20, color: Color(0xff506EA4), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      secondsToStringPercent(_timerController.remainingTime),
                      style: const TextStyle(fontSize: 40, color: Color(0xff506EA4)),
                    ),
                  ],
                ),
                progressColor: const Color(0xff506EA4),
              ),
        
              const SizedBox(height: 15),

              //icones per mostrar les sessions realitzades i per fer
              SessionsIcons(sessions: _timerController.sessions, sessionsRealitzades: _timerController.sessioActual + 1),
        
              const SizedBox(height: 20),
              
              //botons de play, pause i stop
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _timerController.isSessionRunning ? null : _timerController.startButtonPressed,
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 45,
                      color: _timerController.isSessionRunning ? Colors.grey : Colors.grey,
                    ),
                  ),
              
                  IconButton(
                    onPressed: _timerController.isSessionPaused ? null : _timerController.pauseButtonPressed,
                    icon: Icon(
                      Icons.pause_rounded,
                      size: 45,
                      color: _timerController.isSessionPaused ? Colors.grey : Colors.grey, 
                    ),
                  ),
              
                  IconButton(
                    onPressed: _timerController.stopButtonPressed,
                    icon: const Icon(Icons.stop_rounded, size: 45, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              //botó per guardar el registre
              ElevatedButton(
                onPressed: () {

                  int totalInverted = _timerController.totalInvertedTime + _timerController.currentInvertedTime;
                  int focusInverted = _timerController.totalFocusInvertedTime + _timerController.currentFocusInvertedTime;
                  int pausaInverted = totalInverted - focusInverted;

                  //si ve d'una tasca, es mostra una pantalla indicant que s'ha guardat correctament
                  if (widget.task != null) {
                    int sumaTempsTotal = convertStringToTime(widget.task!.tempsTotal ?? '') + totalInverted;
                    resultTotal = convertTimeToString(sumaTempsTotal);

                    int sumaTempsFocus = convertStringToTime(widget.task!.tempsFocus ?? '') + focusInverted;
                    resultFocus = convertTimeToString(sumaTempsFocus);

                    int sumaTempsPausa = convertStringToTime(widget.task!.tempsPausa ?? '') + pausaInverted;
                    resultPausa = convertTimeToString(sumaTempsPausa);

                    TasksService().updateTaskRegister(widget.task!, resultTotal, resultFocus, resultPausa);
                  
                    _timerController.resetCountdown();
 
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {

                        return AlertDialog(
                          backgroundColor: Colors.white, 

                          title: const Center(
                            child: Text(
                              'REGISTRE GUARDAT CORRECTAMENT',
                              style: TextStyle(
                                color: Color(0xff506EA4),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          actionsAlignment: MainAxisAlignment.center,
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFCDE7FF),
                                side: const BorderSide(color: Color(0xff506EA4), width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                              ),
                              child: const Text(
                                'Tancar',
                                style: TextStyle(color: Color(0xff506EA4), fontSize: 17, fontWeight: FontWeight.normal),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ]
                        );
                      }
                    );
                  }

                  //si no ve d'una tasca, es mostra una pantalla per guardar-ho a una tasca
                  else {
                    resultTotal = convertTimeToString(totalInverted);
                    resultFocus = convertTimeToString(focusInverted);
                    resultPausa = convertTimeToString(pausaInverted);

                    tasksService.selectedTask = Task(
                      subject: '',
                      tasca: '',
                      dia: dateTimeToDayString(DateTime.now()),
                      horaStart: dateTimeToHourString(DateTime.now()),
                      horaEnd: dateTimeToHourString(DateTime.now().add(const Duration(hours: 1))),
                      recurrent: false,
                      etiqueta: '',
                      color: '0xff506EA4',
                      prioritat: '',
                      tempsTotal: resultTotal,
                      tempsFocus: resultFocus,
                      tempsPausa: resultPausa,
                    );
                    _timerController.resetCountdown(); 
                    Navigator.pushNamed(context, 'AddTask');
                  }
                },
              
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff506EA4),
                  elevation: 0,
                  foregroundColor: Colors.white,
                ),

                child: const Text('GUARDAR REGISTRE', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 10),

            ]
          ),
        ),
      ),
    );
  }

  String secondsToStringPercent (int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds - (minutes * 60);
    String finalMinutes = minutes < 10 ? '0$minutes' : minutes.toString();
    String finalRemainingSeconds = remainingSeconds < 10 ? '0$remainingSeconds' : remainingSeconds.toString();
    return '$finalMinutes:$finalRemainingSeconds';
  }
}
