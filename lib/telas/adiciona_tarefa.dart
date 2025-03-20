import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_tarefas/servicos/servico_bd.dart';
import 'package:lista_tarefas/tarefas/tarefa.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class Label extends StatefulWidget {
  final String tipo;
  TextEditingController controlador;
  Label({super.key, required this.tipo, required this.controlador});

  @override
  State<Label> createState() => LabelState();
}

class LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient:
                LinearGradient(colors: [Color(0xFF000000), Color(0xFF737373)])),
        child: TextFormField(
          controller: widget.controlador,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.white,
              labelText: widget.tipo,
              labelStyle: GoogleFonts.roboto(
                  fontSize: 19, color: Color.fromRGBO(0, 0, 0, 0.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none)),
          readOnly: (widget.tipo.contains("Data")) ? true : false,
          onChanged: (widget.tipo.contains("Data de Expiração"))
              ? null
              : (value) {
                  setState(() {
                    widget.controlador.text = value;
                  });
                },
          onTap: (widget.tipo.contains("Data de Expiração"))
              ? () async {
                  DateTime? picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2026),
                      initialDate: DateTime.now());
                  if (picked != null) {
                    setState(() {
                      widget.controlador.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                    });
                  }
                }
              : null,
        ),
      ),
    );
  }
}

mostrarTelaAddTarefa(BuildContext context, {Tarefa? tarefa}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) {
      return AdicionaTarefa(tarefa: tarefa);
    },
  );
}

class AdicionaTarefa extends StatefulWidget {
  final Tarefa? tarefa;
  const AdicionaTarefa({super.key, this.tarefa});

  @override
  State<AdicionaTarefa> createState() => _AdicionaTarefaState();
}

class _AdicionaTarefaState extends State<AdicionaTarefa> {
  Servico_BD servicoBd = Servico_BD();
  TextEditingController titulo = TextEditingController();
  TextEditingController descricao = TextEditingController();
  TextEditingController dataExpiracao = TextEditingController();
  bool carregando = false;

  String _status = "Pendente"; 

  @override
  void initState() {
    if (widget.tarefa != null) {
      titulo.text = widget.tarefa!.titulo;
      descricao.text = widget.tarefa!.descricao;
      dataExpiracao.text = widget.tarefa!.dataExpiracao;
      _status = widget.tarefa!.classe; 
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ),
            Text(
              (widget.tarefa != null) ? 'Editar Tarefa' : 'Adicionar Tarefa',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Label(tipo: 'Título', controlador: titulo),
            const SizedBox(height: 10),
            Label(tipo: 'Descrição', controlador: descricao),
            const SizedBox(height: 10),
            Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient:
                LinearGradient(colors: [Color(0xFF000000), Color(0xFF737373)])),
        child: TextFormField(
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.white,
              labelText: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              labelStyle: GoogleFonts.roboto(
                  fontSize: 19, color: Color.fromRGBO(0, 0, 0, 0.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none)),
          readOnly: true,),),),
            const SizedBox(height: 10),
            Label(tipo: 'Data de Expiração', controlador: dataExpiracao),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: "Fazendo",
                        groupValue: _status,
                        onChanged: (value) {
                          setState(() {
                            _status = value.toString();
                          });
                        },
                      ),
                      Text("Fazendo",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "Pendente",
                        groupValue: _status,
                        onChanged: (value) {
                          setState(() {
                            _status = value.toString();
                          });
                        },
                      ),
                      Text("Pendente",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "Concluída",
                        groupValue: _status,
                        onChanged: (value) {
                          setState(() {
                            _status = value.toString();
                          });
                        },
                      ),
                      Text("Concluída",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() => carregando = true);

                String tituloTarefa = titulo.text;
                String descricaoTarefa = descricao.text;
                String data = dataExpiracao.text;

                Tarefa tarefa = Tarefa(
                  id: const Uuid().v1(),
                  titulo: tituloTarefa,
                  descricao: descricaoTarefa,
                  dataExpiracao: data,
                  classe: _status, 
                );

                if (widget.tarefa != null) {
                  tarefa.id = widget.tarefa!.id;
                }

                servicoBd.adicionarTarefa(tarefa).then((value) {
                  carregando = false;
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    (widget.tarefa != null)
                        ? 'Tarefa Editada'
                        : 'Tarefa Adicionada',
                    style: GoogleFonts.roboto(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: carregando
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      (widget.tarefa != null) ? 'Salvar' : 'Adicionar',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
