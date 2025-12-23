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
  final List<Map<String, dynamic>> foods = [];

  void addFood(String name, int calories) {
    setState(() {
      foods.add({'name': name, 'cal': calories});
      totalCalories += calories;
    });
  }

  void deleteFood(int index) {
    setState(() {
      totalCalories -= foods[index]['cal'] as int;
      foods.removeAt(index);
    });
  }

  void showAddFoodDialog() {
    final nameController = TextEditingController();
    final calController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Food"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Food name"),
            ),
            TextField(
              controller: calController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Calories"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  calController.text.isNotEmpty) {
                addFood(
                  nameController.text,
                  int.parse(calController.text),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CalTrack")),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddFoodDialog,
        child: const Icon(Icons.add),
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
            const SizedBox(height: 10),
            Text(
              "Total Intake: $totalCalories kcal",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              "Food List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: foods.isEmpty
                  ? const Center(child: Text("No food added"))
                  : ListView.builder(
                      itemCount: foods.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(foods[index]['name']),
                            subtitle:
                                Text("${foods[index]['cal']} kcal"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteFood(index),
                            ),
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