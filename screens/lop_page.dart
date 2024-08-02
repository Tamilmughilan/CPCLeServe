import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class LopPage extends StatelessWidget {
  final int prNo;

  const LopPage({super.key, required this.prNo});

  Future<List<dynamic>> fetchLopDetails() async {
    final response = await http.get(
        Uri.parse('http://localhost:5062/api/cpcl_lop_day_wise/prNo/$prNo'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Response: $jsonResponse'); // Debug: print the response

      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey("\$values")) {
        return jsonResponse["\$values"];
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      print(
          'Failed to load LOP details: ${response.statusCode}'); // Debug: print the status code
      throw Exception('Failed to load LOP details');
    }
  }

  String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd')
        .format(parsedDate); // Format to 'yyyy-MM-dd'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOP Details'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchLopDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final lopDetails = snapshot.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: lopDetails.length,
              itemBuilder: (context, index) {
                final detail = lopDetails[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From: ${formatDate(detail['from_dt'])}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'To: ${formatDate(detail['to_dt'])}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Days: ${detail['days']}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(height: 8),
                        if (detail['flag'] != null)
                          Text(
                            'Flag: ${detail['flag']}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
