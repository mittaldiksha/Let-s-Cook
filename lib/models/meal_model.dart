class Meal {
  final String id;
  final String title;
  final String thumbnail;

  Meal({
    required this.id,
    required this.title,
    required this.thumbnail,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      title: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }
}
