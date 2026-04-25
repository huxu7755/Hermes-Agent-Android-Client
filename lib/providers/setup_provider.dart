import 'package:flutter/foundation.dart';
import '../models/setup_state.dart';
import '../services/bootstrap_service.dart';

class SetupProvider extends ChangeNotifier {
  final BootstrapService _service = BootstrapService();

  SetupState _state = SetupState();
  SetupState get state => _state;

  Future<void> startSetup() async {
    _state = _state.copyWith(
      step: SetupStep.installing,
      progress: 0.0,
      currentMessage: 'Starting installation...',
    );
    notifyListeners();

    try {
      await _service.runSetup(
        onProgress: (progress, message) {
          _state = _state.copyWith(
            progress: progress,
            currentMessage: message,
          );
          notifyListeners();
        },
      );

      _state = _state.copyWith(
        step: SetupStep.completing,
        progress: 1.0,
        currentMessage: 'Setup complete!',
        isComplete: true,
      );
    } catch (e) {
      _state = _state.copyWith(
        step: SetupStep.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  void reset() {
    _state = SetupState();
    notifyListeners();
  }
}
