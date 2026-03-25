import 'package:flutter/material.dart';
import 'package:meu_app/screens/nova_tarefa_page.dart';

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
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NovaTarefaPage(),
            ),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget tarefa(String nome, Color cor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Checkbox(value: false, onChanged: (v) {}),
        title: Text(nome, style: TextStyle(fontSize: 18)),
        trailing: CircleAvatar(radius: 8, backgroundColor: cor),
      ),
    );
  }
}