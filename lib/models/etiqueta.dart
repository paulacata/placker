import 'dart:convert';


//classe per definir l'etiqueta
class Etiqueta {
  Etiqueta({
    this.id,
    this.nom,
  });
    
  String? nom;
  String? id;

  factory Etiqueta.fromJson(String str) => Etiqueta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Etiqueta.fromMap(Map<String, dynamic> json) => Etiqueta(
    id: json["id"],
    nom: json["nom"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nom": nom,
  };

  Etiqueta copy() => Etiqueta(
    id: this.id,
    nom: this.nom,
  );
}