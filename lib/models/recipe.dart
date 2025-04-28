class Recipe {
  final String id;
  final String nome;
  String desc;
  Duration tempoPreparacao;
  String imagePath;

  Recipe({
    required this.id,
    required this.nome,
    required this.desc,
    required this.tempoPreparacao,
    required this.imagePath,
  });
}
