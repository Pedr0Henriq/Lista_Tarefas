
class Tarefa {
  String id;
  String titulo;
  String descricao;
  String dataExpiracao;
  String dataInicio = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  String classe;

  Tarefa({required this.id, required this.titulo, required this.descricao, required this.dataExpiracao,required this.classe});

  Tarefa.fromMap(Map<String,dynamic> map)
    : id = map['id'],
      titulo = map['titulo'],
      descricao = map['descricao'],
      dataExpiracao = map['dataExpiracao'],
      dataInicio = map['dataInicio'],
      classe = map['classe'];
  
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'titulo':titulo,
      'descricao':descricao,
      'dataExpiracao': dataExpiracao,
      'dataInicio': dataInicio,
      'classe':classe,
    };
  }

}