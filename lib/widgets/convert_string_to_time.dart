//per convertir de string a temps en segons
int convertStringToTime (String value) {
  if (value == '') {
    return 0;
  }
  List<String> parts = value.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);
  return (hours * 3600) + (minutes * 60) + seconds;
}