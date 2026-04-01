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

  // ✅ NOVO: prioridade
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

    // ✅ NOVO: pega prioridade existente
    prioridadeSelecionada = widget.tarefa["prioridade"] ?? "baixa";
  }

  void salvar() {
    if (nomeController.text.isEmpty) return;

    Navigator.pop(context, {
      "nome": nomeController.text,
      "data": dataController.text,
      "observacao": obsController.text,

      // ✅ NOVO: retorna prioridade
      "prioridade": prioridadeSelecionada,
    });
  }

  // ✅ NOVO: cor da prioridade
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
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
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Editar Tarefa",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              campo("Nome", nomeController),
              const SizedBox(height: 15),
              campo("Data", dataController),
              const SizedBox(height: 15),
              campo("Observação", obsController),

              const SizedBox(height: 20),

              // ✅ NOVO: ESCOLHER PRIORIDADE
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prioridade",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  botaoPrioridade("alta", "Alta 🔴"),
                  botaoPrioridade("media", "Média 🟡"),
                  botaoPrioridade("baixa", "Baixa 🟢"),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget campo(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ✅ NOVO: botão de prioridade
  Widget botaoPrioridade(String valor, String texto) {
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
              ? corPrioridade(valor).withOpacity(0.3)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(texto),
      ),
    );
  }
}