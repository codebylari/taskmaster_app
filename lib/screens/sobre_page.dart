import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
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

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: larguraTela > 1200
                  ? 1000
                  : larguraTela > 800
                      ? larguraTela * 0.9
                      : larguraTela,
            ),

            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: isDark
                    ? Border.all(color: Colors.white.withOpacity(0.06))
                    : null,
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        )
                      ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔥 ÍCONE
                  Center(
                    child: Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          "assets/icon.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    "Organiza+",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "O Organiza+ é um aplicativo desenvolvido com o objetivo "
                    "de tornar a organização do dia a dia mais simples, prática e eficiente.\n\n"
                    "A proposta do aplicativo é oferecer uma ferramenta leve, intuitiva "
                    "e acessível, permitindo que qualquer pessoa consiga organizar suas "
                    "tarefas sem esforço.\n\n"
                    "Com foco em produtividade e clareza, o Organiza+ ajuda você a manter "
                    "sua rotina sob controle, evitando esquecimentos e melhorando sua "
                    "organização pessoal.\n\n"
                    "O projeto está em constante evolução, sempre buscando melhorias na "
                    "experiência do usuário.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Divider(color: theme.dividerColor),

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 28),

                  //  IMAGEM 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/sobre.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}