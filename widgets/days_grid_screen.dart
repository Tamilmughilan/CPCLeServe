import 'package:flutter/material.dart';
import 'package:cpcl/widgets/meal_list.dart';
import 'package:cpcl/data/food_data.dart';

class DaysGridScreen extends StatelessWidget {
  const DaysGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Day'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        children: availableCategories.map((catData) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MealList(dayOfWeek: catData.title),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    catData.color.withOpacity(0.7),
                    catData.color,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                catData.title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          );
        }).toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
