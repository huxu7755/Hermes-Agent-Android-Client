import 'package:flutter/foundation.dart';
import '../models/gateway_state.dart';
import '../services/gateway_service.dart';

class GatewayProvider extends ChangeNotifier {
  final GatewayService _service = GatewayService();

  GatewayState _state = GatewayState();
  GatewayState get state => _state;

  List<String> _logs = [];
  List<String> get logs => _logs;

  Future<void> startGateway() async {
    _state = _state.copyWith(status: GatewayStatus.starting);
    notifyListeners();

    try {
      final result = await _service.startGateway();
      if (result.success) {
        _state = _state.copyWith(
          status: GatewayStatus.running,
          tokenUrl: result.tokenUrl,
          startedAt: DateTime.now(),
          version: result.version,
        );
      } else {
        _state = _state.copyWith(
          status: GatewayStatus.error,
          errorMessage: result.errorMessage,
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        status: GatewayStatus.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> stopGateway() async {
    _state = _state.copyWith(status: GatewayStatus.stopping);
    notifyListeners();

    try {
      await _service.stopGateway();
      _state = _state.copyWith(status: GatewayStatus.stopped);
    } catch (e) {
      _state = _state.copyWith(
        status: GatewayStatus.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> checkStatus() async {
    try {
      final status = await _service.checkGatewayStatus();
      if (status.isRunning) {
        _state = _state.copyWith(
          status: GatewayStatus.running,
          tokenUrl: status.tokenUrl,
          version: status.version,
        );
      } else {
        _state = _state.copyWith(status: GatewayStatus.stopped);
      }
    } catch (e) {
      _state = _state.copyWith(status: GatewayStatus.stopped);
    }
    notifyListeners();
  }

  void addLog(String message) {
    _logs.add('[${DateTime.now().toString().substring(11, 19)}] $message');
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }
}
