import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';

class NodeService {
  static const String _wsUrl = 'ws://localhost:18789/api/node';

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));

      _subscription = _channel!.stream.listen(
        (data) {
          final decoded = json.decode(data as String) as Map<String, dynamic>;
          _messageController.add(decoded);
        },
        onError: (error) {
          _messageController.addError(error);
        },
        onDone: () {
          disconnect();
        },
      );

      _sendHandshake();
    } catch (e) {
      throw Exception('Failed to connect to node: $e');
    }
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    _channel = null;
  }

  void _sendHandshake() {
    final handshake = {
      'type': 'handshake',
      'version': '1.0.0',
      'capabilities': ['camera', 'flash', 'location', 'screen', 'sensor', 'haptic'],
    };
    _channel?.sink.add(json.encode(handshake));
  }

  void sendCommand(String command, Map<String, dynamic> params) {
    final message = {
      'type': 'command',
      'command': command,
      'params': params,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    _channel?.sink.add(json.encode(message));
  }

  Future<bool> requestPermission(String permission) async {
    try {
      if (permission == 'Camera') {
        return await _requestCameraPermission();
      } else if (permission == 'Location') {
        return await _requestLocationPermission();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _requestCameraPermission() async {
    try {
      final result = await Process.run('pm', ['list', 'permissions']);
      return result.stdout.toString().contains('android.permission.CAMERA');
    } catch (e) {
      return false;
    }
  }

  Future<bool> _requestLocationPermission() async {
    try {
      final result = await Process.run('pm', ['list', 'permissions']);
      return result.stdout.toString().contains('android.permission.ACCESS_FINE_LOCATION');
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> invoke(String capability, String command, Map<String, dynamic> params) async {
    try {
      sendCommand('$capability.$command', params);

      final response = await messages.first.timeout(
        const Duration(seconds: 10),
        onTimeout: () => <String, dynamic>{'error': 'Timeout'},
      );

      return response;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
