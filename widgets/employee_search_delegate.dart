import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cpcl/models/employeeStruct.dart';

class EmployeeSearchDelegate extends SearchDelegate<List<Expense>> {
  final List<Expense> employees;
  final List<String> departments;
  final String searchType;
  Timer? _debounce;

  EmployeeSearchDelegate(this.employees, this.departments, this.searchType);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, []);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (searchType == 'Department' && query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButton<String>(
          hint: const Text('Select a Department'),
          value: query.isEmpty ? null : query,
          onChanged: (String? newValue) {
            query = newValue!;
            showSuggestions(context);
          },
          items: departments.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      );
    }

    if (searchType == 'PR Number' || searchType == 'Mobile Number') {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        showResults(context);
      });
    }

    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    List<Expense> results = [];

    if (searchType == 'Department') {
      results =
          employees.where((employee) => employee.department == query).toList();
    } else if (query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      results = employees.where((employee) {
        
        final prNoMatch = employee.prNo.toString().contains(query);
        final nameMatch = employee.name.toLowerCase().contains(queryLower);
        if (searchType == 'PR Number') return prNoMatch;
        
        if (searchType == 'Name') return nameMatch;
        return false;
      }).toList();
    }

    if (results.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final employee = results[index];
        return ListTile(
          title: Text(employee.name),
          subtitle:
              Text('PR No: ${employee.prNo}'),
          onTap: () {
            close(context, [employee]);
          },
        );
      },
    );
  }
}
