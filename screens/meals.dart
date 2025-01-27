// import 'package:cpcl/models/meal.dart';
// import 'package:cpcl/screens/meal_details.dart';
// import 'package:cpcl/widgets/meal_item.dart';
// import 'package:flutter/material.dart';

// class MealsScreen extends StatelessWidget {
//   const MealsScreen({
//     super.key,
//     this.title,
//     required this.meals,
//     required this.onToggleFavorite,
//   });

//   final String? title;
//   final List<Meal> meals;
//   final void Function(Meal meal) onToggleFavorite;

//   void selectMeal(BuildContext context, Meal meal) {
//     Navigator.pop(context);
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => MealDetailsScreen(
//           meal: meal,
//           onToggleFavorite: onToggleFavorite,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget content = ListView.builder(
//       itemCount: meals.length,
//       itemBuilder: (ctx, index) => MealItem(
//         meal: meals[index],
//         onSelectMeal: (meal) {
//           selectMeal(context, meal);
//         },
//       ),
//     );

//     if (meals.isEmpty) {
//       content = Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Dummy",
//               style: Theme.of(context).textTheme.headlineLarge!.copyWith(
//                     color: Theme.of(context).colorScheme.onBackground,
//                   ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Wrong cat",
//               style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                     color: Theme.of(context).colorScheme.onBackground,
//                   ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (title == null) {
//       return content;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title!),
//       ),
//       body: content,
//     );
//   }
// }
