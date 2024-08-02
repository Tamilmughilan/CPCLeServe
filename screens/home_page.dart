import 'package:flutter/material.dart';
import 'package:cpcl/widgets/main_drawer.dart';
import 'package:cpcl/widgets/home_grid.dart';
import 'package:cpcl/screens/notification_page.dart'; // Import the new notifications page
import 'package:cpcl/screens/profile_page.dart'; // Import the profile page
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cpcl/api/api_handler.dart'; // Import ApiHandler

class HomePage extends StatefulWidget {
  final String prNo;
  const HomePage({super.key, required this.prNo});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<Map<String, String>> _employeeDetails;
  late ApiHandler _apiHandler; // Declare ApiHandler instance
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _employeeDetails = _fetchEmployeeDetails(widget.prNo);
    _apiHandler =
        ApiHandler(baseUrl: 'http://localhost:5062'); // Initialize ApiHandler
  }

  Future<Map<String, String>> _fetchEmployeeDetails(String prNo) async {
    final response = await http
        .get(Uri.parse('http://localhost:5062/api/Empviews/byprno/$prNo'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'name': data['h01_First_Name'],
        'department': data['c02_Function_Desc']
      };
    } else {
      throw Exception('Failed to load employee details');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _employeeDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final employeeName = snapshot.data!['name']!;
          final employeeDepartment = snapshot.data!['department']!;

          _pages.clear();
          _pages.addAll([
            HomeGrid(
              prNo: int.parse(widget.prNo),
              department: employeeDepartment,
              apiHandler: _apiHandler, // Pass ApiHandler here
            ),
            NotificationsPage(
              prNo: widget.prNo,
              department: employeeDepartment,
            ),
            ProfilePage(prNo: widget.prNo),
          ]);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
            ),
            drawer: MainDrawer(prNo: widget.prNo, name: employeeName),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _pages[_selectedIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notification_important),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
