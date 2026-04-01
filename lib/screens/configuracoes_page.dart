import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracoesPage extends StatefulWidget {
  final bool modoEscuroAtual;
  final Function(bool) onTemaChanged;

  const ConfiguracoesPage({
    super.key,
    required this.modoEscuroAtual,
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
    modoEscuro = widget.modoEscuroAtual;

    _carregarPreferencias(); // 🔥 NOVO
  }

  // 🔥 CARREGA DO CELULAR
  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = prefs.getBool("modoEscuro");

    if (salvo != null) {
      setState(() {
        modoEscuro = salvo;
      });
    }
  }

  Future<void> salvarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("modoEscuro", modoEscuro);
  }

  void salvar() async {
    await salvarPreferencias();

    widget.onTemaChanged(modoEscuro);

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
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          _itemConfiguracao(
            context,
            titulo: "Modo escuro",
            icone: Icons.dark_mode,
            valor: modoEscuro,
            onChanged: (value) async {
              setState(() => modoEscuro = value);
              await salvarPreferencias(); // 🔥 salva na hora
            },
          ),

          const SizedBox(height: 12),

          _itemConfiguracao(
            context,
            titulo: "Limpar tarefas concluídas",
            icone: Icons.cleaning_services,
            valor: limparConcluidas,
            onChanged: (value) {
              setState(() => limparConcluidas = value);
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: salvar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text("Salvar"),
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icone, size: 20, color: theme.iconTheme.color),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyLarge?.color,
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