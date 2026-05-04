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
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Configurações",
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

              const SizedBox(height: 12),

              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SobrePage()),
                  );
                },
                child: Container(
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
                      Icon(Icons.info_outline, size: 20, color: theme.iconTheme.color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Sobre nós",
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),

              // 🔥 BOTÃO DINÂMICO
              if (limparConcluidas) ...[
                const SizedBox(height: 20),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "modoEscuro": modoEscuro,
                        "limpar": true,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Confirmar limpeza"),
                  ),
                ),
              ],
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
            activeTrackColor: theme.primaryColor,
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

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
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sobre nós",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
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

              Container(
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Organiza+",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "O Organiza+ é um aplicativo desenvolvido com o objetivo de tornar "
                      "a organização do dia a dia mais simples, prática e eficiente.\n\n"
                      "A proposta do aplicativo é oferecer uma ferramenta leve, intuitiva "
                      "e acessível, permitindo que qualquer pessoa consiga organizar suas "
                      "tarefas sem esforço.\n\n"
                      "Com foco em produtividade e clareza, o Organiza+ ajuda você a manter "
                      "sua rotina sob controle, evitando esquecimentos e melhorando sua "
                      "organização pessoal.\n\n"
                      "O projeto está em constante evolução, sempre buscando melhorias na "
                      "experiência do usuário.",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Divider(color: theme.dividerColor),

                    const SizedBox(height: 10),

                    Text(
                      "Versão 1.0",
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.hintColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Desenvolvido por Larissa Soeiro",
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}