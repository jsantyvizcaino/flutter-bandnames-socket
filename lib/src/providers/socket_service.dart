import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService extends ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io('http://192.168.100.58:3000', {
      "transports": ['websocket'],
      "autoConnect": true
    });

    // socket.onConnect((_) => print('connect'));
    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo mensaje:');
    //   print('nombre: ' + payload['nombre']);
    //   print('mensaje' + payload['mensje']);
    //   //print(payload.containsKey('mensaje2') ? payload['mensje2'] : 'no hay');
    // });
  }
}
