import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import 'package:lista_tarefas/tarefas/tarefa.dart';
import 'dart:io';

class Exportar {
  static Future<void> exportarTarefasPDF(
      List<Tarefa> tarefas, BuildContext context) async {
    try {
      // Cria o documento PDF
      final pdf = pw.Document();

      // Agrupa as tarefas por status
      Map<String, List<Tarefa>> tarefasAgrupadas = {
        'Pendente': [],
        'Fazendo': [],
        'Concluída': [],
      };

      for (var tarefa in tarefas) {
        tarefasAgrupadas[tarefa.classe]?.add(tarefa);
      }

      // Adiciona uma nova página ao documento
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Título centralizado
            pw.Center(
              child: pw.Text(
                "Lista de Tarefas",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            // Tabela de tarefas
            ...tarefasAgrupadas.entries.map((entry) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Título do status (Pendente, Fazendo, Concluída)
                  pw.Text(
                    entry.key,
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  // Tabela de tarefas
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(1),
                      1: pw.FlexColumnWidth(3),
                      2: pw.FlexColumnWidth(4),
                      3: pw.FlexColumnWidth(2),
                      4: pw.FlexColumnWidth(2),
                    },
                    children: [
                      // Cabeçalho da tabela
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              "Id",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              "Título",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              "Descrição",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              "Data de Criação",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              "Data de Expiração",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      // Linhas da tabela com as tarefas
                      ...entry.value.map((tarefa) {
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(tarefa.id.toString()),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(tarefa.titulo),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(tarefa.descricao),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(tarefa.dataInicio),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(tarefa.dataExpiracao),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                ],
              );
            }).toList(),
            // Informações do usuário e data de exportação
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Usuário: nome usuário"),
                pw.Text("Data de Exportação: ${DateTime.now().toString()}"),
              ],
            ),
          ];
        },
      ));

      // Salva o arquivo PDF no diretório de downloads
      final dir = Directory('/storage/emulated/0/Download');
      File file = File("${dir.path}/tarefas.pdf");
      await file.writeAsBytes(await pdf.save());

      // Mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "PDF exportado com sucesso!",
            style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green[800],
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Mostra uma mensagem de erro caso algo dê errado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red[800],
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}