import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

/* =======================
   MODEL
======================= */
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

/* =======================
   STORAGE
======================= */
class StorageService {
  static const String key = 'foods';

  Future<void> saveFoods(List<Food> foods) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = foods.map((f) => jsonEncode(f.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  Future<List<Food>> loadFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key) ?? [];
    return jsonList
        .map((e) => Food.fromJson(jsonDecode(e)))
        .toList();
  }
}

/* =======================
   APP
======================= */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService storage = StorageService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController calorieController = TextEditingController();

  List<Food> foods = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    foods = await storage.loadFoods();
    setState(() {});
  }

  void addFood() async {
    if (nameController.text.isEmpty ||
        calorieController.text.isEmpty) return;

    final food = Food(
      name: nameController.text,
      calories: int.parse(calorieController.text),
    );

    foods.add(food);
    await storage.saveFoods(foods);

    nameController.clear();
    calorieController.clear();

    setState(() {});
  }

  void deleteFood(int index) async {
    foods.removeAt(index);
    await storage.saveFoods(foods);
    setState(() {});
  }

  int get totalCalories =>
      foods.fold(0, (sum, item) => sum + item.calories);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CalTrack')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Today's Calories: $totalCalories kcal",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Food name'),
            ),
            TextField(
              controller: calorieController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addFood,
              child: const Text('Add Food'),
            ),

            const Divider(),

            Expanded(
              child: foods.isEmpty
                  ? const Center(child: Text('No food added yet'))
                  : ListView.builder(
                      itemCount: foods.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(foods[index].name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${foods[index].calories} kcal'),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteFood(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}