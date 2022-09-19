import 'package:chat_support/models/usuarios_response.dart';
import 'package:http/http.dart' as http;
import 'package:chat_support/global/environment.dart';
import 'package:chat_support/models/usuario.dart';
import 'package:chat_support/services/auth_service.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final token = await AuthService.getToken() ?? 'xx2599';
      final Uri url = Uri.http(Environment.apiUrlBase, '/api/usuario');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      final usuariosResponse = usuariosListFromJson(response.body);
      return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }
  }
}
