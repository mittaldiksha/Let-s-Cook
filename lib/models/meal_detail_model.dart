class MealDetail {
  final String title;
  final String instructions;
  final String imageUrl;
  final List<String> ingredients;

  // New optional fields
  final String? category;
  final String? area;
  final List<String> tags;

  MealDetail({
    required this.title,
    required this.instructions,
    required this.imageUrl,
    required this.ingredients,
    this.category,
    this.area,
    this.tags = const [],
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    // Build ingredients list "Ingredient - Measure"
    final List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ing = (json['strIngredient$i'] as String?)?.trim();
      final meas = (json['strMeasure$i'] as String?)?.trim();
      if (ing != null && ing.isNotEmpty) {
        ingredients.add(
          (meas != null && meas.isNotEmpty) ? '$ing - $meas' : ing,
        );
      }
    }

    // Parse comma-separated tags
    final tagsStr = json['strTags'] as String?;
    final tags = (tagsStr == null || tagsStr.trim().isEmpty)
        ? <String>[]
        : tagsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    return MealDetail(
      title: json['strMeal'] ?? '',
      instructions: json['strInstructions'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      ingredients: ingredients,
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      tags: tags,
    );
  }
}
