import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyTokenUrl = 'hermes_token_url';
  static const String _keyGatewayPort = 'hermes_gateway_port';
  static const String _keyAutoStart = 'hermes_auto_start';
  static const String _keyNodeEnabled = 'hermes_node_enabled';
  static const String _keySelectedProvider = 'hermes_selected_provider';
  static const String _keySetupComplete = 'hermes_setup_complete';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get tokenUrl => _prefs.getString(_keyTokenUrl);
  set tokenUrl(String? value) => _prefs.setString(_keyTokenUrl, value ?? '');

  int get gatewayPort => _prefs.getInt(_keyGatewayPort) ?? 18789;
  set gatewayPort(int value) => _prefs.setInt(_keyGatewayPort, value);

  bool get autoStart => _prefs.getBool(_keyAutoStart) ?? false;
  set autoStart(bool value) => _prefs.setBool(_keyAutoStart, value);

  bool get nodeEnabled => _prefs.getBool(_keyNodeEnabled) ?? false;
  set nodeEnabled(bool value) => _prefs.setBool(_keyNodeEnabled, value);

  String? get selectedProvider => _prefs.getString(_keySelectedProvider);
  set selectedProvider(String? value) => _prefs.setString(_keySelectedProvider, value ?? '');

  bool get setupComplete => _prefs.getBool(_keySetupComplete) ?? false;
  set setupComplete(bool value) => _prefs.setBool(_keySetupComplete, value);

  Future<void> clear() async {
    await _prefs.clear();
  }
}
