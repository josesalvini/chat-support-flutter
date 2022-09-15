import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_support/models/usuario.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(onLine: true, email: 'jose@gmail.com', nombre: 'José', uid: '1'),
    Usuario(onLine: false, email: 'juan@gmail.com', nombre: 'Juan', uid: '2'),
    Usuario(onLine: true, email: 'pedro@gmail.com', nombre: 'Pedro', uid: '3')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuario', style: TextStyle(color: Colors.black54)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.exit_to_app, color: Colors.black54),
        ),
        actions: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                children: const <Widget>[
                  Icon(Icons.check_circle, color: Colors.green),
                  Icon(Icons.offline_bolt, color: Colors.redAccent),
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
          color: usuario.onLine ? Colors.green[400] : Colors.red[400],
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }

  void _cargarUsuarios() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
