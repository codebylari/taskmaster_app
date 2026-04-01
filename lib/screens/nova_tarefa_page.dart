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

  List<String> horarios =
      List.generate(24, (h) => "${h.toString().padLeft(2, '0')}:00");

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
              decoration: inputStyle("Nome"),
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 55,
              child: TextField(
                controller: dataController,
                readOnly: true,
                decoration: inputStyle("Data").copyWith(
                  suffixIcon: Icon(Icons.calendar_today, color: theme.iconTheme.color),
                ),
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    String formatted =
                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                        "${pickedDate.year}";

                    setState(() {
                      dataController.text = formatted;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: observacaoController,
              maxLines: 3,
              decoration: inputStyle("Observação"),
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),

            const SizedBox(height: 15),

            Text(
              "Prioridade",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prioridadeBox("Alta", Colors.red),
                const SizedBox(width: 10),
                prioridadeBox("Média", Colors.amber),
                const SizedBox(width: 10),
                prioridadeBox("Baixa", Colors.green),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_outlined, color: theme.iconTheme.color),
                  const SizedBox(width: 10),
                  Text("Lembrete", style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                  const Spacer(),
                  Switch(
                    value: lembrete,
                    onChanged: (value) {
                      setState(() {
                        lembrete = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Opacity(
              opacity: lembrete ? 1 : 0.4,
              child: IgnorePointer(
                ignoring: !lembrete,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: theme.iconTheme.color),
                      const SizedBox(width: 10),
                      Text("Horário: ", style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                      DropdownButton<String>(
                        value: horario,
                        underline: const SizedBox(),
                        items: horarios.map((h) {
                          return DropdownMenuItem(
                            value: h,
                            child: Text(h),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            horario = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: adicionarAoGoogleCalendar,
                icon: const Icon(Icons.calendar_month),
                label: const Text("Adicionar ao Google Calendar"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: salvarTarefa,
                child: const Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 AQUI FOI A CORREÇÃO PRINCIPAL
  InputDecoration inputStyle(String label) {
    final theme = Theme.of(context);

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.hintColor),
      filled: true,
      fillColor: theme.cardColor,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.primaryColor,
          width: 2,
        ),
      ),
    );
  }

  Widget prioridadeBox(String texto, Color cor) {
    final theme = Theme.of(context);
    bool selecionado = prioridade == texto;

    return GestureDetector(
      onTap: () {
        setState(() {
          prioridade = texto;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selecionado ? cor.withOpacity(0.15) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? cor : theme.dividerColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(width: 10, height: 10, color: cor),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
          ],
        ),
      ),
    );
  }
}