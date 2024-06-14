import 'dart:convert';


//classe per definir l'assignatura
class Subject {
  Subject({
    this.id,
    this.assignatura,
    this.color,
    this.objectius,
  });
    
  String? id;
  String? assignatura;
  String? color;
  String? objectius;

  factory Subject.fromJson(String str) => Subject.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
    id: json["id"],
    assignatura: json["assignatura"],
    color: json["color"],
    objectius: json["objectius"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "assignatura": assignatura,
    "color": color,
    "objectius": objectius,
  };

  Subject copy() => Subject(
    id: this.id,
    assignatura: this.assignatura,
    color: this.color,
    objectius: this.objectius,
  );
}