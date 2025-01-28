import 'package:flutter/material.dart';

class WarningMessage extends StatelessWidget {
  final String title;
  final String message;
  final bool hasOnConfirm;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const WarningMessage({
    super.key,
    required this.hasOnConfirm,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        (hasOnConfirm)
            ? ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Confirmar'),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

void showWarningDialog({
  bool? hasOnConfirm,
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WarningMessage(
        title: title,
        hasOnConfirm: hasOnConfirm ?? false,
        message: message,
        onConfirm: onConfirm,
        onCancel: onCancel,
      );
    },
  );
}
