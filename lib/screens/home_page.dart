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
      "cor": Color(0xFFFFD86C),
      "concluida": false
    },
    {
      "nome": "Fazer Trabalho",
      "cor": Color(0xFF70FF75),
      "concluida": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Minhas Tarefas",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return _cardTarefa(context, tarefa, index);
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NovaTarefaPage()),
              );
            },
            child: const Icon(Icons.add, size: 32),
          ),
        ),
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

        if (resultado == true) {
          setState(() {
            tarefas[index]["concluida"] = true;
          });
        } else if (resultado == "excluir") {
          setState(() {
            tarefas.removeAt(index);
          });
        } else if (resultado is Map) {
          setState(() {
            tarefas[index]["nome"] = resultado["nome"];
            tarefas[index]["data"] = resultado["data"];
            tarefas[index]["observacao"] = resultado["observacao"];
          });
        }
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: tarefa["cor"].withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  tarefas[index]["concluida"] =
                      !tarefas[index]["concluida"];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: concluida ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: concluida ? Colors.green : Colors.grey,
                    width: 2,
                  ),
                ),
                child: concluida
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                tarefa["nome"],
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
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