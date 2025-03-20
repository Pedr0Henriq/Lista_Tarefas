import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lista_tarefas/tarefas/tarefa.dart';

class Servico_BD {
  String usuarioId;
  Servico_BD() : usuarioId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarTarefa(Tarefa tarefa) async {
    return await _firestore
        .collection(usuarioId)
        .doc(tarefa.id)
        .set(tarefa.toMap());
  }

  Stream<QuerySnapshot<Map<String,dynamic>>> conectarStreamTarefas(){
    return _firestore.collection(usuarioId).snapshots();
  }
  Future<void> removerTarefa({required String idTarefa}){
    return _firestore.collection(usuarioId).doc(idTarefa).delete();
  }
}
