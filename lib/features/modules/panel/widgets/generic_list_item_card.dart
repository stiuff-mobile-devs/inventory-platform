import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_platform/features/data/models/generic_list_item_model.dart';

class GenericListItemCard extends StatelessWidget {
  final GenericListItemModel item;
  final String? firstDetailFieldName;
  final String? secondDetailFieldName;

  const GenericListItemCard({
    super.key,
    required this.item,
    this.firstDetailFieldName,
    this.secondDetailFieldName,
  });

  String _formatDate(DateTime? date) {
    return date != null
        ? DateFormat.yMMMMd().format(date)
        : "Data Indisponível";
  }

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
        title: Text(item.upperHeaderField,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.lowerHeaderField != null)
              Text(item.lowerHeaderField!,
                  style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(
                '${firstDetailFieldName ?? ''}: ${_formatDate(item.initialDate)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
            Text(
                '${secondDetailFieldName ?? ''}: ${_formatDate(item.lastUpdatedAt)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0))
          ],
        ),
        trailing: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              item.isActive == 1
                  ? Icons.circle_outlined
                  : Icons.circle_outlined,
              color: item.isActive == 1 ? Colors.green : Colors.red,
              size: 20.0,
            ),
            Icon(
              item.isActive == 1 ? Icons.circle : Icons.circle,
              color: item.isActive == 1 ? Colors.green : Colors.red,
              size: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}
