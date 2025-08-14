import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';

class MealApi {
  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['meals'] as List)
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<MealDetail> fetchMealDetail(String id) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }
}
