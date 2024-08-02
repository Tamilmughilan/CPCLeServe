import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final String prNo;
  final String name;

  const MainDrawer({super.key, required this.prNo, required this.name});

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'assets/profilepictures/$prNo.png';
    final String defaultImagePath = 'assets/images/logo.png';

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: UserAccountsDrawerHeader(
              accountName: Text(
                name,
                style: const TextStyle(
                  fontSize: 22, // Increased font size
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                prNo,
                style: const TextStyle(
                  fontSize: 18, // Increased font size
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                onBackgroundImageError: (_, __) {
                  // If there's an error loading the image, fallback to the default image.
                  AssetImage(defaultImagePath);
                },
                radius: 50,
                // Larger profile picture
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: <Widget>[
                // Add other drawer items if needed
                const Spacer(), // Pushes logout button to the bottom
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
