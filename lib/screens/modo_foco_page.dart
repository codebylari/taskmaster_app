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
                backgroundColor: theme.primaryColor,
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

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,

        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Modo Foco",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ],
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

          return Align(
            alignment: Alignment.topCenter, // 🔥 sobe o card
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                margemHorizontal,
                10,
                margemHorizontal,
                20,
              ),

              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          theme.brightness == Brightness.dark ? 0.5 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),

                child: Column(
                  children: [
                    Text(
                      formatar(tempoRestante),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),

                    const SizedBox(height: 25),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progresso,
                        minHeight: 10,
                        backgroundColor: theme.dividerColor,
                        valueColor: AlwaysStoppedAnimation(
                          theme.primaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _botaoIcon(Icons.play_arrow, iniciar),
                        const SizedBox(width: 10),
                        _botaoIcon(Icons.pause, pausar),
                        const SizedBox(width: 10),
                        _botaoIcon(Icons.restart_alt, resetar),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          child: TextField(
                            controller: controllerTempo,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: theme.scaffoldBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: definirTempoCustom,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                          ),
                          child: const Text("OK"),
                        )
                      ],
                    ),

                    const SizedBox(height: 25),

                    Divider(color: theme.dividerColor),

                    const SizedBox(height: 10),

                    Text("Nome: ${tarefa['nome'] ?? ''}",
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color)),

                    Text("Data: ${tarefa['data'] ?? ''}",
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color)),

                    Text("Obs: ${tarefa['observacao'] ?? ''}",
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color)),

                    Text("Prioridade: ${tarefa['prioridade'] ?? ''}",
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color)),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: _botaoAcao("Concluir", Colors.green, concluirTarefa),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 120,
                          child: _botaoAcao("Sair", Colors.red, () {
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
        },
      ),
    );
  }

  Widget _botaoIcon(IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: theme.iconTheme.color),
        ),
      ),
    );
  }

  Widget _botaoAcao(String texto, Color cor, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: cor.withOpacity(0.12),
        foregroundColor: cor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}