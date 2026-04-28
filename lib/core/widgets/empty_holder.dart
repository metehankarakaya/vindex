import 'package:flutter/material.dart';

class EmptyHolder extends StatelessWidget {
  final IconData iconData;
  final String title;
  const EmptyHolder({super.key, required this.iconData, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      children: [
        Icon(iconData, size: 72,),
        SizedBox(height: 12,),
        Text(title),
      ],
    );
  }
}
