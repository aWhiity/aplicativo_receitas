import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddRecipeView extends StatefulWidget {
  final RecipesRepository recipesRepository;

  const AddRecipeView({super.key, required this.recipesRepository});

  @override
  State<AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<AddRecipeView> {
  final int widthContainers = 0;
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  List<TextEditingController> _ingredientControllers = [];
  List<TextEditingController> _quantityControllers = [];

  List<Widget> ingredients = [];
  //List<TextEditingController> _ingredientsController =
  //new List<TextEditingController>();

  void addNewIngredient() {
    TextEditingController ingredientController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    setState(() {
      ingredients.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ingrediente ${ingredients.length + 1}:"),
            Row(
              children: [
                Container(
                  width: 275,
                  height: 35,
                  child: TextField(
                    style: TextStyle(fontSize: 15),
                    controller: ingredientController,
                  ),
                ),
                IconButton(
                  onPressed:
                      () => removeIngredient(
                        _ingredientControllers.indexOf(ingredientController),
                      ),
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Color(0xFFb85a34),
                    size: 30,
                  ),
                ),
              ],
            ),
            Text("Quantidade:"),
            Container(
              width: 170,
              height: 35,
              child: TextField(
                style: TextStyle(fontSize: 15),
                controller: quantityController,
                decoration: InputDecoration(
                  hintText: "Ex: 500g / 1 xícara",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 157, 157, 157),
                  ),
                ),
              ),
            ),
            SizedBox(height: 13),
            DottedLine(
              dashColor: Color(0xffc1c1c1),
              lineThickness: 1,
              dashLength: 5,
              dashGapLength: 4,
            ),
          ],
        ),
      );
    });
    _ingredientControllers.add(ingredientController);
    _quantityControllers.add(quantityController);
  }

  void removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
      _ingredientControllers.removeAt(index);
      _quantityControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe2e2e2),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {},
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          "Nova Receita",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
          child: Theme(
            data: ThemeData(
              textTheme: TextTheme(
                bodyMedium: TextStyle(fontSize: 11.0, color: Color(0xFF4C4C4C)),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                  borderSide: BorderSide(color: Color(0xffe7e7e7), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                  borderSide: BorderSide(color: Color(0xFFd98b0e), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                  borderSide: BorderSide(color: Color(0xffe7e7e7), width: 1.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 12,
                ),
                filled: true,
                fillColor: Color(0xFFf7f7f7),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nome da Receita:'),
                        Container(
                          width: 245,
                          height: 35,
                          child: TextField(
                            controller: _recipeNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                            ),
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xfff7f7f7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () => {},
                          icon: Icon(Icons.photo_size_select_actual_rounded),
                          iconSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text('Descrição:'),
                Container(
                  width: 500,
                  height: 120,
                  child: TextField(
                    maxLines: 4,
                    maxLength: 150,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Text('Tempo de Preparo:'),
                Text('\t(Hora e Minuto)', style: TextStyle(fontSize: 10)),
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      child: TextField(
                        controller: _hoursController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "00",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      ":",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 45,
                      height: 45,
                      child: TextField(
                        controller: _minutesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "00",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Ingredientes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 540,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 1.0,
                      horizontal: 3.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            addNewIngredient();
                          },
                          icon: Icon(
                            Icons.add,
                            size: 25,
                            color: Color(0xff787878),
                          ),
                          label: Text(
                            'Ingrediente',
                            style: TextStyle(color: Color(0xff787878)),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: Color(0xff787878),
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return ingredients[index];
                  },
                ),
                Text(
                  'Modo de Preparo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
