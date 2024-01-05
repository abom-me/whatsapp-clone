import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String Error;
  const ErrorScreen({super.key, required this.Error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        Error,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
