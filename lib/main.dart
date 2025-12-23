import 'package:flutter/material.dart';

void main() {
  runApp(const CalTrackApp());
}

class CalTrackApp extends StatelessWidget {
  const CalTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalTrack',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalCalories = 0;

  final TextEditingController foodController = TextEditingController();
  final TextEditingController calorieController = TextEditingController();
 void addFood() {
  if (!mounted) return;

  final caloriesText = calorieController.text;
  final int calories = int.tryParse(caloriesText) ?? 0;

    if (calories > 0) {
      setState(() {
        totalCalories += calories;
      });
    }

    foodController.clear();
    calorieController.clear();
    Navigator.pop(context);
  }

  void openAddFoodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Food"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: foodController,
                decoration: const InputDecoration(
                  labelText: "Food name",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: calorieController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: addFood,
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CalTrack"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Calories",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Intake"),
                  Text(
                    "$totalCalories kcal",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: openAddFoodDialog,
              child: const Text("Add Food"),
            ),
          ],
        ),
      ),
    );
  }
}