// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:cpcl/models/expenseStruct.dart';

// class NewEmployee extends StatefulWidget {
//   const NewEmployee({super.key, required this.onAddExpense});

//   final void Function(Expense expense) onAddExpense;
//   @override
//   State<NewEmployee> createState() {
//     return _NewEmployeeState();
//   }
// }

// class _NewEmployeeState extends State<NewEmployee> {
//   final _prNoController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _departmentController = TextEditingController();
//   final _empPositionController = TextEditingController();
//   final _DOBController = TextEditingController();

//   void _submitEmployee() {
//     final prNo = int.tryParse(_prNoController.text);
//     //final DOB = int.tryParse(_DOBController.text);

//     if (prNo == null ||
//         prNo <= 0 ||
//         _nameController.text.trim().isEmpty ||
//         _departmentController.text.trim().isEmpty ||
//         _empPositionController.text.trim().isEmpty) {
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: const Text("Invalid input"),
//           content: const Text("Please fill all fields with valid data."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(ctx);
//               },
//               child: const Text("Okay"),
//             )
//           ],
//         ),
//       );
//       return;
//     }

//     widget.onAddExpense(
//       Expense(
//         prNo: prNo,
//         name: _nameController.text,
//         department: _departmentController.text,
//         empPosition: _empPositionController.text,
//         DOB: _DOBController,

//       ),
//     );
//     Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _prNoController.dispose();
//     _nameController.dispose();
//     _departmentController.dispose();
//     _empPositionController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
//     return LayoutBuilder(builder: (ctx, constraints) {
//       final width = constraints.maxWidth;
//       return SizedBox(
//         height: double.infinity,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
//             child: Column(
//               children: [
//                 if (width >= 600)
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _prNoController,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             label: Text("PR No"),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 24),
//                       Expanded(
//                         child: TextField(
//                           controller: _nameController,
//                           maxLength: 50,
//                           decoration: const InputDecoration(
//                             label: Text("Name"),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 else
//                   Column(
//                     children: [
//                       TextField(
//                         controller: _prNoController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           label: Text("PR No"),
//                         ),
//                       ),
//                       TextField(
//                         controller: _nameController,
//                         maxLength: 50,
//                         decoration: const InputDecoration(
//                           label: Text("Name"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 if (width >= 600)
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _departmentController,
//                           maxLength: 50,
//                           decoration: const InputDecoration(
//                             label: Text("Department"),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 24),
//                       Expanded(
//                         child: TextField(
//                           controller: _empPositionController,
//                           maxLength: 50,
//                           decoration: const InputDecoration(
//                             label: Text("Position"),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 else
//                   Column(
//                     children: [
//                       TextField(
//                         controller: _departmentController,
//                         maxLength: 50,
//                         decoration: const InputDecoration(
//                           label: Text("Department"),
//                         ),
//                       ),
//                       TextField(
//                         controller: _empPositionController,
//                         maxLength: 50,
//                         decoration: const InputDecoration(
//                           label: Text("Position"),
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
