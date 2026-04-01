import 'package:flutter/material.dart';

class NovaTarefaPage extends StatefulWidget {
  const NovaTarefaPage({super.key});

  @override
  State<NovaTarefaPage> createState() => _NovaTarefaPageState();
}

class _NovaTarefaPageState extends State<NovaTarefaPage> {
  String prioridade = "Alta";
  bool lembrete = true;
  String horario = "00:00";

  TextEditingController nomeController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController observacaoController = TextEditingController();

  List<String> horarios = List.generate(
    24,
    (h) => "${h.toString().padLeft(2, '0')}:00",
  );

  void adicionarAoGoogleCalendar() {
    if (nomeController.text.trim().isEmpty ||
        dataController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha o nome e a data antes de adicionar!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Tarefa adicionada com sucesso"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void salvarTarefa() {
    if (nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("O nome é obrigatório!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String prioridadeFormatada;
    if (prioridade == "Alta") {
      prioridadeFormatada = "alta";
    } else if (prioridade == "Média") {
      prioridadeFormatada = "media";
    } else {
      prioridadeFormatada = "baixa";
    }

    final novaTarefa = {
      "nome": nomeController.text,
      "prioridade": prioridadeFormatada,
      "concluida": false,
      "data": dataController.text,
      "observacao": observacaoController.text,
      "dataCriacao": DateTime.now(),
      "ultimaModificacao": DateTime.now(),
    };

    Navigator.pop(context, novaTarefa);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Nova Tarefa",
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: nomeController,
              decoration: inputStyle("Nome", isDark),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 55,
              child: TextField(
                controller: dataController,
                readOnly: true,
                decoration: inputStyle("Data", isDark).copyWith(
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      dataController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: observacaoController,
              maxLines: 3,
              decoration: inputStyle("Observação", isDark),
            ),

            const SizedBox(height: 15),

            Text("Prioridade",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prioridadeBox("Alta", Colors.red, isDark),
                const SizedBox(width: 10),
                prioridadeBox("Média", Colors.amber, isDark),
                const SizedBox(width: 10),
                prioridadeBox("Baixa", Colors.green, isDark),
              ],
            ),

            const Spacer(),

            // ✅ BOTÃO ÚNICO (CORRIGIDO)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: adicionarAoGoogleCalendar,
                icon: const Icon(Icons.calendar_month, color: Colors.white),
                label: const Text(
                  "Adicionar ao Google Calendar",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F00FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: salvarTarefa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F00FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Salvar",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputStyle(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget prioridadeBox(String texto, Color cor, bool isDark) {
    bool selecionado = prioridade == texto;

    return GestureDetector(
      onTap: () => setState(() => prioridade = texto),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selecionado
              ? cor.withOpacity(0.2)
              : (isDark ? const Color(0xFF1E1E1E) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(texto),
      ),
    );
  }
}