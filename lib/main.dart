import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/chat/viewmodels/chat_view_model.dart';
import 'features/chat/views/splash_screen.dart';

void main() {
  runApp(const BrainRotApp());
}

class BrainRotApp extends StatelessWidget {
  const BrainRotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: MaterialApp(
        title: 'BrainRot AI',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7C3AED),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
