import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

//aquest codi ha estat adaptat del curs Legacy – Flutter: Tu guia completa para IOS y Android de Fernando Herrera https://www.udemy.com/course/flutter-ios-android-fernando-herrera/

//peticions http per l'autenticació de log in i sign up amb Firebase 
class AuthService extends ChangeNotifier {

  //base a la qual es fa la petició http
  final String _baseURL = 'identitytoolkit.googleapis.com';
  
  //token d'accés a l'API de Firebase
  final String _firebaseToken = 'AIzaSyCLbisUgquirANDlxHPtJ-txx6CQhXLVwc';

  //creació de la instància del storage
  final storage = new FlutterSecureStorage();

  //pel registre d'un nou usuari
  Future<String?> createUser(String email, String password) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    //construir la url per la sol·licitud POST 
    final url = Uri.https(_baseURL, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    //sol·licitud http POST a la url construida, enviant les dades d'autenticació en format json
    final resp = await http.post(url, body: json.encode(authData));

    //decodificació de la resposta json en un mapa
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    //si el retorn conté el token, és un correu nou i s'ha de guardar el token 
    if (decodedResp.containsKey('idToken')){
      await storage.write(key: 'token', value: decodedResp['idToken']);
      await storage.write(key: 'uid', value: decodedResp['localId']); 
      return null;

    //si el retorn no conté el token, el correu ja existeix
    } else {
      return ('El correu ja existeix');
    }
  }

  //per iniciar sessió d'un usuari existent
  Future<String?> loginUser(String email, String password) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    //construir la url per la sol·licitud POST 
    final url = Uri.https(_baseURL, 'v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    //sol·licitud http POST a la url construida, enviant les dades d'autenticació en format json
    final resp = await http.post(url, body: json.encode(authData));

    //decodificació de la resposta json en un mapa
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    //si el retorn conté el token, el correu i contrasenya són correctes 
    if (decodedResp.containsKey('idToken')){
      //guardar el token
      await storage.write(key: 'token', value: decodedResp['idToken']);
      await storage.write(key: 'uid', value: decodedResp['localId']);
      return null;
    }

    //si el retorn no conté el token, el correu i contrasenya no són correctes
    else {
      return ('No es pot iniciar sessió, dades incorrectes');

    }
  }

  //per eliminar l'usuari del storage
  Future logoutUser() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'uid');
    return;
  }

  //si el token no existeix, retorna un string buit
  Future <String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  //per obtenir el uid de l'usuari
  Future<String> readUID() async {
    return await storage.read(key: 'uid') ?? '';
  }

  //per obtenir el correu de l'usuari concret
  Future<String> getUserEmail(String uid) async {
    final token = await readToken();
    final url = Uri.https(_baseURL, '/v1/accounts:lookup', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode({'idToken': token}));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('users')) {
      final users = decodedResp['users'] as List;
      final user = users.firstWhere((user) => user['localId'] == uid);
      return user['email'] ?? '';
    
    } else {
      return '';
    }
  }
}