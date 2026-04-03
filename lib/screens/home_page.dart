import 'package:flutter/material.dart';
import 'nova_tarefa_page.dart';
import 'detalhes_tarefa_page.dart';
import 'configuracoes_page.dart'; 

class HomePage extends StatefulWidget {
  final bool modoEscuro;
  final Function(bool) onTemaChanged;

  const HomePage({
    super.key,
    required this.modoEscuro,
    required this.onTemaChanged,
  });

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
      "observacao": "Revisar conceitos de UX",
      "dataCriacao": DateTime.now().subtract(Duration(minutes: 30)),
      "ultimaModificacao": DateTime.now(),
    },
    {
      "nome": "Academia",
      "prioridade": "media",
      "concluida": false,
      "data": "26/03/2026",
      "observacao": "Treino de perna",
      "dataCriacao": DateTime.now().subtract(Duration(minutes: 20)),
      "ultimaModificacao": DateTime.now(),
    },
    {
      "nome": "Fazer Trabalho",
      "prioridade": "baixa",
      "concluida": false,
      "data": "27/03/2026",
      "observacao": "Projeto Flutter",
      "dataCriacao": DateTime.now(),
      "ultimaModificacao": DateTime.now(),
    },
  ];

  Color _corPrioridade(String p) {
    switch (p) {
      case "alta":
        return Colors.red;
      case "media":
        return Colors.orange;
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

  Color _corFundo(Color cor) => cor.withOpacity(0.12);

  String _formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')} "
        "${data.hour.toString().padLeft(2, '0')}:"
        "${data.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final lista = tarefasOrdenadas;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,

        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Minhas Tarefas",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
        ),

        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 10),
            child: IconButton(
              icon: Icon(Icons.settings, color: theme.iconTheme.color),
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfiguracoesPage(
                      modoEscuroAtual: widget.modoEscuro,
                      onTemaChanged: widget.onTemaChanged,
                    ),
                  ),
                );

                if (resultado != null) {
                  final bool novoTema = resultado["modoEscuro"] ?? widget.modoEscuro;
                  final bool limpar = resultado["limpar"] ?? false;

                  widget.onTemaChanged(novoTema);

                  if (limpar) {
                    setState(() {
                      tarefas.removeWhere((t) => t["concluida"] == true);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tarefas concluídas removidas 🧹"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          double largura = constraints.maxWidth;

          double margemHorizontal;

          if (largura > 900) {
            margemHorizontal = largura * 0.2;
          } else if (largura > 600) {
            margemHorizontal = largura * 0.1;
          } else {
            margemHorizontal = 16;
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: margemHorizontal,
              vertical: 20,
            ),
            child: ListView(
              children: [
                const SizedBox(height: 10), // 🔥 respiro do topo

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Ordenar por:",
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: filtro,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: "alta", child: Text("Alta 🔴")),
                        DropdownMenuItem(value: "media", child: Text("Média 🟠")),
                        DropdownMenuItem(value: "baixa", child: Text("Baixa 🟢")),
                        DropdownMenuItem(value: "recente", child: Text("Recente")),
                        DropdownMenuItem(value: "antigo", child: Text("Antigo")),
                      ],
                      onChanged: (value) {
                        setState(() => filtro = value!);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                ...lista.map((tarefa) => _cardTarefa(context, tarefa, isDark)),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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
          );
        },
      ),
    );
  }

  Widget _cardTarefa(BuildContext context, Map<String, dynamic> tarefa, bool isDark) {
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
          setState(() => tarefa["concluida"] = true);
        } else if (resultado == "excluir") {
          setState(() => tarefas.remove(tarefa));
        } else if (resultado is Map) {
          setState(() {
            tarefa["nome"] = resultado["nome"];
            tarefa["data"] = resultado["data"];
            tarefa["observacao"] = resultado["observacao"];
            tarefa["prioridade"] = resultado["prioridade"];
            tarefa["ultimaModificacao"] = DateTime.now();
          });
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E1E1E)
              : _corFundo(cor),
          borderRadius: BorderRadius.circular(16),

          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.06))
              : null,

          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarefa["nome"],
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.textTheme.bodyLarge?.color,
                      decoration: concluida
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Data: ${tarefa["data"]}",
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),

                  Text(
                    "Editado: ${_formatarData(
                      tarefa["ultimaModificacao"] ?? DateTime.now()
                    )}",
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}