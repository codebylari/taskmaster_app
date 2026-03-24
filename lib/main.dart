import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// ================= APP =================
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// ================= SPLASH =================
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5F52FF),
              Color(0xFF6C63FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            Text(
              "TaskMaster",
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Gerenciador de tarefas inteligentes",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                "“Organize sua vida”",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= HOME =================
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),

            Text(
              "Minhas Tarefas",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Divider(),

            tarefa("Estudar UX", Colors.red),
            tarefa("Academia", Colors.yellow),
            tarefa("Fazer Trabalho", Colors.green),

            Spacer(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget tarefa(String nome, Color cor) {
    return ListTile(
      leading: Checkbox(value: false, onChanged: (v) {}),
      title: Text(nome),
      trailing: CircleAvatar(
        radius: 8,
        backgroundColor: cor,
      ),
    );
  }
}