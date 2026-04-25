import 'dart:io';
import '../models/gateway_state.dart';

class GatewayServiceResult {
  final bool success;
  final String? tokenUrl;
  final String? version;
  final String? errorMessage;

  GatewayServiceResult({
    required this.success,
    this.tokenUrl,
    this.version,
    this.errorMessage,
  });
}

class GatewayService {
  static const String _hermesCommand = 'hermes';

  Future<GatewayServiceResult> startGateway() async {
    try {
      final process = await Process.start(_hermesCommand, ['gateway', 'start']);
      
      await Future.delayed(const Duration(seconds: 3));

      final isRunning = await checkRunning();
      if (isRunning) {
        return GatewayServiceResult(
          success: true,
          tokenUrl: 'http://localhost:18789',
          version: await _getVersion(),
        );
      }

      return GatewayServiceResult(
        success: false,
        errorMessage: 'Gateway failed to start',
      );
    } catch (e) {
      return GatewayServiceResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> stopGateway() async {
    try {
      await Process.run(_hermesCommand, ['gateway', 'stop']);
    } catch (e) {
      final process = await Process.start('pkill', ['-f', 'hermes']);
      await process.exitCode;
    }
  }

  Future<bool> checkRunning() async {
    try {
      final result = await Process.run('pgrep', ['-f', 'hermes']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  Future<GatewayState> checkGatewayStatus() async {
    final isRunning = await checkRunning();
    if (isRunning) {
      return GatewayState(
        status: GatewayStatus.running,
        tokenUrl: 'http://localhost:18789',
        version: await _getVersion(),
        startedAt: DateTime.now(),
      );
    }
    return GatewayState(status: GatewayStatus.stopped);
  }

  Future<String?> _getVersion() async {
    try {
      final result = await Process.run(_hermesCommand, ['--version']);
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> runHealthCheck() async {
    try {
      final result = await Process.run('curl', ['-s', '-o', '/dev/null', '-w', '%{http_code}', 'http://localhost:18789']);
      return result.stdout.toString().trim() == '200';
    } catch (e) {
      return false;
    }
  }
}
