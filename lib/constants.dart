class AppConstants {
  static const String appName = 'Hermes Agent';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'Nous Research';
  static const String appDescription = 'Self-improving AI agent for Android';

  static const String installScriptUrl =
      'https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh';

  static const String gatewayDefaultUrl = 'http://localhost:18789';
  static const int gatewayPort = 18789;

  static const String prootDistro = 'ubuntu';
  static const int downloadTimeout = 300;

  static const String nodeWsPath = '/api/node';

  static const double minAndroidVersion = 10.0;

  static const String githubUrl = 'https://github.com/NousResearch/hermes-agent';
  static const String docsUrl = 'https://hermes-agent.nousresearch.com/docs';
}

class AppColors {
  static const Color primary = Color(0xFF6B4EFF);
  static const Color secondary = Color(0xFF9D7AFF);
  static const Color accent = Color(0xFF00D9FF);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color cardBackground = Color(0xFF2D2D2D);
}
