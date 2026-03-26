import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModoFocoPage extends StatefulWidget {
  final Map<String, dynamic> tarefa;

  const ModoFocoPage({super.key, required this.tarefa});

  @override
  State<ModoFocoPage> createState() => _ModoFocoPageState();
}

class _ModoFocoPageState extends State<ModoFocoPage> {
  int tempoTotal = 20 * 60;
  int tempoRestante = 20 * 60;

  Timer? timer;
  bool rodando = false;

  final TextEditingController controllerTempo =
      TextEditingController(text: "20");

  double get progresso => tempoRestante / tempoTotal;

  void iniciar() {
    if (rodando) return;

    rodando = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (tempoRestante > 0) {
        setState(() => tempoRestante--);
      } else {
        timer.cancel();
        rodando = false;

        HapticFeedback.mediumImpact();
      }
    });
  }

  void pausar() {
    timer?.cancel();
    rodando = false;
  }

  void resetar() {
    timer?.cancel();
    setState(() {
      tempoRestante = tempoTotal;
      rodando = false;
    });
  }

  void definirTempoCustom() {
    final minutos = int.tryParse(controllerTempo.text);
    if (minutos != null && minutos > 0) {
      setState(() {
        tempoTotal = minutos * 60;
        tempoRestante = tempoTotal;
      });
    }
  }

  String formatar(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return "$m:$sec";
  }

  void concluirTarefa() async {
  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 10),
          const Text(
            "Tarefa concluída! 🎉",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // fecha popup
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7F00FF),
            ),
            child: const Text("OK"),
          )
        ],
      ),
    ),
  );

  Navigator.pop(context);        // sai do modo foco
  Navigator.pop(context, true);  // sai dos detalhes e vai pra home com resultado
}

  @override
  void dispose() {
    timer?.cancel();
    controllerTempo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tarefa = widget.tarefa;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔙 VOLTAR
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                      ),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Modo Foco",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              // ⭕ CRONÔMETRO
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progresso,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF7F00FF),
                      ),
                    ),
                  ),
                  Text(
                    formatar(tempoRestante),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ▶️ CONTROLES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: iniciar,
                    icon: const Icon(Icons.play_arrow, color: Colors.purple),
                  ),
                  IconButton(
                    onPressed: pausar,
                    icon: const Icon(Icons.pause, color: Colors.orange),
                  ),
                  IconButton(
                    onPressed: resetar,
                    icon: const Icon(Icons.restart_alt, color: Colors.red),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ⌨️ INPUT TEMPO
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controllerTempo,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Minutos",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: definirTempoCustom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F00FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("OK"),
                  )
                ],
              ),

              const SizedBox(height: 15),

              // 📋 INFO
              Text("Nome: ${tarefa['nome'] ?? ''}"),
              Text("Data: ${tarefa['data'] ?? ''}"),
              Text("Obs: ${tarefa['observacao'] ?? ''}"),

              const SizedBox(height: 20),

              // 🔘 BOTÕES
              Row(
                children: [
                  Expanded(
                    child: botao("Concluir", Colors.green, concluirTarefa),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: botao("Sair", Colors.red, () {
                      Navigator.pop(context);
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget botao(String texto, Color cor, VoidCallback onTap) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(texto),
      ),
    );
  }
}