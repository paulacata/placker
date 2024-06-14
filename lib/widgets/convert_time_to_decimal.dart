//per convertir de string a temps en decimal pel cronòmetre
double convertTimeToDecimal(String temps) {
  List<String> parts = temps.split(':');
  int hores = int.parse(parts[0]);
  int minuts = int.parse(parts[1]);
  int segons = int.parse(parts[2]);

  double tempsDecimal = hores + (minuts / 60) + (segons / 3600);
  return tempsDecimal;
}