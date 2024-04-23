import 'package:flutter/material.dart';

class NotFoundKeyWidget extends StatelessWidget {
  final String translationKey;

  const NotFoundKeyWidget(
    this.translationKey, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 20),
          const Text(
            'Hard Localization:',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.red,
              fontSize: 25.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'The key "$translationKey" was not found.',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.red,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
