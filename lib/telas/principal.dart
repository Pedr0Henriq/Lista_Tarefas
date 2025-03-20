import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_tarefas/servicos/servico_bd.dart';
import 'package:lista_tarefas/tarefas/tarefa.dart';
import 'package:lista_tarefas/telas/adiciona_tarefa.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 55, top: 40),
          child: Column(
            children: [
              const SizedBox(height: 20),
              IconButton(
                onPressed: () {
                  mostrarTelaAddTarefa(context);
                },
                iconSize: 60,
                icon: const Icon(Icons.add_circle_outline),
              ),
              const SizedBox(height: 20),
              TaskSection(title: 'Pendente'),
              const SizedBox(height: 20),
              TaskSection(title: 'Fazendo'),
              const SizedBox(height: 20),
              TaskSection(title: 'Concluída'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskSection extends StatelessWidget {
  final String title;
  final Servico_BD servico = Servico_BD();

  TaskSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF737373)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(37),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            StreamBuilder(
              stream: servico.conectarStreamTarefas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma tarefa encontrada.',
                      style: GoogleFonts.roboto(),
                    ),
                  );
                }

                // Filtra as tarefas pelo status correspondente à seção
                List<Tarefa> listaTarefas = snapshot.data!.docs
                    .map((doc) => Tarefa.fromMap(doc.data()))
                    .where((tarefa) => tarefa.classe == title)
                    .toList();

                return listaTarefas.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhuma tarefa $title.',
                          style: GoogleFonts.roboto(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listaTarefas.length,
                        itemBuilder: (context, index) {
                          Tarefa tarefa = listaTarefas[index];
                          return _buildTaskItem(context, tarefa);
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Tarefa tarefa) {
    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              mostrarTelaAddTarefa(context, tarefa: tarefa);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              SnackBar snackBar = SnackBar(
                content: Text(
                  'Deseja remover ${tarefa.titulo}?',
                  style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                action: SnackBarAction(
                  label: 'REMOVER',
                  textColor: Colors.black,
                  onPressed: () {
                    servico.removerTarefa(idTarefa: tarefa.id);
                  },
                ),
                showCloseIcon: true,
                closeIconColor: Colors.black,
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.yellow,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      title: Text(
        tarefa.titulo,
        style: GoogleFonts.roboto(
          fontSize: 20,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
