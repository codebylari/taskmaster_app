import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool modoEscuro = false;

  @override
  void initState() {
    super.initState();
    _carregarTema();
  }

  Future<void> _carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = prefs.getBool("modoEscuro");

    if (salvo != null) {
      setState(() {
        modoEscuro = salvo;
      });
    }
  }

  void atualizarTema(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("modoEscuro", valor);

    setState(() {
      modoEscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.theme,

      // 🔥 AGORA FUNCIONA
      darkTheme: AppTheme.darkTheme,

      themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,

      home: SplashScreen(
        modoEscuro: modoEscuro,
        onTemaChanged: atualizarTema,
      ),
    );
  }
}