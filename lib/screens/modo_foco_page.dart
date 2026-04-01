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
    setState(() => rodando = true);

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
    setState(() => rodando = false);
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Modo Foco"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          // 🔥 AQUI É O SEGREDO
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),

            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),

                border: isDark
                    ? Border.all(color: Colors.white.withOpacity(0.08))
                    : null,

                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),

              child: Column(
                children: [
                  Text(
                    formatar(tempoRestante),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),

                  const SizedBox(height: 20),

                  CircularProgressIndicator(
                    value: progresso,
                    strokeWidth: 8,
                    backgroundColor: theme.dividerColor,
                    valueColor: const AlwaysStoppedAnimation(
                      Color(0xFF7F00FF),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: iniciar, icon: const Icon(Icons.play_arrow)),
                      IconButton(onPressed: pausar, icon: const Icon(Icons.pause)),
                      IconButton(onPressed: resetar, icon: const Icon(Icons.restart_alt)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerTempo,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Minutos",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: definirTempoCustom,
                        child: const Text("OK"),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text("Nome: ${tarefa['nome'] ?? ''}"),
                  Text("Data: ${tarefa['data'] ?? ''}"),
                  Text("Obs: ${tarefa['observacao'] ?? ''}"),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(child: botao("Concluir", Colors.green, concluirTarefa)),
                      const SizedBox(width: 10),
                      Expanded(child: botao("Sair", Colors.red, () {
                        Navigator.pop(context);
                      })),
                    ],
                  ),
                ],
              ),
            ),
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
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(texto),
      ),
    );
  }
}