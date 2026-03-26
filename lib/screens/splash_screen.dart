import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
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
        MaterialPageRoute(builder: (context) => HomePage()),
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
                        height: 1, // 👈 controla altura da linha
                      ),
                    ),

                    const SizedBox(height: 2), // 👈 quase colado

                    const Text(
                      "Gerenciador de tarefas inteligentes",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontFamily: 'ShareTechMono',
                        height: 1, // 👈 ISSO FAZ A DIFERENÇA
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: const Text(
                "“Organize sua vida”",
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