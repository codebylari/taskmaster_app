import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  bool modoEscuro = false;
  bool limparConcluidas = false;

  void salvar() {
    Navigator.pop(context, {
      "modoEscuro": modoEscuro,
      "limpar": limparConcluidas,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          modoEscuro ? Colors.black : const Color(0xFFF7F8FA),

      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: modoEscuro ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
              )
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color:
                          modoEscuro ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color:
                          modoEscuro ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🌙 MODO ESCURO
              SwitchListTile(
                value: modoEscuro,
                onChanged: (value) {
                  setState(() {
                    modoEscuro = value;
                  });
                },
                title: Text(
                  "Modo escuro",
                  style: TextStyle(
                    color:
                        modoEscuro ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🧹 LIMPAR CONCLUÍDAS
              SwitchListTile(
                value: limparConcluidas,
                onChanged: (value) {
                  setState(() {
                    limparConcluidas = value;
                  });
                },
                title: Text(
                  "Limpar tarefas concluídas",
                  style: TextStyle(
                    color:
                        modoEscuro ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
        ),
      ),
    );
  }
}