import 'package:flutter/material.dart';
import 'notificacoes.dart';

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

    Notificacoes.sucesso(context, "Tarefa atualizada com sucesso");

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context, {
        "nome": nomeController.text,
        "data": dataController.text,
        "observacao": obsController.text,
        "prioridade": prioridadeSelecionada,
      });
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
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Editar Tarefa",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ],
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
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    botaoPrioridade(context, "alta", "Alta"),
                    const SizedBox(width: 10),
                    botaoPrioridade(context, "media", "Média"),
                    const SizedBox(width: 10),
                    botaoPrioridade(context, "baixa", "Baixa"),
                  ],
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
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

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.dividerColor.withOpacity(0.3),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

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
          color: selecionado
              ? cor.withOpacity(0.15)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: selecionado
                ? cor.withOpacity(0.6)
                : theme.dividerColor.withOpacity(0.3),
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: selecionado
                ? cor
                : theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}