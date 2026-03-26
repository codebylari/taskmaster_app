import 'package:flutter/material.dart';

class NovaTarefaPage extends StatefulWidget {
  @override
  _NovaTarefaPageState createState() => _NovaTarefaPageState();
}

class _NovaTarefaPageState extends State<NovaTarefaPage> {
  String prioridade = "Alta";
  bool lembrete = true;
  String horario = "00:00";

  TextEditingController dataController = TextEditingController();

  List<String> horarios =
      List.generate(24, (h) => "${h.toString().padLeft(2, '0')}:00");

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

            TextField(decoration: inputStyle("Nome")),
            SizedBox(height: 10),

            TextField(
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

            SizedBox(height: 10),

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
                prioridadeBox("Média", Colors.yellow),
                SizedBox(width: 10),
                prioridadeBox("Baixa", Colors.green),
              ],
            ),

            SizedBox(height: 15),

            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 10),
                Text("Lembrete"),
                Spacer(),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      lembrete = !lembrete;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: lembrete ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lembrete ? "ON" : "OFF",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 10),
                Text("Horário: "),
                DropdownButton<String>(
                  value: horario,
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

            // 🔥 EMPURRA O BOTÃO PRA BAIXO
            Expanded(child: Container()),

            // 🔥 BOTÃO SALVAR
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print("Tarefa salva!");
                  Navigator.pop(context); // volta pra home
                },
                child: Text(
                  "Salvar",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 10),
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
        borderRadius: BorderRadius.circular(10),
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? cor.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selecionado ? cor : Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(width: 10, height: 10, color: cor),
            SizedBox(width: 5),
            Text(texto),
          ],
        ),
      ),
    );
  }
}