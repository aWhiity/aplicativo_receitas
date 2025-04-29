extension StringCapitalization on String {
  String captalize() {
    if (isEmpty) return this;
    //Aqui ele pega o primeiro char da string, deixa-o em maiusculo e concatena novamente com o restante da string
    return this[0].toUpperCase() + substring(1);
  }

  String captalizeAllWords() {
    //pega a string e a divide pelos espaços, depois pega cada pedaço da lista criada e usa a função captalize e no fim, une todas novamente
    return split(" ").map((word) => word.captalize()).join(" ");
  }
}
