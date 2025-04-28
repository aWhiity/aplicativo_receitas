import 'package:aplicativo_receitas/models/recipe.dart';

class RecipesRepository {
  static final List<Recipe> _receitas = [];

  static List<Recipe> listarReceitas() {
    return _receitas;
  }

  static void adicionarReceita(Recipe receita) {
    _receitas.add(receita);
  }
}
