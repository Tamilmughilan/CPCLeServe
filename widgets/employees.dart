import 'package:flutter/material.dart';
import 'package:cpcl/models/employeeStruct.dart';
import 'package:cpcl/api/api_handler.dart';
import 'package:cpcl/widgets/expenses_list/employee_list.dart';

// Added error handling and loading states

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  final ApiHandler apiHandler =
      ApiHandler(baseUrl: "http://localhost:5062/api/Empviews");
  List<String> departments = [];
  String selectedCriterion = 'PR Number';
  String selectedDepartment = '';
  String query = '';
  bool isLoading = false;
  bool isSearching = false;
  String searchMessage = '';
  final TextEditingController _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() {
      isLoading = true;
    });
    try {
      final employees = await apiHandler.fetchEmployees();
      final uniqueDepartments =
          employees.map((e) => e.department).toSet().toList();
      setState(() {
        departments = uniqueDepartments;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load departments: $error')),
      );
    }
  }

  Future<void> _loadEmployees() async {
    if (query.isEmpty && selectedDepartment.isEmpty) return;

    setState(() {
      isSearching = true;
    });

    try {
      List<Expense> employees;
      if (selectedCriterion == 'Mobile Number') {
        employees = await apiHandler.fetchEmployeesByMobile(query);
      } else {
        employees = await apiHandler.fetchEmployees();
      }

      final queryLower = query.toLowerCase();
      final results = employees.where((employee) {
        final prNoMatch = employee.prNo.toString().contains(query);
        final nameMatch = employee.name.toLowerCase().contains(queryLower);
        final departmentMatch = selectedDepartment.isEmpty ||
            employee.department == selectedDepartment;

        if (selectedCriterion == 'PR Number') return prNoMatch;
        if (selectedCriterion == 'Name') return nameMatch;
        if (selectedCriterion == 'Department') return departmentMatch;
        if (selectedCriterion == 'Mobile Number') {
          return employee.mobileNo == query;
        }

        return false;
      }).toList();

      setState(() {
        _registeredExpenses
          ..clear()
          ..addAll(results);
        isSearching = false;
        searchMessage =
            results.isNotEmpty ? 'Employee(s) found' : 'No employees found';
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load employees: $error')),
      );
      setState(() {
        isSearching = false;
      });
    }
  }

  void _updateQuery(String newQuery) {
    setState(() {
      query = newQuery;
      if (query.isEmpty) {
        _registeredExpenses.clear();
        searchMessage = '';
      }
    });
  }

  void _performSearch() {
    _loadEmployees();
  }

  void _resetSearch() {
    setState(() {
      _registeredExpenses.clear();
      query = '';
      searchMessage = '';
      selectedDepartment = '';
      _queryController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(isSearching ? "Searching..." : searchMessage),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveEmployee: (e) {}, // Remove functionality not required
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Directory"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCriterion,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_downward),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCriterion = newValue!;
                        _resetSearch();
                      });
                    },
                    items: <String>[
                      'PR Number',
                      'Name',
                      'Department',
                      'Mobile Number'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                if (selectedCriterion == 'Department') ...[
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedDepartment.isEmpty
                          ? null
                          : selectedDepartment,
                      hint: const Text('Select Department'),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDepartment = newValue!;
                          query = '';
                          _performSearch();
                        });
                      },
                      items: departments
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                labelText: 'Search Query',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _resetSearch();
                  },
                ),
              ),
              onChanged: _updateQuery,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }
}
