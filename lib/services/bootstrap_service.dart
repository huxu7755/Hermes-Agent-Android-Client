import 'dart:io';
import '../models/setup_state.dart';

class BootstrapService {
  static const String _installScriptUrl =
      'https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh';

  Future<void> runSetup({
    required Function(double, String) onProgress,
  }) async {
    onProgress(0.1, 'Checking system requirements...');
    await _checkRequirements();

    onProgress(0.2, 'Installing dependencies...');
    await _installDependencies();

    onProgress(0.4, 'Setting up hermes-agent...');
    await _runInstallScript();

    onProgress(0.7, 'Configuring environment...');
    await _configureEnvironment();

    onProgress(0.9, 'Verifying installation...');
    await _verifyInstallation();

    onProgress(1.0, 'Setup complete!');
  }

  Future<void> _checkRequirements() async {
    final result = await Process.run('uname', ['-m']);
    final arch = result.stdout.toString().trim();
    
    if (!['aarch64', 'arm64', 'x86_64'].contains(arch)) {
      throw Exception('Unsupported architecture: $arch');
    }
  }

  Future<void> _installDependencies() async {
    try {
      await Process.run('which', ['curl']);
    } catch (e) {
      throw Exception('curl is required but not installed');
    }

    try {
      await Process.run('which', ['git']);
    } catch (e) {
      await Process.run('apt', ['install', '-y', 'git']);
    }
  }

  Future<void> _runInstallScript() async {
    final scriptResult = await Process.run(
      'curl',
      ['-fsSL', _installScriptUrl],
    );

    if (scriptResult.exitCode != 0) {
      throw Exception('Failed to download installation script');
    }

    final script = scriptResult.stdout as String;
    final file = File('/tmp/hermes_install.sh');
    await file.writeAsString(script);

    await Process.run('chmod', ['+x', '/tmp/hermes_install.sh']);

    final process = await Process.start(
      'bash',
      ['/tmp/hermes_install.sh'],
    );

    await process.exitCode;
  }

  Future<void> _configureEnvironment() async {
    final homeDir = Platform.environment['HOME'] ?? '/root';
    
    final bashrc = File('$homeDir/.bashrc');
    if (await bashrc.exists()) {
      final content = await bashrc.readAsString();
      if (!content.contains('hermes')) {
        await bashrc.writeAsString(content + '\nsource ~/.bashrc\n');
      }
    }

    await Directory('$homeDir/.hermes').create(recursive: true);
    await Directory('$homeDir/.hermes/logs').create(recursive: true);
    await Directory('$homeDir/.hermes/sessions').create(recursive: true);
    await Directory('$homeDir/.hermes/skills').create(recursive: true);
    await Directory('$homeDir/.hermes/memories').create(recursive: true);
  }

  Future<void> _verifyInstallation() async {
    try {
      final result = await Process.run('which', ['hermes']);
      if (result.exitCode != 0) {
        throw Exception('hermes command not found after installation');
      }
    } catch (e) {
      throw Exception('Installation verification failed: $e');
    }
  }

  Future<bool> isHermesInstalled() async {
    try {
      final result = await Process.run('which', ['hermes']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }
}
