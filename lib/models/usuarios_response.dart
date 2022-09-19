// To parse this JSON data, do
//
//     final usuariosList = usuariosListFromJson(jsonString);

import 'dart:convert';
import 'package:chat_support/models/usuario.dart';

UsuariosList usuariosListFromJson(String str) =>
    UsuariosList.fromJson(json.decode(str));

String usuariosListToJson(UsuariosList data) => json.encode(data.toJson());

class UsuariosList {
  UsuariosList({
    required this.ok,
    required this.usuarios,
  });

  bool ok;
  List<Usuario> usuarios;

  factory UsuariosList.fromJson(Map<String, dynamic> json) => UsuariosList(
        ok: json["ok"],
        usuarios: List<Usuario>.from(
            json["usuarios"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}
