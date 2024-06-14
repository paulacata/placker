import 'dart:convert';


//classe per definir la prioritat
class Prioritat {
  Prioritat({
    this.id,
    this.nom,
    this.color,
  });
    
  String? nom;
  String? color;
  String? id;

  factory Prioritat.fromJson(String str) => Prioritat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Prioritat.fromMap(Map<String, dynamic> json) => Prioritat(
    id: json["id"],
    nom: json["nom"],
    color: json["color"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nom": nom,
    "color": color,
  };

  Prioritat copy() => Prioritat(
    id: this.id,
    nom: this.nom,
    color: this.color,
  );
}