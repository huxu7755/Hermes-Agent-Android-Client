import 'package:flutter/foundation.dart';
import '../models/node_state.dart';
import '../services/node_service.dart';

class NodeProvider extends ChangeNotifier {
  final NodeService _service = NodeService();

  NodeState _state = NodeState();
  NodeState get state => _state;

  Future<void> enableNode() async {
    _state = _state.copyWith(enabled: true);
    notifyListeners();

    try {
      await _service.connect();
      _state = _state.copyWith(connected: true);
    } catch (e) {
      _state = _state.copyWith(
        connected: false,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> disableNode() async {
    await _service.disconnect();
    _state = _state.copyWith(enabled: false, connected: false);
    notifyListeners();
  }

  Future<bool> requestPermission(String permission) async {
    return await _service.requestPermission(permission);
  }

  void updateCapabilities(List<String> capabilities) {
    _state = _state.copyWith(capabilities: capabilities);
    notifyListeners();
  }
}
