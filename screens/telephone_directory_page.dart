import 'package:flutter/material.dart';
import 'package:cpcl/api/api_handler.dart'; // Adjust the import path as necessary
import 'package:cpcl/models/telephone_entry.dart'; // Adjust the import path as necessary

class TelephoneDirectoryPage extends StatelessWidget {
  final ApiHandler apiHandler;

  const TelephoneDirectoryPage({super.key, required this.apiHandler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telephone Directory'),
      ),
      body: TelephoneDirectoryTable(apiHandler: apiHandler),
    );
  }
}

class TelephoneDirectoryTable extends StatefulWidget {
  final ApiHandler apiHandler;

  const TelephoneDirectoryTable({super.key, required this.apiHandler});

  @override
  _TelephoneDirectoryTableState createState() =>
      _TelephoneDirectoryTableState();
}

class _TelephoneDirectoryTableState extends State<TelephoneDirectoryTable> {
  late Future<List<TelephoneEntry>> _telephoneDirectory;

  @override
  void initState() {
    super.initState();
    _telephoneDirectory = widget.apiHandler.fetchTelephoneDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TelephoneEntry>>(
      future: _telephoneDirectory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No telephone directory entries found'));
        }

        final telephoneDirectory = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 31, 29, 29),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 53, 51, 51).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 18, 4, 99),
              fontSize: 16,
            ),
            dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return states.contains(MaterialState.selected)
                    ? Color.fromARGB(255, 233, 233, 236)
                    : const Color.fromARGB(255, 0, 0, 0);
              },
            ),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Designation')),
              DataColumn(label: Text('Department')),
              DataColumn(label: Text('Intercom No')),
              DataColumn(label: Text('PT Extn')),
              DataColumn(label: Text('PT Direct')),
              DataColumn(label: Text('Residence')),
              DataColumn(label: Text('Mobile No')),
              DataColumn(label: Text('Email ID')),
            ],
            rows: telephoneDirectory.map((entry) {
              return DataRow(
                cells: [
                  DataCell(Text(entry.name)),
                  DataCell(Text(entry.designation)),
                  DataCell(Text(entry.department)),
                  DataCell(Text(entry.intercomNo.toString())),
                  DataCell(Text(entry.ptExtn.toString())),
                  DataCell(Text(entry.ptDirect.toString())),
                  DataCell(Text(entry.residence)),
                  DataCell(Text(entry.mobileNo.toString())),
                  DataCell(Text(entry.emailId)),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
