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
        content: Text("Evento adicionado ao Google Calendar"),
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

    // ✅ ADICIONADO (NOTIFICAÇÃO)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Tarefa criada com sucesso"),
        backgroundColor: Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    // ✅ ADICIONADO (PEQUENO DELAY PRA APARECER)
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context, novaTarefa);
    });
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

        leading: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        centerTitle: true,

        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Nova Tarefa",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
        ),
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

                TextField(
                  controller: nomeController,
                  decoration: inputStyle(context, "Nome"),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 55,
                  child: TextField(
                    controller: dataController,
                    readOnly: true,
                    decoration: inputStyle(context, "Data").copyWith(
                      suffixIcon: Icon(Icons.calendar_today, color: theme.iconTheme.color),
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
                  decoration: inputStyle(context, "Observação"),
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
                    prioridadeBox(context, "Alta", Colors.redAccent),
                    const SizedBox(width: 12),
                    prioridadeBox(context, "Média", Colors.orangeAccent),
                    const SizedBox(width: 12),
                    prioridadeBox(context, "Baixa", Colors.greenAccent),
                  ],
                ),

                const SizedBox(height: 40),

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
          );
        },
      ),
    );
  }

  InputDecoration inputStyle(BuildContext context, String label) {
    final theme = Theme.of(context);

    return InputDecoration(
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
        borderSide: const BorderSide(
          color: Color(0xFF7F00FF),
          width: 1.5,
        ),
      ),
    );
  }

  Widget prioridadeBox(BuildContext context, String texto, Color cor) {
    final theme = Theme.of(context);
    bool selecionado = prioridade == texto;

    return GestureDetector(
      onTap: () => setState(() => prioridade = texto),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selecionado ? cor : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selecionado
                ? cor
                : theme.dividerColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: selecionado
                ? Colors.white
                : theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}