class Recipe {
  final String id;
  final String name;
  String desc;
  Duration preparationTime;
  String imagePath;

  Recipe({
    required this.id,
    required this.name,
    required this.desc,
    required this.preparationTime,
    required this.imagePath,
  });
}
