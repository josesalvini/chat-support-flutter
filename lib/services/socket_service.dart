import 'package:chat_support/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:chat_support/global/environment.dart';
import 'dart:developer';

enum ServerStatus { onLine, offLine, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  io.Socket get socket => _socket;

  //publicar la funcion emit
  Function get emit => _socket.emit;
  Function get on => _socket.on;

  void connect() async {
    final token = await AuthService.getToken();

    Map<String, dynamic> headers = {'x-token': token};

    // Dart client
    final Uri url = Uri.http(Environment.apiUrlBase);
    try {
      log('Conectando socket a: ${url.toString()}');
      _socket = io.io(
          url.toString(),
          OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .enableAutoConnect()
              .enableForceNew()
              .setExtraHeaders(headers)
              .build());

      _socket.onConnect((data) {
        log('onConnect ${_socket.id}');
        _serverStatus = ServerStatus.onLine;
        notifyListeners();
      });

      _socket.onDisconnect((_) {
        log('onDisconnect ${_socket.id}');
        _serverStatus = ServerStatus.offLine;
        notifyListeners();
      });

      _socket.on('connect_error', (data) {
        log('connect_error ${data.toString()}');
      });
    } catch (e) {
      log('Exception: ${e.toString()}');
    }
  }

  void disconnect() {
    log('Desconectando del socket');
    _socket.disconnect();
  }
}
