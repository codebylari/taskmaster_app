import 'package:flutter/material.dart';

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
        centerTitle: true,
        toolbarHeight: 90,
        title: Text(
          "Sobre nós",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(22),
                border: isDark
                    ? Border.all(
                        color: Colors.white.withOpacity(0.06),
                      )
                    : null,
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      "assets/images/sobre.png",
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Organiza+",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "O Organiza+ foi desenvolvido com o objetivo "
                    "de tornar a organização do dia a dia mais "
                    "simples, prática e eficiente.\n\n"
                    "A proposta do aplicativo é oferecer uma "
                    "ferramenta leve, intuitiva e agradável, "
                    "permitindo que qualquer pessoa consiga "
                    "organizar tarefas, compromissos e metas "
                    "de maneira rápida.\n\n"
                    "Com um visual moderno e foco na usabilidade, "
                    "o aplicativo busca proporcionar uma experiência "
                    "clara e confortável para o usuário.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color:
                          theme.textTheme.bodyMedium?.color,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Divider(color: theme.dividerColor),

                  const SizedBox(height: 10),

                  Text(
                    "Versão 1.0",
                    style: TextStyle(
                      color: theme.hintColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Desenvolvido por Larissa",
                    style: TextStyle(
                      color: theme.hintColor,
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