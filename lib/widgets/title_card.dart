import 'package:flutter/material.dart';
import 'package:islam200qa/utils/screen_utils.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({Key? key, required this.paragraph}) : super(key: key);

  final String paragraph;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: getDeviceWidth(context),
          child: SelectableText(
            paragraph,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
