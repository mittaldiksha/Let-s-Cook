import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeSearch extends SearchDelegate {
  Future<List<dynamic>> fetchMeals(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$query',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchMeals(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading recipes'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recipes found'));
        } else {
          final meals = snapshot.data!;
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return ListTile(
                leading: Image.network(
                  meal['strMealThumb'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(meal['strMeal']),
                subtitle: Text(meal['strCategory'] ?? ''),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/recipeDetail',
                    arguments: meal['idMeal'],
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
