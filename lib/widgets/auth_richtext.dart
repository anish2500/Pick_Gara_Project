import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthRichtext extends StatelessWidget {
  final String leadingtext;
  final String actionText;

  final VoidCallback onTap;
  const AuthRichtext({
    super.key,
    required this.leadingtext,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'SF', fontSize: 14),
        children: [
          TextSpan(
            text: leadingtext,
            style: const TextStyle(
              color: Color(0xFF605F6A),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: actionText,
            style: const TextStyle(
              color: Color(0xFF453CE1),
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
