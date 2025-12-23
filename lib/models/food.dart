class Food {
  final String name;
  final int calories;

  Food({required this.name, required this.calories});

  Map<String, dynamic> toJson() => {
        'name': name,
        'calories': calories,
      };

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      calories: json['calories'],
    );
  }
}