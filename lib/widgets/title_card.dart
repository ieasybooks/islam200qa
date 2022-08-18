import 'package:flutter/material.dart';
import 'package:islam200qa/utils/screen_utils.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({
    Key? key,
    required this.paragraph,
  }) : super(key: key);

  final String paragraph;

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: getDeviceWidth(context),
          child: Text(
            paragraph,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
