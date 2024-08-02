import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // Required for AssetImage

class Meal {
  int employeeId;
  DateTime cdate;
  int itemCode;
  String subItemCode;
  int cqty;
  int sysid;
  double actRate;
  String subitemdesc;
  String itemdesc;

  Meal({
    required this.employeeId,
    required this.cdate,
    required this.itemCode,
    required this.subItemCode,
    required this.cqty,
    required this.sysid,
    required this.actRate,
    required this.subitemdesc,
    required this.itemdesc,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      employeeId: json['employeeId'],
      cdate: DateTime.parse(json['cdate']),
      itemCode: json['iteM_CODE'],
      subItemCode: json['suB_ITEM_CODE'],
      cqty: json['cqty'],
      sysid: json['sysid'],
      actRate: json['act_rate'].toDouble(),
      subitemdesc: json['subitemdesc'],
      itemdesc: json['itemdesc'],
    );
  }

  // Optionally, add an imageUrl getter if you have image URLs
  String get imageUrl =>
      "https://cdn.pixabay.com/photo/2022/09/05/14/37/fruits-7434339_640.jpg"; // Replace with your actual image URL provider logic
}

Future<List<Meal>> fetchMeals(String dayOfWeek) async {
  final response = await http.get(Uri.parse(
      'http://localhost:5062/api/cpcl_cant_daily_menu_items?dayOfWeek=$dayOfWeek'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['\$values'];
    return jsonResponse.map((meal) => Meal.fromJson(meal)).toList();
  } else {
    throw Exception('Failed to load meals');
  }
}

List<Meal> filterMealsByType(List<Meal> meals, String mealType) {
  return meals.where((meal) {
    return meal.itemdesc.toLowerCase().contains(mealType.toLowerCase()) ||
        meal.subitemdesc.toLowerCase().contains(mealType.toLowerCase());
  }).toList();
}

class MealList extends StatefulWidget {
  final String dayOfWeek;

  const MealList({Key? key, required this.dayOfWeek}) : super(key: key);

  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  String selectedMealType = 'Breakfast'; // Default meal type
  late Future<List<Meal>> futureMeals;

  @override
  void initState() {
    super.initState();
    futureMeals = fetchMeals(widget.dayOfWeek);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals for ${widget.dayOfWeek}'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: DropdownButton<String>(
              value: selectedMealType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMealType = newValue!;
                });
              },
              items: <String>['Breakfast', 'Lunch', 'Dinner', 'Refreshments']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 18, color: Colors.deepOrange),
                  ),
                );
              }).toList(),
              isExpanded: true,
              style: TextStyle(fontSize: 18, color: Colors.deepOrange),
              underline: Container(
                height: 2,
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: futureMeals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Meal> filteredMeals =
                      filterMealsByType(snapshot.data!, selectedMealType);
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.5,
                    ),
                    padding: EdgeInsets.all(8),
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return MealItem(
                        meal: meal,
                        onSelectMeal: (selectedMeal) {
                          // Handle meal selection
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(meal.itemdesc),
                                content: Text('Details about ${meal.itemdesc}'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal, required this.onSelectMeal});

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      child: InkWell(
        onTap: () {
          onSelectMeal(meal);
        },
        child: Column(
          children: [
            Expanded(
              child: FadeInImage(
                placeholder: AssetImage('assets/placeholder.png'),
                image: NetworkImage(
                    meal.imageUrl), // Uncomment if you have image URLs
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                meal.subitemdesc,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                meal.itemdesc,
                style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
