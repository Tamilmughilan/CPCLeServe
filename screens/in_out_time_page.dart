import 'package:flutter/material.dart';

class InOutTimePage extends StatelessWidget {
  const InOutTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In/Out Time'),
        leading: const BackButton(),
      ),
      body: const Center(
        child: Text('In/Out Time: 09:00 AM - 06:00 PM'),
      ),
    );
  }
}
