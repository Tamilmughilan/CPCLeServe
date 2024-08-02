import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String prNo;

  const ProfilePage({super.key, required this.prNo});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profile;

  @override
  void initState() {
    super.initState();
    _profile = _fetchProfile(widget.prNo);
  }

  Future<Map<String, dynamic>> _fetchProfile(String prNo) async {
    final response = await http
        .get(Uri.parse('http://localhost:5062/api/Empviews/byprno/$prNo'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'assets/profilepictures/${widget.prNo}.png';
    final String defaultImagePath = 'assets/images/logo.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Profile not found'));
          } else {
            final profile = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Display employee picture
                        Center(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage(imagePath),
                            backgroundColor: Colors.grey[200],
                            onBackgroundImageError: (_, __) {
                              setState(() {
                                // If there's an error loading the image, fallback to the default image.
                                profile['profilePictureUrl'] = defaultImagePath;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'PR Number: ${profile['h01_EMP_NUM']}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Name: ${profile['h01_First_Name']}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Department: ${profile['c02_Function_Desc']}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Position: ${profile['c12_Positioncode']}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
