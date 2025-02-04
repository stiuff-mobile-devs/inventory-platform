import 'package:flutter/material.dart';

class TemporaryMessageDisplay extends StatefulWidget {
  final String? message;
  const TemporaryMessageDisplay({super.key, this.message});

  @override
  TemporaryMessageDisplayState createState() => TemporaryMessageDisplayState();
}

class TemporaryMessageDisplayState extends State<TemporaryMessageDisplay> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: MediaQuery.of(context).size.width * 0.925,
            height: MediaQuery.of(context).size.height * 0.10,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Center(
              child: Text(
                widget.message ?? "Something went wrong.",
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
