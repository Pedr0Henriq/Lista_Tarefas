import 'package:firebase_auth/firebase_auth.dart';

class Autenticacao {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> cadastrarUsuario(
      {required String email,
      required String usuario,
      required String senha}) async {
    try {
      UserCredential usuarioCredencial = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);

      await usuarioCredencial.user!.updateDisplayName(usuario);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "E-mail já cadastrado";
      }
      return "Erro desconhecido";
    }
  }

  Future<String?> logarUsuario({required String email, required String senha})async{

    try {
  await _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
  return null;
} on FirebaseAuthException catch (e) {
  return e.message;
}
  }

  Future<void> deslogar()async {
    return _firebaseAuth.signOut();
  }

  nomeUsuario(){
    return _firebaseAuth.currentUser!.displayName;
  }
}
