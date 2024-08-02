import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatelessWidget {
  LocationPage({super.key});

  final List<Map<String, String>> addresses = [
    {
      'address': '''Chennai Petroleum Corporation Limited
  Manali, Chennai 600 068
  Telephone: EPABX-25944000-9
  Fax: 044-25941047''',
      'mapUrl':
          'https://www.google.com/maps/place/Chennai+Petroleum+Corporation+Ltd+Manali+Refinery/@13.1619219,80.2696744,17z/data=!3m1!4b1!4m6!3m5!1s0x3a5265509fe74f2b:0x909635aa839a6cc2!8m2!3d13.1619219!4d80.2696744!16s%2Fg%2F1tjrndgw?entry=ttu',
      'imagePath': 'assets/images/location.png', // Ensure the path is correct
    },
    {
      'address': '''536, Anna Salai, Thiru Vi Ka Kudiyiruppu,
  Teynampet, Chennai, Tamil Nadu 600018
  Telephone: EPABX-24340181''',
      'mapUrl':
          'https://www.google.com/maps/place/Chennai+Petroleum+Corporation+Limited+Corporate+Office/@13.0416308,80.2462807,15.25z/data=!4m6!3m5!1s0x3a526646647b2bf5:0x97464d87a58a2928!8m2!3d13.0423485!4d80.2472547!16s%2Fg%2F1td_3lxc?entry=ttu', // Replace with actual URL
      'imagePath': 'assets/images/location2.png', // Ensure the path is correct
    },
    {
      'address': '''Panangudi,Nagapattinam Taluk
  Nagapattinam-611002 
  Tamil Nadu
  Telephone: (04365)256416''',
      'mapUrl':
          'https://www.google.com/maps/place/Chennai+Petroleum+Corporation+Limited,+Cauvery+Basin+Refinery,+Housing+Complex/@10.8234551,79.8277994,13.99z/data=!4m6!3m5!1s0x3a5514a792077825:0xbcab6cd5120b07ac!8m2!3d10.8250861!4d79.8289713!16s%2Fg%2F11f1jxf741?entry=ttu', // Replace with actual URL
      'imagePath': 'assets/images/location3.png', // Ensure the path is correct
    },
    {
      'address': '''27P3+RW4, Seethammal Rd, Seethammal Colony, Lubdhi Colony, 
  Alwarpet, Chennai, Tamil Nadu 600018
  Telephone: 24323572''',
      'mapUrl':
          'https://www.google.com/maps/place/CPCL+RESOT+(Refinery+Engineering+School+Of+Training)/@13.0356801,80.2540983,14.67z/data=!4m14!1m7!3m6!1s0x3a5266355be30959:0xea546cc8a10d886b!2sCPCL+RESOT+(Refinery+Engineering+School+Of+Training)!8m2!3d13.0370037!4d80.254827!16s%2Fg%2F1tl0vryh!3m5!1s0x3a5266355be30959:0xea546cc8a10d886b!8m2!3d13.0370037!4d80.254827!16s%2Fg%2F1tl0vryh?entry=ttu', // Replace with actual URL
      'imagePath': 'assets/images/location4.png', // Ensure the path is correct
    },
    {
      'address': '''105-109 A,Ansal Chamber No:3 Bhikaji Cama Place 
  Ramakrishnapuram, New Delhi-110006
  Telephone: 011-26106341/2610634
  Fax:       011-26104219''',
      'mapUrl':
          'https://www.google.com/maps/place/Bhikaji+Cama+Place,+Rama+Krishna+Puram,+New+Delhi,+Delhi/@28.5662532,77.1843438,14.79z/data=!4m6!3m5!1s0x390d1d846557f081:0x37d23a4f15609462!8m2!3d28.567924!4d77.1880786!16s%2Fg%2F1tk6t92x?entry=ttu', // Replace with actual URL
      'imagePath': 'assets/images/location5.png', // Ensure the path is correct
    },
    {
      'address': '''J-7 Green Park Main
  New Delhi-110016
  Telephone: 011-26560396/2686709
  Fax:       011-26567646''',
      'mapUrl':
          'https://www.google.com/maps/place/Green+Park,+New+Delhi,+Delhi/@28.5533101,77.2039017,14.67z/data=!4m6!3m5!1s0x390ce2718a1bb9d7:0xfd9760b4153efbec!8m2!3d28.5584489!4d77.2029376!16s%2Fm%2F06zrxgk?entry=ttu', // Replace with actual URL
      'imagePath': 'assets/images/location6.png', // Ensure the path is correct
    },
  ];

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: addresses.map((address) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address['address']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  AspectRatio(
                    aspectRatio: 16 / 9, // Adjust aspect ratio as needed
                    child: MapImageWidget(
                      imagePath: address['imagePath']!,
                      onTap: () => _launchURL(address['mapUrl']!),
                    ),
                  ),
                  const SizedBox(height: 16.0), // Space between sections
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MapImageWidget extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const MapImageWidget(
      {super.key, required this.imagePath, required this.onTap});

  @override
  _MapImageWidgetState createState() => _MapImageWidgetState();
}

class _MapImageWidgetState extends State<MapImageWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedScale(
              scale: _isHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            if (_isHovered)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Click to view on map',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
