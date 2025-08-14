import 'package:flutter/material.dart';
import '../models/meal_detail_model.dart';
import '../services/meal_api.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String mealId;

  const RecipeDetailScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Recipe Details"),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: FutureBuilder<MealDetail>(
        future: MealApi.fetchMealDetail(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final meal = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with rounded corners & shadow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(meal.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16),

                // Title & category info
                Text(
                  meal.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Row(
                //   children: [
                //     Chip(
                //       label: Text(meal.category ?? 'Unknown'),
                //       backgroundColor: Colors.deepOrange.shade100,
                //     ),
                //     const SizedBox(width: 6),
                //     Chip(
                //       label: Text(meal.area ?? 'Unknown'),
                //       backgroundColor: Colors.green.shade100,
                //     ),
                //   ],
                // ),
                Row(
                  children: [
                    if (meal.category != null && meal.category!.isNotEmpty)
                      Chip(
                        label: Text(meal.category!),
                        backgroundColor: Colors.deepOrange.shade100,
                      ),
                    if (meal.area != null && meal.area!.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Chip(
                        label: Text(meal.area!),
                        backgroundColor: Colors.green.shade100,
                      ),
                    ],
                  ],
                ),

                if (meal.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: meal.tags
                        .map((t) => Chip(
                      label: Text(t),
                      backgroundColor: Colors.orange.shade50,
                    ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 20),

                // Ingredients section
                const Text(
                  "Ingredients",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: -8,
                  children: meal.ingredients
                      .map((ingredient) => Chip(
                    label: Text(ingredient),
                    backgroundColor: Colors.orange.shade50,
                  ))
                      .toList(),
                ),
                const SizedBox(height: 20),

                // Instructions section
                const Text(
                  "Instructions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    meal.instructions,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
