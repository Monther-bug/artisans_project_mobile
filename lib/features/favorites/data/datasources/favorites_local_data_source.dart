import 'dart:convert';
import 'package:artisans_project_mobile/features/exercises/data/models/exercise_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoritesLocalDataSource {
  Future<List<ExerciseModel>> getFavorites();
  Future<void> addFavorite(ExerciseModel exercise);
  Future<void> removeFavorite(String exerciseId);
  Future<bool> isFavorite(String exerciseId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String _favoritesKey = 'favorites_exercises';

  FavoritesLocalDataSourceImpl();

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<void> addFavorite(ExerciseModel exercise) async {
    final prefs = await _prefs;
    final List<ExerciseModel> current = await getFavorites();
    if (!current.any((e) => e.id == exercise.id)) {
      current.add(exercise);
      final jsonList = current.map((e) => e.toJson()).toList();
      await prefs.setString(_favoritesKey, jsonEncode(jsonList));
    }
  }

  @override
  Future<List<ExerciseModel>> getFavorites() async {
    final prefs = await _prefs;
    final String? jsonString = prefs.getString(_favoritesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => ExerciseModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<bool> isFavorite(String exerciseId) async {
    final favorites = await getFavorites();
    return favorites.any((e) => e.id == exerciseId);
  }

  @override
  Future<void> removeFavorite(String exerciseId) async {
    final prefs = await _prefs;
    final List<ExerciseModel> current = await getFavorites();
    current.removeWhere((e) => e.id == exerciseId);
    final jsonList = current.map((e) => e.toJson()).toList();
    await prefs.setString(_favoritesKey, jsonEncode(jsonList));
  }
}
