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
  TextEditingController observacaoController = TextEditingController(); // 🔥 NOVO

  List<String> horarios =
      List.generate(24, (h) => "${h.toString().padLeft(2, '0')}:00");

  // 🔥 FUNÇÃO CORRIGIDA COMPLETA
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
      "data": dataController.text, // 🔥 AGORA SALVA DATA
      "observacao": observacaoController.text, // 🔥 AGORA SALVA OBS
      "dataCriacao": DateTime.now(),
    };

    Navigator.pop(context, novaTarefa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.purple),
        centerTitle: true,
        title: const Text(
          "Nova Tarefa",
          style: TextStyle(color: Colors.black),
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
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 55,
              child: TextField(
                controller: dataController,
                readOnly: true,
                decoration: inputStyle("Data").copyWith(
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
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

            // 🔥 AGORA SALVA OBSERVAÇÃO
            TextField(
              controller: observacaoController,
              maxLines: 3,
              decoration: inputStyle("Observação"),
            ),

            const SizedBox(height: 15),

            const Text(
              "Prioridade",
              style: TextStyle(fontWeight: FontWeight.bold),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_outlined),
                  const SizedBox(width: 10),
                  const Text("Lembrete"),
                  const Spacer(),
                  Switch(
                    value: lembrete,
                    onChanged: (value) {
                      setState(() {
                        lembrete = value;
                      });
                    },
                    activeTrackColor: Colors.green,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 10),
                      const Text("Horário: "),
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

            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: salvarTarefa,
                  child: const Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget prioridadeBox(String texto, Color cor) {
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
          color: selecionado ? cor.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? cor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(width: 10, height: 10, color: cor),
            const SizedBox(width: 6),
            Text(texto),
          ],
        ),
      ),
    );
  }
}