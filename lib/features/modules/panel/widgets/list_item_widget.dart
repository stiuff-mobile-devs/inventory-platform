import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final Map<String, dynamic> attributes;

  final int isActive;
  final IconData? icon;

  final Function(BuildContext) onTap;

  const ListItemWidget({
    super.key,
    required this.attributes,
    required this.isActive,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        title: Text(
          attributes.entries.first.value,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black87),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (attributes.length >= 2) ...[
              Text(
                '${attributes.entries.toList()[1].value}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
            ...attributes.entries.skip(2).map(
                  (entry) => Text(
                    '${entry.key}: ${entry.value.toString()}',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
                  ),
                ),
          ],
        ),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            icon ?? Icons.circle,
            color: isActive == 1 ? Colors.green : Colors.red,
            size: 16.0,
          ),
        ),
        onTap: () => onTap(context),
      ),
    );
  }
}
