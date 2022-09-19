import 'dart:developer';

import 'package:chat_support/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_support/models/usuario.dart';
import 'package:chat_support/services/auth_service.dart';
import 'package:chat_support/services/socket_service.dart';
import 'package:chat_support/services/usuarios_service.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuariosService = UsuariosService();
  late List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(usuario.nombre, style: const TextStyle(color: Colors.black54)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () async {
            final result = await AuthService.deleteToken();
            if (!mounted) return;
            if (result) {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
            }
          },
          icon: const Icon(Icons.exit_to_app, color: Colors.black54),
        ),
        actions: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                children: <Widget>[
                  (socketService.serverStatus == ServerStatus.onLine)
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.offline_bolt, color: Colors.redAccent),
                ],
              ))
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () => _cargarUsuarios(),
        header: WaterDropHeader(
          complete: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          waterDropColor: Colors.blue[400]!,
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => _usuarioListTile(usuarios[index]),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: usuarios.length);
  }

  Widget _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          usuario.nombre.substring(0, 2),
          style: const TextStyle(color: Colors.black54),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[400] : Colors.red[400],
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
      onTap: (() {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioTo = usuario;
        Navigator.pushNamed(context, 'chat');
      }),
    );
  }

  void _cargarUsuarios() async {
    try {
      usuarios = await usuariosService.getUsuarios();
      setState(() {});
      _refreshController.refreshCompleted();
    } catch (e) {
      // Si falla se usa refreshFailed()
      _refreshController.refreshFailed();
    }
  }
}
