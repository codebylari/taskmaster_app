import 'package:flutter/material.dart';

class NovaTarefaPage extends StatefulWidget {
  @override
  _NovaTarefaPageState createState() => _NovaTarefaPageState();
}

class _NovaTarefaPageState extends State<NovaTarefaPage> {
  String prioridade = "Alta";
  bool lembrete = true;
  String horario = "00:00";

  TextEditingController nomeController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  List<String> horarios =
      List.generate(24, (h) => "${h.toString().padLeft(2, '0')}:00");

  void salvarTarefa() {
    if (nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("O nome é obrigatório!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print("Tarefa salva!");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.purple),
        centerTitle: true,
        title: Text("Nova Tarefa", style: TextStyle(color: Colors.black)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 NOME (SEM BORDA)
            TextField(
              controller: nomeController,
              decoration: inputStyle("Nome"),
            ),
            SizedBox(height: 10),

            // 🔥 DATA MENOR E CLEAN
            SizedBox(
              height: 55,
              child: TextField(
                controller: dataController,
                readOnly: true,
                decoration: inputStyle("Data").copyWith(
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

            SizedBox(height: 10),

            // 🔥 OBSERVAÇÃO SEM BORDA
            TextField(
              maxLines: 3,
              decoration: inputStyle("Observação"),
            ),

            SizedBox(height: 15),

            Text("Prioridade", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prioridadeBox("Alta", Colors.red),
                SizedBox(width: 10),
                prioridadeBox("Média", Colors.amber),
                SizedBox(width: 10),
                prioridadeBox("Baixa", Colors.green),
              ],
            ),

            SizedBox(height: 20),

            // 🔥 LEMBRETE MODERNO
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_outlined),
                  SizedBox(width: 10),
                  Text("Lembrete", style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Switch(
                    value: lembrete,
                    onChanged: (value) {
                      setState(() {
                        lembrete = value;
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade400,
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            // 🔥 HORÁRIO
            Opacity(
              opacity: lembrete ? 1 : 0.4,
              child: IgnorePointer(
                ignoring: !lembrete,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 10),
                      Text("Horário: "),
                      DropdownButton<String>(
                        value: horario,
                        underline: SizedBox(),
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

            Expanded(child: Container()),

            // 🔥 BOTÃO CENTRAL
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: salvarTarefa,
                  child: Text(
                    "Salvar",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 🔥 INPUT CLEAN (SEM BORDA)
  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // 👈 remove borda preta
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
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
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            SizedBox(width: 6),
            Text(texto),
          ],
        ),
      ),
    );
  }
}