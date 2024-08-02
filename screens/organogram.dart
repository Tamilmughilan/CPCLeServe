

import 'package:flutter/material.dart';

class DepartmentListPage extends StatefulWidget {
  const DepartmentListPage({super.key});

  @override
  _DepartmentListPageState createState() => _DepartmentListPageState();
}

class _DepartmentListPageState extends State<DepartmentListPage> {
  final List<String> departments = [
    'HR',
    'Mechanical',
    'Chemical',
    'Electrical',
    'ITS',
    'Civil',
    'Safety',
    'Maintenance',
  ];


  String? selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organogram'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: DropdownButton<String>(
                hint: const Text('Select Department'),
                value: selectedDepartment,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDepartment = newValue;
                  });
                },
                items: departments.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          if (selectedDepartment != null)
            Expanded(
              child: DepartmentHierarchyPage(department: selectedDepartment!),
            ),
        ],
      ),
    );
  }
}

class DepartmentHierarchyPage extends StatelessWidget {
  final String department;

  DepartmentHierarchyPage({super.key, required this.department});

  
final Map<String, List<Map<String, String>>> hierarchyData = {
    'HR': [
      {'title': '10 MGR', 'description': 'Managers'},
      {'title': '5 GM', 'description': 'General Managers'},
      {'title': '3 CGM', 'description': 'Chief General Managers'},
      {'title': '40 ENG', 'description': 'Engineers'},
    ],
    'ITS': [
      {'title': '8 MGR', 'description': 'Managers'},
      {'title': '4 GM', 'description': 'General Managers'},
      {'title': '2 CGM', 'description': 'Chief General Managers'},
      {'title': '30 ENG', 'description': 'Engineers'},
    ],
    'Electrical': [
      {'title': '20 MGR', 'description': 'Managers'},
      {'title': '10 GM', 'description': 'General Managers'},
      {'title': '5 CGM', 'description': 'Chief General Managers'},
      {'title': '50 ENG', 'description': 'Engineers'},
    ],
    'Mechanical': [
      {'title': '15 MGR', 'description': 'Managers'},
      {'title': '7 GM', 'description': 'General Managers'},
      {'title': '3 CGM', 'description': 'Chief General Managers'},
      {'title': '25 ENG', 'description': 'Engineers'},
    ],
    'Chemical': [
      {'title': '12 MGR', 'description': 'Managers'},
      {'title': '6 GM', 'description': 'General Managers'},
      {'title': '2 CGM', 'description': 'Chief General Managers'},
      {'title': '22 ENG', 'description': 'Engineers'},
    ],
    'Civil': [
      {'title': '13 MGR', 'description': 'Managers'},
      {'title': '4 GM', 'description': 'General Managers'},
      {'title': '2 CGM', 'description': 'Chief General Managers'},
      {'title': '34 ENG', 'description': 'Engineers'},
    ],
    'Maintenace': [
      {'title': '17 MGR', 'description': 'Managers'},
      {'title': '8 GM', 'description': 'General Managers'},
      {'title': '3 CGM', 'description': 'Chief General Managers'},
      {'title': '40 ENG', 'description': 'Engineers'},
    ],
    'Safety': [
      {'title': '8 MGR', 'description': 'Managers'},
      {'title': '2 GM', 'description': 'General Managers'},
      {'title': '1 CGM', 'description': 'Chief General Managers'},
      {'title': '18 ENG', 'description': 'Engineers'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final departmentData = hierarchyData[department] ?? [];

    return ListView.builder(
      itemCount: departmentData.length,
      itemBuilder: (context, index) {
        final item = departmentData[index];
        return Card(
          child: ExpansionTile(
            title: Text(item['title']!),
            children: [
              ListTile(
                title: Text(item['description']!),
              ),
            ],
          ),
        );
      },
    );
  }
}
