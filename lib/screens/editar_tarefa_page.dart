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

    // ✅ DETECTA SE ESTÁ EM DARK MODE
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),

      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color:
                isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.6 : 0.05),
                blurRadius: 20,
              )
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Editar Tarefa",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              campo("Nome", nomeController, isDark),
              const SizedBox(height: 15),
              campo("Data", dataController, isDark),
              const SizedBox(height: 15),
              campo("Observação", obsController, isDark),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prioridade",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
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

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: salvar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0xFF7F00FF),
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
            isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: selecionado
              ? corPrioridade(valor).withOpacity(0.4)
              : (isDark
                  ? const Color(0xFF2A2A2A)
                  : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}