import 'package:flutter/material.dart';

class TagBox extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const TagBox({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
      ),
      child: Text(
        text,
        textScaler: const TextScaler.linear(0.9),
        style: TextStyle(
          color:
              textColor ??
              (Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black),
        ),
      ),
    );
  }
}
