import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

// 🔥 ALTERADO PARA STATEFUL (sem remover nada importante)
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool modoEscuro = false;

  // 🔥 função global para trocar tema
  void atualizarTema(bool valor) {
    setState(() {
      modoEscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 👇 seu tema original (mantido)
      theme: AppTheme.theme,

      // 🔥 NOVO: tema escuro global
      darkTheme: ThemeData.dark(),

      // 🔥 NOVO: controle do tema
      themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,

      // 🔥 ALTERAÇÃO AQUI (PASSANDO PRA SPLASH)
      home: SplashScreen(
        modoEscuro: modoEscuro,
        onTemaChanged: atualizarTema,
      ),
    );
  }
}