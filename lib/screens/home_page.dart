import 'package:flutter/material.dart';
import 'package:meu_app/screens/nova_tarefa_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String, dynamic>> tarefas = [
    {"nome": "Estudar UX", "cor": Color.fromARGB(255, 255, 17, 0), "concluido": false},
    {"nome": "Academia", "cor": Color.fromARGB(255, 255, 244, 144), "concluido": false},
    {"nome": "Fazer Trabalho", "cor": Color.fromARGB(255, 84, 255, 90), "concluido": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),

            Text(
              "Minhas Tarefas",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),

            Divider(color: Colors.grey.shade300),

            ...List.generate(tarefas.length, (index) {
              return tarefa(index);
            }),

            SizedBox(height: 10),

            // 🔥 BOTÃO COM MÃOZINHA
            Align(
              alignment: Alignment.centerRight,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NovaTarefaPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.purple,
                          Colors.pink,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),

            Divider(color: Colors.grey.shade300),

            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget tarefa(int index) {
    var item = tarefas[index];

    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click, // 🔥 mãozinha na tarefa
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  item["concluido"] = !item["concluido"];
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Checkbox(
                      value: item["concluido"],
                      onChanged: (v) {
                        setState(() {
                          item["concluido"] = v!;
                        });
                      },
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        item["nome"],
                        style: TextStyle(
                          fontSize: 18,
                          decoration: item["concluido"]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),

                    CircleAvatar(
                      radius: 6,
                      backgroundColor: item["cor"],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Divider(color: Colors.grey.shade300),
      ],
    );
  }
}