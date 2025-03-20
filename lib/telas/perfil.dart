import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_tarefas/servicos/autenticacao.dart';
import 'package:lista_tarefas/servicos/exportar.dart';
import 'package:lista_tarefas/servicos/servico_bd.dart';
import 'package:lista_tarefas/tarefas/tarefa.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  @override
  Widget build(BuildContext context) {
    bool exportando = false;
    Autenticacao autenticacao = Autenticacao();
    Servico_BD servico = Servico_BD();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  gradient: LinearGradient(
                      colors: [Color(0xFF000000), Color(0xFF737373)]),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(77)),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 100,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                autenticacao.nomeUsuario(),
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50)),
            GestureDetector(
              onTap: () async {
                setState(() {
                  exportando = true;
                });
                var snapshot = await servico.conectarStreamTarefas().first;
                List<Tarefa> tarefas = snapshot.docs
                    .map((doc) => Tarefa.fromMap(doc.data()))
                    .toList();

                await Exportar.exportarTarefasPDF(tarefas, context)
                    .then((value) {
                  exportando = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Exportação Concluída',
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ));
                });
              },
              child: (exportando == true)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Image.asset(
                      'assets/images/botoes/botao_exportar.png',
                      scale: 2,
                    ),
            ),
            GestureDetector(
              child: Image.asset(
                'assets/images/botoes/botao_sair.png',
                scale: 2,
              ),
              onTap: () {
                autenticacao.deslogar();
              },
            )
          ],
        ),
      ),
    );
  }
}
