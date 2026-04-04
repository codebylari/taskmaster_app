import 'package:flutter/material.dart';
import 'nova_tarefa_page.dart';
import 'detalhes_tarefa_page.dart';
import 'notificacoes.dart'; 

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
      "data": "25/03/2026",
      "observacao": "Revisar conceitos de UI/UX",
      "dataCriacao": DateTime.now().subtract(const Duration(minutes: 30))
    },
    {
      "nome": "Academia",
      "prioridade": "media",
      "concluida": false,
      "data": "26/03/2026",
      "observacao": "Treino de perna",
      "dataCriacao": DateTime.now().subtract(const Duration(minutes: 20))
    },
    {
      "nome": "Fazer Trabalho",
      "prioridade": "baixa",
      "concluida": false,
      "data": "27/03/2026",
      "observacao": "Finalizar projeto Flutter",
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

  List<Map<String, dynamic>> get tarefasOrdenadas {
    List<Map<String, dynamic>> lista = [...tarefas];

    if (filtro == "alta" || filtro == "media" || filtro == "baixa") {
      lista.sort((a, b) {
        if (a["prioridade"] == filtro && b["prioridade"] != filtro) return -1;
        if (a["prioridade"] != filtro && b["prioridade"] == filtro) return 1;
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
    final theme = Theme.of(context);
    final lista = tarefasOrdenadas;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Minhas Tarefas",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Ordenar por: ",
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                DropdownButton<String>(
                  value: filtro,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: "alta", child: Text("Alta 🔴")),
                    DropdownMenuItem(value: "media", child: Text("Média 🟡")),
                    DropdownMenuItem(value: "baixa", child: Text("Baixa 🟢")),
                    DropdownMenuItem(value: "recente", child: Text("Mais recente")),
                    DropdownMenuItem(value: "antigo", child: Text("Mais antigo")),
                  ],
                  onChanged: (value) {
                    setState(() => filtro = value!);
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            ...lista.map((tarefa) => _cardTarefa(context, tarefa)),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F00FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final novaTarefa = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NovaTarefaPage()),
                  );

                  if (novaTarefa != null) {
                    setState(() {
                      tarefas.add(novaTarefa);
                    });
                  }
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

  Widget _cardTarefa(BuildContext context, Map<String, dynamic> tarefa) {
    final theme = Theme.of(context);
    final cor = _corPrioridade(tarefa["prioridade"]);
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
            tarefa["concluida"] = true;
          });
        } else if (resultado == "excluir") {

          final tarefaRemovida = tarefa;
          final index = tarefas.indexOf(tarefa);

          setState(() {
            tarefas.remove(tarefa);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Tarefa excluída"),
              backgroundColor: const Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: "Desfazer",
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    tarefas.insert(index, tarefaRemovida);
                  });
                },
              ),
            ),
          );

        } else if (resultado is Map) {
          setState(() {
            tarefa["nome"] = resultado["nome"];
            tarefa["data"] = resultado["data"];
            tarefa["observacao"] = resultado["observacao"];
          });
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _corFundo(cor),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [
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
                  color: theme.textTheme.bodyLarge?.color,
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