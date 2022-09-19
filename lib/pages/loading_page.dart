import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_support/pages/login_page.dart';
import 'package:chat_support/pages/usuarios_page.dart';
import 'package:chat_support/services/auth_service.dart';
import 'package:chat_support/services/socket_service.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Cargando....'),
          );
        },
      ),
    );
  }

  //Opcion para un widget StatelessWidget
  //Future checkLoginState(BuildContext context, [bool mounted = true]) async {
  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);
    final autenticado = await authService.isLoggedIn();
    if (!mounted) return;
    //log('$autenticado');
    if (autenticado) {
      //Conectar al socket server
      socketService.connect();
      //Navegar a la pagina deseada
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              const UsuariosPage(),
          transitionDuration: const Duration(microseconds: 0),
        ),
      );
    } else {
      //Navegar al login
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              const LoginPage(),
          transitionDuration: const Duration(microseconds: 0),
        ),
      );
    }
  }
}
