import 'dart:convert';


//classe per definir la tasca
class Task {
  Task({
    this.id,
    this.subject,
    this.tasca,
    this.dia,
    this.horaStart,
    this.horaEnd,
    this.recurrent,
    this.etiqueta,
    this.color,
    this.prioritat,
    this.tempsTotal,
    this.tempsFocus,
    this.tempsPausa,
    this.isDone,
  });
    
  String? subject;
  String? tasca;
  String? dia;
  String? horaStart;
  String? horaEnd;
  bool? recurrent;
  String? etiqueta;
  String? color;
  String? prioritat;
  String? id;
  String? tempsTotal;
  String? tempsFocus;
  String? tempsPausa;
  bool? isDone;

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json["id"],
    subject: json["subject"],
    tasca: json["tasca"],
    dia: json["dia"],
    horaStart: json["horaStart"],
    horaEnd: json["horaEnd"],
    recurrent: json["recurrent"],
    etiqueta: json["etiqueta"],
    color: json["color"],
    prioritat: json["prioritat"],
    tempsTotal: json["tempsTotal"],
    tempsFocus: json["tempsFocus"],
    tempsPausa: json["tempsPausa"],
    isDone: json["isDone"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "subject": subject,
    "tasca": tasca,
    "dia": dia,
    "horaStart": horaStart,
    "horaEnd": horaEnd,
    "recurrent": recurrent,
    "etiqueta": etiqueta,
    "color": color,
    "prioritat": prioritat,
    "tempsTotal": tempsTotal,
    "tempsFocus": tempsFocus,
    "tempsPausa": tempsPausa,
    "isDone": isDone,
  };

  Task copy() => Task(
    id: this.id,
    subject: this.subject,
    tasca: this.tasca,
    dia: this.dia,
    horaStart: this.horaStart,
    horaEnd: this.horaEnd,
    recurrent: this.recurrent,
    etiqueta: this.etiqueta,
    color: this.color,
    prioritat: this.prioritat,
    tempsTotal: this.tempsTotal,
    tempsFocus: this.tempsFocus,
    tempsPausa: this.tempsPausa,
    isDone: this.isDone,
  );
}