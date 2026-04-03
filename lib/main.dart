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

      //tema 
      theme: AppTheme.theme,

      //tema escuro global
      darkTheme: ThemeData.dark(),

      //controle do tema
      themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,

    
      home: SplashScreen(
        modoEscuro: modoEscuro,
        onTemaChanged: atualizarTema,
      ),
    );
  }
}