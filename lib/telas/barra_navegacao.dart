import 'package:flutter/material.dart';
import 'package:lista_tarefas/telas/principal.dart';
import 'package:lista_tarefas/telas/ajuda.dart';
import 'package:lista_tarefas/telas/perfil.dart';


class BarraNavegacao extends StatefulWidget {
  const BarraNavegacao({super.key});
  static const routename = '/barraNavegacao';
  @override
  State<BarraNavegacao> createState() => _BarraNavegacaoState();
}

class _BarraNavegacaoState extends State<BarraNavegacao> {
  int indiceAtual = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: IndexedStack(
        index: indiceAtual,
        children: <Widget>[
          TelaAjuda(),
          TelaPrincipal(),
          TelaPerfil(),

        ],
      ),



      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color.fromARGB(255, 51, 50, 50), Color(0xFF737373)],),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          currentIndex: indiceAtual,
          onTap: (value){
            setState(() {
            indiceAtual = value;  
            });},
          
          items: [
              BottomNavigationBarItem(
                  icon: Icon((Icons.help)),
                  label: 'Ajuda'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Página Inicial'),
              BottomNavigationBarItem(
                  icon: Icon((Icons.person)),
                  label: 'Perfil')
            ],
          ),
      ),
    );
  }
}
