import 'dart:async';
import 'package:flutter/material.dart';

import 'package:placker/widgets/widgets.dart';

//aquest codi ha estat adaptat del vídeo Pomodoro App From Scratch de Roberto Fernandes https://www.youtube.com/watch?v=pATGCf191to&list=PL-BjWplAXDCB2gH-R0tuM85RvuFWArZzL 

//serveix per gestionar tot el temps del registre
class TimerController {
  
  //dades per defecte en segons 
  int tempsFocus = 25*60;
  int tempsPausa = 5*60;
  int sessions = 4;

  late int remainingTime;
  TimeStatus timeStatus = TimeStatus.pausedFocus;
  String statusText = 'FOCUS';
  Timer? _timer;
  int focusNum = 0;
  int sessioActual = 0;

  int totalInvertedTime = 0;
  int currentInvertedTime = 0;
  int totalFocusInvertedTime = 0;
  int currentFocusInvertedTime = 0;

  bool get isSessionRunning => timeStatus == TimeStatus.runningFocus || timeStatus == TimeStatus.runningBreak;
  bool get isSessionPaused => timeStatus == TimeStatus.pausedFocus || timeStatus == TimeStatus.pausedBreak;
  bool get isSessionFinished => sessioActual >= sessions;

  Function(void Function()) setState;
  BuildContext context;

  TimerController(this.setState, this.context) {
    remainingTime = tempsFocus;
  }

  double getPercentage() {
    int totalTime;
    switch (timeStatus) {
      
      case TimeStatus.pausedFocus:
        totalTime = tempsFocus;
        break;
      case TimeStatus.runningFocus:
        totalTime = tempsFocus;
        break;
      case TimeStatus.pausedBreak:
        totalTime = tempsPausa;
        break;
      case TimeStatus.runningBreak:
        totalTime = tempsPausa;
        break;
      case TimeStatus.finished:
        totalTime = tempsFocus;
        break;
    }
    return (totalTime - remainingTime) / totalTime;
  }

  void startButtonPressed () {
    switch (timeStatus) {
      case TimeStatus.pausedFocus:
        startCountdown();
        break;
      case TimeStatus.runningFocus:
        pauseCountdown();
        break;
      case TimeStatus.pausedBreak:
        startCountdown();
        break;
      case TimeStatus.runningBreak:
        pauseCountdown();
        break;
      case TimeStatus.finished:
        resetCountdown();
        break;
    }
  }

  void startCountdown() {
    if (timeStatus == TimeStatus.pausedFocus || timeStatus == TimeStatus.pausedBreak) {
      timeStatus = timeStatus == TimeStatus.pausedFocus ? TimeStatus.runningFocus : TimeStatus.runningBreak;
      statusText = getStatusText(timeStatus);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {

          if (remainingTime > 0) {
            remainingTime--;
            if (timeStatus == TimeStatus.runningFocus) {
              currentFocusInvertedTime++;
            }
            currentInvertedTime++;

          } else {
            
            _timer?.cancel();
            
            if (timeStatus == TimeStatus.runningFocus) {
              focusNum++;
              totalInvertedTime += currentInvertedTime;
              currentInvertedTime = 0;
              totalFocusInvertedTime += currentFocusInvertedTime;
              currentFocusInvertedTime = 0;
              timeStatus = TimeStatus.pausedBreak;
              remainingTime = tempsPausa;
              RegisterPopup(context, 'TEMPS DE FOCUS ACABAT', 'Pausa');

            } else if (timeStatus == TimeStatus.runningBreak) {
              sessioActual++;

              if (sessioActual < sessions) {
                timeStatus = TimeStatus.pausedFocus;
                remainingTime = tempsFocus;
                RegisterPopup(context, 'TEMPS DE PAUSA ACABAT', 'Focus');

              } else {
                timeStatus = TimeStatus.finished;
                RegisterPopup(context, 'FINAL', 'Nou registre');
              }
            }
          }
          statusText = getStatusText(timeStatus);
        });
      });
    }
  }

  void pauseButtonPressed() {
    if (timeStatus == TimeStatus.runningFocus || timeStatus == TimeStatus.runningBreak) {
      pauseCountdown();
    }
  }

  void pauseCountdown() {
    setState(() {
      if (timeStatus == TimeStatus.runningFocus) {
        timeStatus = TimeStatus.pausedFocus;
      } else if (timeStatus == TimeStatus.runningBreak) {
        timeStatus = TimeStatus.pausedBreak;
      }
      _timer?.cancel();
      statusText = getStatusText(timeStatus);
    });
  }

  void stopButtonPressed() {
    setState(() {
      _timer?.cancel();
      timeStatus = TimeStatus.pausedFocus;
      remainingTime = tempsFocus;
      focusNum = 0;
      sessioActual = 0;
      statusText = getStatusText(timeStatus);
      totalInvertedTime = 0;
      currentInvertedTime = 0;
      totalFocusInvertedTime = 0;
      currentFocusInvertedTime = 0;
    });
  }

  void resetCountdown() {
    setState(() {
      timeStatus = TimeStatus.pausedFocus;
      remainingTime = tempsFocus;
      sessioActual = 0;
      focusNum = 0;
      statusText = getStatusText(timeStatus);
      totalInvertedTime = 0;
      currentInvertedTime = 0; 
      totalFocusInvertedTime = 0;
      currentFocusInvertedTime = 0;
    });
  }

  String getStatusText(TimeStatus status) {
    switch (status) {
      case TimeStatus.pausedFocus:
        return ('FOCUS');
      case TimeStatus.runningFocus:
        return ('FOCUS');
      case TimeStatus.pausedBreak:
        return ('PAUSA');
      case TimeStatus.runningBreak:
        return ('PAUSA');
      case TimeStatus.finished:
        return ('FINAL');
      default:
        return '';
    }
  }
}

//diferents estats del cronòmetre
enum TimeStatus {
  pausedFocus,
  runningFocus,
  pausedBreak,
  runningBreak,
  finished,
}