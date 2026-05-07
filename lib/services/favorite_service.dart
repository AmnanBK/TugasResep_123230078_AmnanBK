import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteService {
  static const String _boxName = 'favorites';

  // Buka box favorit
  static Future<Box<String>> _getBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  // Tambahkan ke favorit
  static Future<void> addFavorite(String recipeId) async {
    final box = await _getBox();
    await box.put(recipeId, recipeId);
  }

  // Hapus dari favorit
  static Future<void> removeFavorite(String recipeId) async {
    final box = await _getBox();
    await box.delete(recipeId);
  }

  // Cek apakah resep ada di favorit
  static Future<bool> isFavorite(String recipeId) async {
    final box = await _getBox();
    return box.containsKey(recipeId);
  }

  // Ambil semua ID favorit
  static Future<List<String>> getFavoriteIds() async {
    final box = await _getBox();
    return box.keys.cast<String>().toList();
  }

  // Ambil ValueListenable untuk reactive UI
  static ValueListenable<Box<String>> getFavoriteListenable() {
    return Hive.box<String>(_boxName).listenable();
  }
}
