import 'package:flutter/material.dart';

class ExcluirTarefaDialog extends StatelessWidget {
  const ExcluirTarefaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text("Excluir tarefa"),
      content: const Text("Tem certeza que deseja excluir essa tarefa?"),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text("Cancelar"),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text("Excluir"),
        ),
      ],
    );
  }
}