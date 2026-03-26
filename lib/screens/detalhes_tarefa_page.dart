import 'package:flutter/material.dart';

class DetalhesTarefaPage extends StatelessWidget {
  final Map<String, dynamic> tarefa;

  const DetalhesTarefaPage({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 40),

            // 🔙 Voltar + título
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Detalhes da Tarefa",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 📦 Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Nome: ${tarefa["nome"]}"),
                  const SizedBox(height: 10),

                  const Text("Data: 20/04/2026"),
                  const Text("Observação: Provas em Breve"),
                  const Text("Prioridade: Alta"),

                  const SizedBox(height: 20),

                  // 🔥 BOTÕES PADRONIZADOS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _Botao("Editar"),
                      _Botao("Excluir"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🎯 Ação
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow, color: Colors.red),
                label: const Text("Iniciar foco"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔥 COMPONENTE REUTILIZÁVEL (deixa o código menor)
class _Botao extends StatelessWidget {
  final String texto;

  const _Botao(this.texto);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(texto),
    );
  }
}