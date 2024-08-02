import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cpcl/models/employeeStruct.dart';
import 'package:cpcl/models/telephone_entry.dart';

class ApiHandler {
  final String baseUrl;

  ApiHandler({required this.baseUrl});

  Future<List<Expense>> fetchEmployees() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      // Debug print
      if (body['\$values'] == null || body['\$values'] is! List) {
        throw Exception(
            'Invalid response format: \$values key is missing or not a list');
      }

      final List<dynamic> employeesJson = body['\$values'];
      final List<Expense> employees =
          employeesJson.map((dynamic item) => Expense.fromJson(item)).toList();
      // Debug print
      return employees;
    } else {
      throw Exception('Failed to load employees: ${response.reasonPhrase}');
    }
  }

  Future<List<Expense>> fetchEmployeesByMobile(String mobileNumber) async {
    final response =
        await http.get(Uri.parse('$baseUrl/bymobile/$mobileNumber'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      // Debug print

      if (body is Map &&
          body.containsKey('\$values') &&
          body['\$values'] is List) {
        final List<dynamic> employeesJson = body['\$values'];
        final List<Expense> employees = employeesJson
            .map((dynamic item) =>
                Expense.fromJson(item as Map<String, dynamic>))
            .toList();
        // Debug print
        return employees;
      } else {
        throw Exception(
            'Invalid response format: \$values key is missing or not a list');
      }
    } else {
      throw Exception('Failed to load employees: ${response.reasonPhrase}');
    }
  }

  Future<void> addEmployee(Expense employee) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add employee: ${response.reasonPhrase}');
    }
  }

  // New function to load notifications
  Future<List<Map<String, dynamic>>> loadNotifications() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/notifications/all'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      // Debug print

      if (body is List) {
        return List<Map<String, dynamic>>.from(body);
      } else {
        throw Exception('Invalid response format: Expected a list');
      }
    } else {
      throw Exception('Failed to load notifications: ${response.reasonPhrase}');
    }
  }

  Future<List<TelephoneEntry>> fetchTelephoneDirectory() async {
    final response = await http.get(Uri.parse('$baseUrl/api/cpcl_telephone/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> values = data['\$values'];

      final List<TelephoneEntry> telephoneDirectory =
          values.map((dynamic item) => TelephoneEntry.fromJson(item)).toList();
      return telephoneDirectory;
    } else {
      throw Exception(
          'Failed to load telephone directory: ${response.reasonPhrase}');
    }
  }
  
}
