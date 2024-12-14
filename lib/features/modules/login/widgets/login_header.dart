import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final double width;
  final double height;

  const LoginHeader({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/StockBackground-1472x980.jpg',
            fit: BoxFit.cover,
            color: Colors.purple.withOpacity(0.6),
            colorBlendMode: BlendMode.srcOver,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Faça o seu login.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Divider(
                thickness: 5,
                color: Colors.white,
                endIndent: width * 0.65,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
