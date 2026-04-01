import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  final bool modoEscuro; // 🔥 NOVO
  final Function(bool) onTemaChanged; // 🔥 NOVO

  const SplashScreen({
    super.key,
    required this.modoEscuro,
    required this.onTemaChanged,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            modoEscuro: widget.modoEscuro, // 🔥 CORRIGIDO
            onTemaChanged: widget.onTemaChanged, // 🔥 CORRIGIDO
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5F52FF), Color(0xFF6C63FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          children: [

            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "TaskMaster",
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontFamily: 'ShareTechMono',
                        letterSpacing: 2,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      "Gerenciador de tarefas inteligentes",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontFamily: 'ShareTechMono',
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: const Text(
                "“Deixando tudo sob controle”",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'ShareTechMono',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}