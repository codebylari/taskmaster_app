import 'package:flutter/material.dart';

class EditarTarefaPage extends StatefulWidget {
  final Map<String, dynamic> tarefa;

  const EditarTarefaPage({super.key, required this.tarefa});

  @override
  State<EditarTarefaPage> createState() => _EditarTarefaPageState();
}

class _EditarTarefaPageState extends State<EditarTarefaPage> {
  late TextEditingController nomeController;
  late TextEditingController dataController;
  late TextEditingController obsController;

  String prioridadeSelecionada = "baixa";

  @override
  void initState() {
    super.initState();

    nomeController =
        TextEditingController(text: widget.tarefa["nome"] ?? "");
    dataController =
        TextEditingController(text: widget.tarefa["data"] ?? "");
    obsController =
        TextEditingController(text: widget.tarefa["observacao"] ?? "");

    prioridadeSelecionada = widget.tarefa["prioridade"] ?? "baixa";
  }

  void salvar() {
    if (nomeController.text.isEmpty) return;

    Navigator.pop(context, {
      "nome": nomeController.text,
      "data": dataController.text,
      "observacao": obsController.text,
      "prioridade": prioridadeSelecionada,
    });
  }

  Color corPrioridade(String p) {
    switch (p) {
      case "alta":
        return Colors.redAccent;
      case "media":
        return Colors.orangeAccent;
      case "baixa":
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,

        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Editar Tarefa",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
        ),

        centerTitle: true,
        foregroundColor: theme.appBarTheme.foregroundColor,
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

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: margemHorizontal,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                campo(context, "Nome", nomeController),
                const SizedBox(height: 15),
                campo(context, "Data", dataController),
                const SizedBox(height: 15),
                campo(context, "Observação", obsController),

                const SizedBox(height: 25),

                Text(
                  "Prioridade",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    botaoPrioridade(context, "alta", "Alta"),
                    const SizedBox(width: 12),
                    botaoPrioridade(context, "media", "Média"),
                    const SizedBox(width: 12),
                    botaoPrioridade(context, "baixa", "Baixa"),
                  ],
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F00FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔥 INPUT COM BORDA + FOCO ROXO
  Widget campo(BuildContext context, String label, TextEditingController controller) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      style: TextStyle(
        color: theme.textTheme.bodyLarge?.color,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
        ),
        filled: true,
        fillColor: theme.cardColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),

        // 🔥 BORDA NORMAL
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.dividerColor.withOpacity(0.3),
          ),
        ),

        // 🔥 BORDA AO FOCAR
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF7F00FF),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // 🔥 PRIORIDADE ESTILO PREMIUM
  Widget botaoPrioridade(BuildContext context, String valor, String texto) {
    final theme = Theme.of(context);
    final selecionado = prioridadeSelecionada == valor;
    final cor = corPrioridade(valor);

    return GestureDetector(
      onTap: () {
        setState(() {
          prioridadeSelecionada = valor;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: selecionado ? cor : theme.cardColor,
          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: selecionado
                ? cor
                : theme.dividerColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: selecionado
                ? Colors.white
                : theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}