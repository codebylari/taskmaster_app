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
      "cor": Colors.red,
      "concluida": false,
      "dataCriacao": DateTime.now().subtract(const Duration(minutes: 20))
    },
    {
      "nome": "Academia",
      "cor": Colors.yellow,
      "concluida": false,
      "dataCriacao": DateTime.now().subtract(const Duration(minutes: 10))
    },
    {
      "nome": "Fazer Trabalho",
      "cor": Colors.green,
      "concluida": false,
      "dataCriacao": DateTime.now()
    },
  ];

  List<Map<String, dynamic>> get tarefasOrdenadas {
    List<Map<String, dynamic>> lista = [...tarefas];

    if (filtro == "prioridade") {
      lista.sort((a, b) {
        return _prioridadeValor(a["cor"])
            .compareTo(_prioridadeValor(b["cor"]));
      });
    } else {
      // MAIS ANTIGO → MAIS NOVO
      lista.sort((a, b) =>
          a["dataCriacao"].compareTo(b["dataCriacao"]));
    }

    return lista;
  }

  int _prioridadeValor(Color cor) {
    if (cor == Colors.red) return 1;
    if (cor == Colors.yellow) return 2;
    return 3;
  }

  Color _corFundo(Color cor) {
    return cor.withOpacity(0.15);
  }

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

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔽 FILTRO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ordenar por:"),
                DropdownButton<String>(
                  value: filtro,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: "recente",
                      child: Text("Mais antigo"),
                    ),
                    DropdownMenuItem(
                      value: "prioridade",
                      child: Text("Prioridade"),
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
            Expanded(
              child: ListView.builder(
                itemCount: tarefasOrdenadas.length,
                itemBuilder: (context, index) {
                  final tarefa = tarefasOrdenadas[index];
                  return _cardTarefa(context, tarefa);
                },
              ),
            ),

            const SizedBox(height: 10),

            // ➕ BOTÃO MAIS PROPORCIONAL
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

  Widget _cardTarefa(
    BuildContext context,
    Map<String, dynamic> tarefa,
  ) {
    final concluida = tarefa["concluida"];
    final cor = tarefa["cor"];

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
          setState(() {
            tarefas.remove(tarefa);
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
                  fontWeight: FontWeight.w500,
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