import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blue.withOpacity(0.8),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              height: 0,
            ),
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            obscureText: isPassword,
            keyboardType: keyboardType,
            minLines: 1,
            maxLines: maxLines,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              // labelText: label,
              // labelStyle: const TextStyle(
              //   color: Colors.grey,
              //   fontSize: 16.0,
              // ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2.0),
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              // contentPadding:
              //     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
