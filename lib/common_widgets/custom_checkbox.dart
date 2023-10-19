import 'package:flutter/material.dart';
import 'package:jeeth_app/colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color activeColor;
  final double size;

  CustomCheckbox({
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(!value);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? themeColor : white,
          border: Border.all(
            color: Colors.grey.shade600,
            width: value ? 0 : 2.0,
          ),
        ),
        child: Center(
          child: value
              ? Icon(
                  Icons.check,
                  size: size * 0.8,
                  color: white,
                )
              : null,
        ),
      ),
    );
  }
}
