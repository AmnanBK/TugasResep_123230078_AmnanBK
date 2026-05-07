import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Recipe>> getRecipesByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/filter.php?c=$category'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> meals = data['meals'];

        return meals.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }

  // Fetch detail resep berdasarkan ID
  static Future<RecipeDetail> getRecipeDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> meals = data['meals'];

        if (meals.isNotEmpty) {
          return RecipeDetail.fromJson(meals[0]);
        } else {
          throw Exception('Recipe not found');
        }
      } else {
        throw Exception('Failed to load recipe detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recipe detail: $e');
    }
  }
}
