import 'package:cpcl/widgets/days_grid_screen.dart';
import 'package:flutter/material.dart';
import 'package:cpcl/screens/Circulars.dart';
import 'package:cpcl/screens/policy_page.dart';
import 'package:cpcl/screens/in_out_time_page.dart';
import 'package:cpcl/screens/location_page.dart';
import 'package:cpcl/screens/telephone_directory_page.dart'; // Import the Telephone Directory page
import 'package:cpcl/screens/lop_page.dart';
import 'package:cpcl/screens/holidays_page.dart';
import 'package:cpcl/widgets/employees.dart';
import 'package:cpcl/screens/organogram.dart';
import 'package:cpcl/api/api_handler.dart'; // Import the ApiHandler

class HomeGrid extends StatefulWidget {
  final int prNo;
  final String department;
  final ApiHandler apiHandler; // Add ApiHandler as a parameter

  const HomeGrid({
    super.key,
    required this.prNo,
    required this.department,
    required this.apiHandler, // Initialize ApiHandler
  });

  @override
  // ignore: library_private_types_in_public_api
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  final _scaleFactor = 1.1; // Scale factor for zoom effect
  final _duration = const Duration(milliseconds: 200); // Animation duration
  final Map<int, bool> _isHovered = {}; // Track hover state

  final List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    items.addAll([
      {
        'title': 'Employee Search',
        'page': const Expenses(),
        'icon': Icons.search,
      },
      {
        'title': 'Canteen Menu',
        'page': DaysGridScreen(),
        'icon': Icons.restaurant_menu
      },
      {
        'title': 'In/Out Time',
        'page': const InOutTimePage(),
        'icon': Icons.access_time,
      },
      {
        'title': 'Location',
        'page': LocationPage(),
        'icon': Icons.location_on,
      },
      {
        'title': 'Telephone Directory',
        'page': TelephoneDirectoryPage(
            apiHandler: widget.apiHandler), // Pass ApiHandler here
        'icon': Icons.phone,
      },
      {
        'title': 'Leave Details',
        'page': LopPage(prNo: widget.prNo),
        'icon': Icons.event_available,
      },
      {
        'title': 'Holidays',
        'page': const HolidaysPage(),
        'icon': Icons.calendar_today,
      },
      {
        'title': 'Employee Hierarchy',
        'page': const DepartmentListPage(),
        'icon': Icons.account_tree,
      },
      {
        'title': 'Policy',
        'page': const PolicyPage(),
        'icon': Icons.policy,
      },
    ]);

    // Add Circulars page separately
    items.add({
      'title': 'Circulars',
      'page': CircularsPage(prNo: widget.prNo, department: widget.department),
      'icon': Icons.book,
    });
  }

  void _onTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => items[index]['page']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 3 / 2,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        return MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered[index] = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered[index] = false;
            });
          },
          child: GestureDetector(
            onTap: () => _onTap(index),
            child: AnimatedScale(
              scale: _isHovered[index] == true ? _scaleFactor : 1.0,
              duration: _duration,
              child: GridTile(
                footer: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      items[index]['title'],
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 100, 180, 220),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      items[index]['icon'],
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
