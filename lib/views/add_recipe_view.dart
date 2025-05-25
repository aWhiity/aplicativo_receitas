import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:aplicativo_receitas/models/recipe_ingredient.dart';
import 'package:aplicativo_receitas/repositories/firebase/recipes_repository_firebase.dart';
import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddRecipeView extends StatefulWidget {
  final RecipesRepository recipesRepository;
  final bool isEditing;
  final Recipe? recipeToEdit;

  const AddRecipeView({
    super.key,
    required this.recipesRepository,
    required this.isEditing,
    this.recipeToEdit,
  });

  @override
  State<AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<AddRecipeView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _pictureController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  List<TextEditingController> ingredientNameControllers = [];
  List<TextEditingController> quantityControllers = [];

  List<RecipeIngredient> ingredients = [];
  List<Widget> ingredientWidgets = [];
  int counter = 0;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.recipeToEdit != null) {
      fillFields(widget.recipeToEdit!);
    }
  }

  void addNewIngredientWidget() {
    final ingredientController = TextEditingController();
    final quantityController = TextEditingController();

    setState(() {
      ingredientWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ingrediente ${ingredientWidgets.length + 1}:"),
            Row(
              children: [
                Container(
                  width: 275,
                  height: 35,
                  child: TextFormField(
                    style: TextStyle(fontSize: 15),
                    controller: ingredientController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O campo de ingrediente é obrigatório.';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    removeIngredient(
                      ingredientNameControllers.indexOf(ingredientController),
                    );
                  },
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
              child: TextFormField(
                style: TextStyle(fontSize: 15),
                controller: quantityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O campo de ingrediente é obrigatório.';
                  }
                  return null;
                },
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

    ingredientNameControllers.add(ingredientController);
    quantityControllers.add(quantityController);
    counter++;
  }

  void removeIngredient(int index) {
    setState(() {
      ingredientWidgets.removeAt(index);
      ingredientNameControllers.removeAt(index);
      quantityControllers.removeAt(index);
      counter--;
    });
  }

  Recipe createNewRecipe() {
    var uuid;
    String recipeId;
    if (widget.isEditing) {
      recipeId = widget.recipeToEdit?.id ?? "";
    } else {
      uuid = Uuid();
      recipeId = uuid.v4();
    }

    int hours =
        _hoursController.text.isEmpty ? 0 : int.parse(_hoursController.text);
    int minutes =
        _minutesController.text.isEmpty
            ? 0
            : int.parse(_minutesController.text);

    String imagePath =
        _pictureController.text.isEmpty
            ? 'assets/images/image_recipe_default.png'
            : _pictureController.text;

    Duration preparationTime = Duration(hours: hours, minutes: minutes);

    List<RecipeIngredient> ingredients = [];
    for (int i = 0; i < ingredientNameControllers.length; i++) {
      ingredients.add(
        RecipeIngredient(
          name: ingredientNameControllers[i].text,
          quantity: quantityControllers[i].text,
        ),
      );
    }

    return Recipe(
      id: recipeId,
      name: _titleController.text,
      ingredients: ingredients,
      desc: _descriptionController.text,
      preparationTime: preparationTime,
      instructions: _instructionsController.text,
      imagePath: imagePath,
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _pictureController.text = _image!.path;
      });
    }
  }

  void fillFields(Recipe recipe) {
    _titleController.text = recipe.name;
    _descriptionController.text = recipe.desc ?? "";
    _hoursController.text = (recipe.preparationTime?.inHours ?? 0).toString();
    _minutesController.text =
        ((recipe.preparationTime?.inMinutes ?? 0) % 60).toString();
    _instructionsController.text = recipe.instructions;
    _pictureController.text = recipe.imagePath;

    for (int i = 0; i < recipe.ingredients.length; i++) {
      addNewIngredientWidget();
      ingredientNameControllers[i].text = recipe.ingredients[i].name;
      quantityControllers[i].text = recipe.ingredients[i].quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe2e2e2),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          "Nova Receita",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 25,
              ),
              child: Theme(
                data: ThemeData(
                  textTheme: TextTheme(
                    bodyMedium: TextStyle(
                      fontSize: 11.0,
                      color: Color(0xFF4C4C4C),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      borderSide: BorderSide(
                        color: Color(0xffe7e7e7),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      borderSide: BorderSide(
                        color: Color(0xFFd98b0e),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      borderSide: BorderSide(
                        color: Color(0xffe7e7e7),
                        width: 1.0,
                      ),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                              child: TextFormField(
                                controller: _titleController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'O nome da receita é obrigatório';
                                  }
                                  return null;
                                },
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
                          child: GestureDetector(
                            onTap: _pickImage,
                            child:
                                _image == null
                                    ? Icon(
                                      Icons.photo_size_select_actual_rounded,
                                      size: 30,
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.file(
                                        _image!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
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
                      child: TextFormField(
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
                          child: TextFormField(
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
                          child: TextFormField(
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
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                int number = int.parse(value);
                                if (number > 59) {
                                  _minutesController.text = '59';
                                  _minutesController
                                      .selection = TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _minutesController.text.length,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                                addNewIngredientWidget();
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
                      itemCount: ingredientWidgets.length,
                      itemBuilder: (context, index) {
                        return ingredientWidgets[index];
                      },
                    ),
                    Text(
                      'Modo de Preparo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 500,
                      child: TextFormField(
                        maxLines: null,
                        controller: _instructionsController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O modo de preparo da receita é obrigatório';
                          }
                          return null;
                        },
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
                    SizedBox(height: 15),
                    TextButton.icon(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (counter <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Adicione pelo menos um ingrediente.',
                                ),
                                backgroundColor: Color(0xfff55f54),
                              ),
                            );

                            return;
                          }
                          Recipe recipe = createNewRecipe();

                          if (widget.isEditing) {
                            Provider.of<RecipesRepositoryFirebase>(
                              context,
                              listen: false,
                            ).editRecipe(recipe);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            Provider.of<RecipesRepositoryFirebase>(
                              context,
                              listen: false,
                            ).createRecipe(recipe);
                            Navigator.pop(context);
                          }
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        size: 25,
                        color: Color(0xfff7f7f7),
                      ),
                      label: Text(
                        'Salvar',
                        style: TextStyle(color: Color(0xfff7f7f7)),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
