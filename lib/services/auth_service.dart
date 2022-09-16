import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_support/global/environment.dart';
import 'package:chat_support/models/login_response.dart';
import 'package:chat_support/models/usuario.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;
  bool _registrando = false;
  // Create storage
  //final _storage = const FlutterSecureStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool get autenticando => _autenticando;
  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  bool get registrando => _registrando;
  set registrando(bool value) {
    _registrando = value;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    // Obtener el token almacenado
    final SharedPreferences prefsToken = await prefs;
    final token = prefsToken.getString('token');
    return token;
  }

  static Future<bool> deleteToken() async {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    // Obtener el token almacenado
    final SharedPreferences prefsToken = await prefs;
    return await prefsToken.remove('token');
  }

  Future login(String email, String password) async {
    //Set para cambiar el estado y notificar.
    autenticando = true;

    final data = {
      'email': email,
      'password': password,
    };

    final Uri url = Uri.http(Environment.apiUrlBase, '/api/login');
    //log('Request to: ${url.toString()}');

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    //Set para cambiar el estado y notificar.
    autenticando = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      usuario = loginResponse.usuario;
      //log('Usuario login: ${usuario.nombre}');
      //log('Token: ${loginResponse.token}');
      try {
        await saveToken(loginResponse.token);
        return true;
      } catch (e) {
        log(e.toString());
        return e.toString();
      }
    } else {
      log(response.body);
      final respError = jsonDecode(response.body);
      return respError['msg'];
    }
  }

  Future register(String nombre, String email, String password) async {
    registrando = true;
    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };

    final Uri url = Uri.http(Environment.apiUrlBase, '/api/login/register');
    //log('Request to: ${url.toString()}');

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    //Set para cambiar el estado y notificar.
    registrando = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      usuario = loginResponse.usuario;
      try {
        await saveToken(loginResponse.token);
        return true;
      } catch (e) {
        log(e.toString());
        return e.toString();
      }
    } else {
      log(response.body);
      final respError = jsonDecode(response.body);
      return respError['msg'];
    }
  }

  Future<bool> saveToken(String token) async {
    // Guardar el token
    final SharedPreferences prefs = await _prefs;
    return await prefs
        .setString('token', token)
        .then((value) => true)
        .catchError((err) {
      log('Error: $err');
    });
  }

  Future<bool> logout() async {
    // Borrar el token cuando se cierra la sesion
    //final success = await prefs.remove('counter');
    final SharedPreferences prefs = await _prefs;
    return await prefs.remove('token').then((value) => true).catchError((err) {
      log('Error: $err');
    });
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    // Obtener el token almacenado
    final token = prefs.getString('token') ?? 'xx2599';
    //log('Token actual: $token');
    final Uri url = Uri.http(Environment.apiUrlBase, '/api/login/renew');
    //log('Request to: ${url.toString()}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      usuario = loginResponse.usuario;
      try {
        await saveToken(loginResponse.token);
        log('Token nuevo: ${loginResponse.token}');
        return true;
      } catch (e) {
        log(e.toString());
        return false;
      }
    } else {
      log(response.body);
      return false;
    }
  }

/*
  Future<void> saveToken(String token) async {
    // Guardar el token
    return await _storage.write(
      key: 'token',
      value: token,
    );
  }

  Future logout() async {
    // Borrar el token cuando se cierra la sesion
    await _storage.delete(key: 'token');
  }

  
    static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    // Obtener el token almacenado
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    // Obtener el token almacenado
    await storage.delete(key: 'token');
  }
  */
}
