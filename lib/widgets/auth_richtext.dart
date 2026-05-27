import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';

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
        children: [
          TextSpan(
            text: leadingtext,
            style: AppTextStyles.authLeading,
          ),
          TextSpan(
            text: actionText,
            style: AppTextStyles.authAction,
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
