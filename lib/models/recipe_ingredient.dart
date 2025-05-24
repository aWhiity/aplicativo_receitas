class RecipeIngredient {
  String name;
  String quantity;

  RecipeIngredient({required this.name, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity': quantity};
  }

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(name: map['name'], quantity: map['quantity']);
  }
}
