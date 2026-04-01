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
    final theme = Theme.of(context);

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            Text(
              "Tarefa concluída! 🎉",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
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

    Navigator.pop(context);
    Navigator.pop(context, true);
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(25),

            // 🔥 borda no dark + sombra leve
            border: Border.all(color: theme.dividerColor),
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

              Text(
                "Modo Foco",
                style: TextStyle(
                  fontSize: 18,
                  color: theme.textTheme.bodyMedium?.color,
                ),
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
                      backgroundColor: theme.dividerColor,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF7F00FF),
                      ),
                    ),
                  ),
                  Text(
                    formatar(tempoRestante),
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
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

              // ⌨️ INPUT
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controllerTempo,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: "Minutos",
                        hintStyle: TextStyle(color: theme.hintColor),
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: definirTempoCustom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F00FF),
                    ),
                    child: const Text("OK"),
                  )
                ],
              ),

              const SizedBox(height: 15),

              // 📋 INFO
              Text("Nome: ${tarefa['nome'] ?? ''}",
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              Text("Data: ${tarefa['data'] ?? ''}",
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              Text("Obs: ${tarefa['observacao'] ?? ''}",
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color)),

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