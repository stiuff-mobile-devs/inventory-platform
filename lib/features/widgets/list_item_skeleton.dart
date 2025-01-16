import 'package:flutter/material.dart';

class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        title: Container(
          height: 14.0,
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Container(
              height: 10.0,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 10.0,
              width: 80.0,
              color: Colors.grey.shade300,
            ),
          ],
        ),
        trailing: Container(
          height: 20.0,
          width: 20.0,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
