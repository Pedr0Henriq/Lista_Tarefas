import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaAjuda extends StatelessWidget {
  const TelaAjuda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo/logo.png',
                scale: 1,
              ),
            ),
            const SizedBox(height: 30),
            const AjudaSection(
              title: 'O que é?',
              description:
                  'O Tarefa+ é um gerenciador de tarefas intuitivo que permite criar, organizar e acompanhar compromissos de forma prática. Com uma interface simples e personalizável, ele ajuda a aumentar a produtividade, oferecendo lembretes, categorização e sincronização para manter suas atividades sempre em dia.',
            ),
            const SizedBox(height: 20),
            const AjudaSection(
              title: 'Como usar?',
              description:
                  'O Tarefa+ permite ao usuário logar com cadastro ou Google. Na Página Inicial, as tarefas são divididas em pendentes, fazendo e feitas, podendo ser movidas entre as seções com arraste, excluídas ou editadas. Para adicionar uma tarefa, clique no botão +, preencha título, descrição e data de expiração. A data de criação é preenchida automaticamente. Clicando em uma tarefa, o usuário pode visualizar a descrição. Na Tela de perfil, o usuário vê sua foto e nome, além de poder exportar tarefas para seu dispositivo e fazer logout.',
            ),
          ],
        ),
      ),
    );
  }
}

class AjudaSection extends StatelessWidget {
  final String title;
  final String description;

  const AjudaSection({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [Color(0xFF333232), Color(0xFF737373)],
            ),
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(37),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              description,
              style: GoogleFonts.roboto(fontSize: 15, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}
