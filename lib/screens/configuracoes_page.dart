import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  final bool modoEscuroAtual; // 🔥 recebe do app

  // 🔥 ADICIONEI (não remove nada)
  final Function(bool) onTemaChanged;

  const ConfiguracoesPage({
    super.key,
    required this.modoEscuroAtual,

    // 🔥 ADICIONEI (obrigatório agora)
    required this.onTemaChanged,
  });

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  late bool modoEscuro;
  bool limparConcluidas = false;

  @override
  void initState() {
    super.initState();

    // 🔥 AGORA ELE PEGA O VALOR REAL
    modoEscuro = widget.modoEscuroAtual;
  }

  void salvar() {
    Navigator.pop(context, {
      "modoEscuro": modoEscuro,
      "limpar": limparConcluidas,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Configurações"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
        titleTextStyle: TextStyle(
          color: theme.textTheme.titleLarge?.color,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // 🌙 MODO ESCURO
          _itemConfiguracao(
            context,
            titulo: "Modo escuro",
            icone: Icons.dark_mode,
            valor: modoEscuro,
            onChanged: (value) {
              setState(() {
                modoEscuro = value;
              });

              // 🔥 ADICIONEI (atualiza na hora)
              widget.onTemaChanged(value);
            },
          ),

          const SizedBox(height: 10),

          // 🧹 LIMPAR
          _itemConfiguracao(
            context,
            titulo: "Limpar tarefas concluídas",
            icone: Icons.cleaning_services,
            valor: limparConcluidas,
            onChanged: (value) {
              setState(() {
                limparConcluidas = value;
              });
            },
          ),

          const SizedBox(height: 30),

          // 🔥 BOTÃO
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: salvar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Salvar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemConfiguracao(
    BuildContext context, {
    required String titulo,
    required IconData icone,
    required bool valor,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icone, color: theme.iconTheme.color),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 15,
              ),
            ),
          ),

          Switch(
            value: valor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}