import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool? isReadOnly;
  final bool? showLength;

  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isReadOnly = false,
    this.onChanged,
    this.showLength = false,
    this.maxLength,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: (widget.isReadOnly!
                  ? Colors.grey
                  : Colors.blue.withOpacity(0.8)),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              height: 0,
            ),
          ),
          Stack(
            children: [
              TextFormField(
                readOnly: widget.isReadOnly!,
                controller: widget.controller,
                validator: widget.validator,
                obscureText: widget.isPassword,
                keyboardType: widget.keyboardType,
                minLines: 1,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                cursorColor: Colors.black,
                onChanged: widget.onChanged,
                enabled: !widget.isReadOnly!,
                decoration: InputDecoration(
                  hintText: widget.hint,
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
                  filled: widget.isReadOnly!,
                  fillColor: Colors.grey.withOpacity(0.2),
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
              if (widget.showLength!)
                Positioned(
                  right: 0,
                  top: 24,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Text(
                      '${widget.controller.text.length}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
