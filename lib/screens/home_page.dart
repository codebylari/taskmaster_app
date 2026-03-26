import 'package:flutter/material.dart';
import 'detalhes_tarefa_page.dart';
import 'nova_tarefa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tarefas = [
    {"nome": "Estudar UX", "cor": Colors.red, "concluida": false},
    {
      "nome": "Academia",
      "cor": Color.fromARGB(255, 255, 218, 108),
      "concluida": false
    },
    {
      "nome": "Fazer Trabalho",
      "cor": Color.fromARGB(255, 112, 255, 117),
      "concluida": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Minhas Tarefas",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return _cardTarefa(context, tarefa, index);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NovaTarefaPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _cardTarefa(
    BuildContext context,
    Map<String, dynamic> tarefa,
    int index,
  ) {
    final concluida = tarefa["concluida"];

    return GestureDetector(
      onTap: () async {
        final resultado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalhesTarefaPage(tarefa: tarefa),
          ),
        );

        // ✅ CONCLUIR
        if (resultado == true) {
          setState(() {
            tarefas[index]["concluida"] = true;
          });
        }

        // 🗑️ EXCLUIR
        else if (resultado == "excluir") {
          setState(() {
            tarefas.removeAt(index);
          });
        }

        // ✏️ EDITAR
        else if (resultado is Map) {
          setState(() {
            tarefas[index]["nome"] = resultado["nome"];
            tarefas[index]["data"] = resultado["data"];
            tarefas[index]["observacao"] = resultado["observacao"];
          });
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // ✅ CHECKBOX CLICÁVEL
            GestureDetector(
              onTap: () {
                setState(() {
                  tarefas[index]["concluida"] =
                      !tarefas[index]["concluida"];
                });
              },
              child: Icon(
                concluida
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: concluida ? Colors.green : Colors.grey,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                tarefa["nome"],
                style: TextStyle(
                  fontSize: 16,
                  decoration: concluida
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}