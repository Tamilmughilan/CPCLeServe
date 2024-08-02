import 'package:flutter/material.dart';
import 'package:cpcl/models/employeeStruct.dart';
import 'package:intl/intl.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});
  final Expense expense;

  String getFormattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'assets/profilepictures/${expense.prNo}.png';
    final String defaultImagePath = 'assets/images/logo.png';

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  defaultImagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: AutofillHints.nickname,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'PR No: ${expense.prNo}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 244, 101, 76),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          'Position: ${expense.empPosition}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 244, 101, 76),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Mobile: ${expense.mobileNo}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 244, 101, 76),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          'Dept: ${expense.department}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 99, 181, 240),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          'DOB: ${getFormattedDate(expense.DOB)}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 99, 181, 240),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
