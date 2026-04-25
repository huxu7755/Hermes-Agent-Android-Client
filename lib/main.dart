import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'providers/gateway_provider.dart';
import 'providers/setup_provider.dart';
import 'providers/node_provider.dart';
import 'screens/splash_screen.dart';
import 'constants.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    debugPrint('StackTrace: ${details.stack}');
  };

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const HermesAgentApp());
}

class HermesAgentApp extends StatelessWidget {
  const HermesAgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GatewayProvider()),
        ChangeNotifierProvider(create: (_) => SetupProvider()),
        ChangeNotifierProvider(create: (_) => NodeProvider()),
      ],
      child: MaterialApp(
        title: 'Hermes Agent',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B4EFF),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
