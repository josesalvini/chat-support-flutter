import 'dart:io';

class Environment {
  static String apiUrlBase = Platform.isAndroid
      ? '192.168.100.4:3000'
      : 'localhost:3000';

}
