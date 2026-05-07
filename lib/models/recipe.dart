class Recipe {
  final String id;
  final String name;
  final String thumbnail;

  Recipe({required this.id, required this.name, required this.thumbnail});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnail: json['strMealThumb'] as String,
    );
  }
}

class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});
}

class RecipeDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final List<Ingredient> ingredients;

  RecipeDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.area,
    required this.instructions,
    required this.ingredients,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    final List<Ingredient> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final name = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;

      if (name != null && name.isNotEmpty) {
        ingredients.add(Ingredient(name: name, measure: measure ?? ''));
      }
    }

    return RecipeDetail(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnail: json['strMealThumb'] as String,
      category: json['strCategory'] as String? ?? 'Unknown',
      area: json['strArea'] as String? ?? 'Unknown',
      instructions: json['strInstructions'] as String? ?? '',
      ingredients: ingredients,
    );
  }
}
