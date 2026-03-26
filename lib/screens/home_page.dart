import 'package:flutter/material.dart';
import 'detalhes_tarefa_page.dart';
import 'nova_tarefa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filtro = "recente";

  List<Map<String, dynamic>> tarefas = [
    {
      "nome": "Estudar UX",
      "prioridade": "alta",
      "concluida": false,
      "dataCriacao": DateTime.now().subtract(const Duration(minutes: 30))
    },
    {
      "nome": "Academia",
      "prioridade": "media",
      "concluida": false,
      "dataCriacao": DateTime.now().subtract(const Duration(minutes: 20))
    },
    {
      "nome": "Fazer Trabalho",
      "prioridade": "baixa",
      "concluida": false,
      "dataCriacao": DateTime.now()
    },
  ];

  Color _corPrioridade(String p) {
    switch (p) {
      case "alta":
        return Colors.red;
      case "media":
        return Colors.yellow;
      case "baixa":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // 🔥 NOVA LÓGICA DE ORDENAÇÃO (sem esconder tarefas)
  List<Map<String, dynamic>> get tarefasOrdenadas {
    List<Map<String, dynamic>> lista = [...tarefas];

    if (filtro == "alta" ||
        filtro == "media" ||
        filtro == "baixa") {
      lista.sort((a, b) {
        if (a["prioridade"] == filtro && b["prioridade"] != filtro) {
          return -1; // sobe
        }
        if (a["prioridade"] != filtro && b["prioridade"] == filtro) {
          return 1; // desce
        }
        return 0;
      });
    }

    if (filtro == "recente") {
      lista.sort((a, b) =>
          b["dataCriacao"].compareTo(a["dataCriacao"]));
    }

    if (filtro == "antigo") {
      lista.sort((a, b) =>
          a["dataCriacao"].compareTo(b["dataCriacao"]));
    }

    return lista;
  }

  Color _corFundo(Color cor) => cor.withOpacity(0.15);

  @override
  Widget build(BuildContext context) {
    final lista = tarefasOrdenadas;

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

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // 🔽 FILTRO
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Ordenar por: "),
                DropdownButton<String>(
                  value: filtro,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: "alta",
                      child: Text("Prioridade alta 🔴"),
                    ),
                    DropdownMenuItem(
                      value: "media",
                      child: Text("Prioridade média 🟡"),
                    ),
                    DropdownMenuItem(
                      value: "baixa",
                      child: Text("Prioridade baixa 🟢"),
                    ),
                    DropdownMenuItem(
                      value: "recente",
                      child: Text("Mais recente"),
                    ),
                    DropdownMenuItem(
                      value: "antigo",
                      child: Text("Mais antigo"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filtro = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 📋 LISTA
            ...lista.map((tarefa) => _cardTarefa(tarefa)),

            const SizedBox(height: 10),

            // ➕ BOTÃO
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NovaTarefaPage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Nova Tarefa"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardTarefa(Map<String, dynamic> tarefa) {
    final cor = _corPrioridade(tarefa["prioridade"]);
    final concluida = tarefa["concluida"];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _corFundo(cor),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          // 🔥 VOLTOU O CLICK PRA RIScar
          GestureDetector(
            onTap: () {
              setState(() {
                tarefa["concluida"] = !tarefa["concluida"];
              });
            },
            child: Icon(
              concluida
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: cor,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              tarefa["nome"],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: concluida
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}