//per convertir de temps en segons a string
String convertTimeToString (int seconds) {
  int hours = seconds ~/ 3600;
  int remainingMinutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;
  String finalMinutes = remainingMinutes < 10 ? '0$remainingMinutes' : remainingMinutes.toString();
  String finalRemainingSeconds = remainingSeconds < 10 ? '0$remainingSeconds' : remainingSeconds.toString();
  return '$hours:$finalMinutes:$finalRemainingSeconds';
}