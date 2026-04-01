import 'package:flutter/material.dart';
import 'modo_foco_page.dart';
import 'editar_tarefa_page.dart';

class DetalhesTarefaPage extends StatelessWidget {
  final Map<String, dynamic> tarefa;

  const DetalhesTarefaPage({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Detalhes da Tarefa"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 💎 CARD MODERNO COM BORDA SUAVE NO DARK
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),

                // 🌙 DARK = BORDA SUAVE | ☀️ LIGHT = SOMBRA
                border: isDark
                    ? Border.all(
                        color: Colors.white.withOpacity(0.08), // 👈 SUAVE
                      )
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _info(context, "Nome", tarefa["nome"] ?? ""),
                  _info(context, "Data", tarefa["data"] ?? ""),
                  _info(context, "Observação", tarefa["observacao"] ?? ""),
                  _info(context, "Prioridade", tarefa["prioridade"] ?? ""),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Botao("Editar", Colors.blue, () async {
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditarTarefaPage(tarefa: tarefa),
                          ),
                        );

                        if (resultado != null) {
                          Navigator.pop(context, resultado);
                        }
                      }),

                      _Botao("Excluir", Colors.red, () async {
                        final confirmar = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: theme.cardColor,
                            title: Text(
                              "Excluir tarefa",
                              style: TextStyle(
                                  color: theme.textTheme.titleLarge?.color),
                            ),
                            content: Text(
                              "Tem certeza que deseja excluir?",
                              style: TextStyle(
                                  color: theme.textTheme.bodyMedium?.color),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      color: theme.textTheme.bodyMedium?.color),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text("Excluir"),
                              ),
                            ],
                          ),
                        );

                        if (confirmar == true) {
                          Navigator.pop(context, "excluir");
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 🚀 BOTÃO FOCO
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModoFocoPage(tarefa: tarefa),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Iniciar foco",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(BuildContext context, String titulo, String valor) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: 15,
          ),
          children: [
            TextSpan(
              text: "$titulo: ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }
}

class _Botao extends StatelessWidget {
  final String texto;
  final Color cor;
  final VoidCallback onTap;

  const _Botao(this.texto, this.cor, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: cor.withOpacity(0.15),
        foregroundColor: cor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}