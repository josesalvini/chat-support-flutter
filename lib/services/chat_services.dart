import 'dart:developer';

import 'package:chat_support/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_support/global/environment.dart';
import 'package:chat_support/models/usuario.dart';
import 'package:chat_support/services/auth_service.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioTo;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    try {
      final token = await AuthService.getToken() ?? 'xx2599';
      final Uri url =
          Uri.http(Environment.apiUrlBase, '/api/mensaje/$usuarioId');

      //print('Request to: ${url.toString()}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      final mensajesResponse = mensajesResponseFromJson(response.body);
      return mensajesResponse.mensajes;
    } catch (e) {
      return [];
    }
  }
}
