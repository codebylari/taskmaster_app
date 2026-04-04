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

    _carregarPreferencias();
  }

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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Configurações",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: theme.textTheme.titleLarge?.color,
            ),
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

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: margemHorizontal,
              vertical: 20,
            ),
            children: [

              _itemConfiguracao(
                context,
                titulo: "Modo escuro",
                icone: Icons.dark_mode,
                valor: modoEscuro,
                onChanged: (value) async {
                  setState(() => modoEscuro = value);

                  await salvarPreferencias();

                  // 🔥 ESSA LINHA RESOLVE TUDO
                  widget.onTemaChanged(value);
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
                    backgroundColor: const Color(0xFF7F00FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Salvar"),
                ),
              ),
            ],
          );
        },
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
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.06))
            : null,
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Row(
        children: [
          Icon(icone, size: 20, color: theme.iconTheme.color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 15,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Switch(
            value: valor,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF7F00FF),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}