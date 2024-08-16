import 'package:flutter/material.dart';

class OrientationButton extends StatelessWidget {
  const OrientationButton({super.key, required this.orientation, this.onTap});
  final String orientation;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextButton(
        onPressed: () => onTap?.call(orientation),
        child: Text(
          orientation,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
