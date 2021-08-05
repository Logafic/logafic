import 'package:flutter/material.dart';

// ResetScreen label button

class LabelButton extends StatelessWidget {
  LabelButton({required this.labelText, required this.onPressed});
  final String labelText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        labelText,
      ),
      onPressed: onPressed,
    );
  }
}
