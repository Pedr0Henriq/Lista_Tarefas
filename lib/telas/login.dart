import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_tarefas/servicos/autenticacao.dart';

// ignore: must_be_immutable
class NomeLabel extends StatefulWidget {
  final String tipo;
  TextEditingController controlador;
  NomeLabel({super.key, required this.tipo, required this.controlador});

  @override
  State<NomeLabel> createState() => _NomeLabelState();
}

class _NomeLabelState extends State<NomeLabel> {
  @override
  Widget build(BuildContext context) {
    if (!widget.tipo.contains('Senha')) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                  colors: [Color(0xFF000000), Color(0xFF737373)])),
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
            onChanged: (value) {
              setState(() {
                widget.controlador.text = value;
              });
            },
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                  colors: [Color(0xFF000000), Color(0xFF737373)])),
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
            obscureText: true,
            onChanged: (value) {
              setState(() {
                widget.controlador.text = value;
              });
            },
          ),
        ),
      );
    }
  }
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});
  static const routename = '/';

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  bool entrar = true;
  bool recuperarSenha = false;
  TextEditingController _emailControler = TextEditingController();
  TextEditingController _senhaControler = TextEditingController();
  TextEditingController _usuarioControler = TextEditingController();
  TextEditingController _repetirsenhaControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Autenticacao autenticacao = Autenticacao();
    return MaterialApp(
      home: Scaffold(
        body: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 5),
                child: Image.asset(
                  'assets/images/logo/logo.png',
                  scale: 1,
                ),
              ),
              NomeLabel(
                tipo: 'E-mail',
                controlador: _emailControler,
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: !entrar,
                  child: NomeLabel(
                    tipo: 'Usuário',
                    controlador: _usuarioControler,
                  )),
              const SizedBox(
                height: 10,
              ),
              NomeLabel(
                tipo: 'Senha',
                controlador: _senhaControler,
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: !entrar,
                  child: NomeLabel(
                    tipo: 'Repita a Senha',
                    controlador: _repetirsenhaControler,
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  child: Image.asset(
                    (entrar)
                        ? 'assets/images/botoes/botaoEntrar.png'
                        : 'assets/images/botoes/botao_cadastrar.png',
                    scale: 1.5,
                  ),
                  onTap: () async {
                    if (emailValido(_emailControler.text)) {
                      String email = _emailControler.text;
                      String usuario = _usuarioControler.text;
                      String senha = _senhaControler.text;
                      if (entrar) {
                        autenticacao
                            .logarUsuario(email: email, senha: senha)
                            .then((String? erro) {
                          if (erro != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                erro,
                                style: GoogleFonts.roboto(color: Colors.white),
                              ),
                              backgroundColor:
                                  Colors.red[400],
                              duration: Duration(seconds: 3),
                            ));
                          }
                        });
                      } else {
                        if (senha == _repetirsenhaControler.text) {
                          autenticacao
                              .cadastrarUsuario(
                                  email: email, usuario: usuario, senha: senha)
                              .then((String? erro) {
                            if (erro != null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                erro,
                                style: GoogleFonts.roboto(color: Colors.white),
                              ),
                              backgroundColor:
                                  Colors.red[400],
                              duration: Duration(seconds: 3),
                            ));
                            }
                          });
                          setState(() {
                            entrar = true;
                          });
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        entrar = !entrar;
                      });
                    },
                    child: Text(
                      (entrar) ? 'Cadastrar-se' : 'Faça Login',
                      style: GoogleFonts.roboto(
                          fontSize: 16, decoration: TextDecoration.underline),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool emailValido(String text) {
    if (!text.contains('@') || text.length < 5 || text.isEmpty) {
      return false;
    }
    return true;
  }
}
