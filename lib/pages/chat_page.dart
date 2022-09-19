import 'dart:developer';
import 'dart:io';
import 'package:chat_support/models/mensajes_response.dart';
import 'package:chat_support/services/auth_service.dart';
import 'package:chat_support/services/chat_services.dart';
import 'package:chat_support/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_support/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _estaEscribiendo = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    _textController = TextEditingController();
    _focusNode = FocusNode();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMsg);
    _cargarHistorialMsg(chatService.usuarioTo.uid);

    super.initState();
  }

  void _cargarHistorialMsg(String uid) async {
    List<Mensaje> chat = await chatService.getChat(uid);
    //print('$chat');
    final historial = chat.map((m) => ChatMessage(
          mensaje: m.msg,
          uid: m.de,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 0),
          )..forward(),
        ));

    setState(() {
      _messages.insertAll(0, historial);
    });

  }

  void _escucharMsg(dynamic data) {
    log('Mensaje recibido!!! $data');
    ChatMessage message = ChatMessage(
      mensaje: data['msg'],
      uid: data['de'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    for (ChatMessage messages in _messages) {
      messages.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = chatService.usuarioTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[200],
              child: Text(usuario.nombre.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              usuario.nombre,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  reverse: true,
                  itemBuilder: (context, index) => _messages[index]),
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              height: 50,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  //Cuando hay un valor enviar mensaje
                  //_estaEscribiendo = value.isNotEmpty ? true : false;
                  setState(() {
                    _estaEscribiendo = value.isNotEmpty;
                  });
                },
                decoration:
                    const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                      child: const Text('Enviar'),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: const IconThemeData(color: Colors.blue),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: _estaEscribiendo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                          icon: const Icon(
                            Icons.send,
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;
    //log(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      mensaje: texto,
      uid: authService.usuario.uid,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    final msg = {
      'de': authService.usuario.uid,
      'para': chatService.usuarioTo.uid,
      'msg': texto
    };
    //log('Mensaje a enviar: $msg');

    socketService.emit('mensaje-personal', msg);
  }
}
