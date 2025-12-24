import 'package:flutter/material.dart';

class FuelScreen extends StatelessWidget {
  const FuelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الوقود'),
      ),
      body: const Center(
        child: Text(
          'شاشة الوقود\nقيد التطوير',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
