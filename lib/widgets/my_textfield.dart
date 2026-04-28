import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;

  const MyTextfield({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.controller,
    this.onChanged,
    this.obscureText = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFC7C9D9),
        ), // Light hint color
        prefixIconConstraints: const BoxConstraints(minWidth: 60, minHeight: 0),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                ), // Control distance from the far left edge
                child: Icon(prefixIcon, color: const Color(0xFFC7C9D9)),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(suffixIcon, color: const Color(0xFFC7C9D9)),
                ),
              )
            : null,
        // Filling the background
        filled: true,
        fillColor: const Color(
          0xFFF3F5FF,
        ), // Light blueish/white background from image
        // Border styling to get the pill shape
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Very rounded corners
          borderSide: BorderSide.none, // Remove the outline
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF453CE1),
            width: 1,
          ), // Optional focus ring
        ),
      ),
    );
  }
}
