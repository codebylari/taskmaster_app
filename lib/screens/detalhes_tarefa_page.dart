import 'package:flutter/material.dart';
import 'modo_foco_page.dart';
import 'editar_tarefa_page.dart';
import 'excluir_tarefa_dialog.dart';

class DetalhesTarefaPage extends StatelessWidget {
  final Map<String, dynamic> tarefa;

  const DetalhesTarefaPage({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // 🔙 HEADER
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Detalhes da Tarefa",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 💎 CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _info("Nome", tarefa["nome"] ?? ""),
                  _info("Data", tarefa["data"] ?? ""),
                  _info("Observação", tarefa["observacao"] ?? ""),
                  _info("Prioridade", tarefa["prioridade"] ?? ""),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ✏️ EDITAR (CORRIGIDO)
                      _Botao("Editar", Colors.blue, () async {
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditarTarefaPage(tarefa: tarefa),
                          ),
                        );

                        if (resultado != null) {
                          Navigator.pop(context, resultado); // 👈 ESSA LINHA RESOLVE TUDO
                        }
                      }),

                      // 🗑️ EXCLUIR (já correto)
                      _Botao("Excluir", Colors.red, () async {
                        final confirmar = await showDialog(
                          context: context,
                          builder: (_) => const ExcluirTarefaDialog(),
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

            const SizedBox(height: 30),

            // 🚀 FOCO
            Center(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Iniciar foco",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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

  Widget _info(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87),
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
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}