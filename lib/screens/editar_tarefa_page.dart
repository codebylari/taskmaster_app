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
        return Colors.red;
      case "media":
        return Colors.yellow;
      case "baixa":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FA),

      // ✅ APPBAR PADRÃO (igual outras telas)
      appBar: AppBar(
        title: const Text("Editar Tarefa"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            campo("Nome", nomeController, isDark),
            const SizedBox(height: 15),
            campo("Data", dataController, isDark),
            const SizedBox(height: 15),
            campo("Observação", obsController, isDark),

            const SizedBox(height: 25),

            Text(
              "Prioridade",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                botaoPrioridade("alta", "Alta 🔴", isDark),
                botaoPrioridade("media", "Média 🟡", isDark),
                botaoPrioridade("baixa", "Baixa 🟢", isDark),
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
      ),
    );
  }

  Widget campo(String label, TextEditingController controller, bool isDark) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        filled: true,
        fillColor:
            isDark ? const Color(0xFF1E1E1E) : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget botaoPrioridade(String valor, String texto, bool isDark) {
    final selecionado = prioridadeSelecionada == valor;

    return GestureDetector(
      onTap: () {
        setState(() {
          prioridadeSelecionada = valor;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: selecionado
              ? corPrioridade(valor).withOpacity(0.4)
              : (isDark
                  ? const Color(0xFF1E1E1E)
                  : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}