import 'package:chat_support/pages/chat_page.dart';
import 'package:chat_support/pages/loading_page.dart';
import 'package:chat_support/pages/login_page.dart';
import 'package:chat_support/pages/register_page.dart';
import 'package:chat_support/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => const UsuariosPage(),
  'chat': (_) => const ChatPage(),
  'login': (_) => const LoginPage(),
  'register': (_) => const RegisterPage(),
  'loading': (_) => const LoadingPage(),
};
