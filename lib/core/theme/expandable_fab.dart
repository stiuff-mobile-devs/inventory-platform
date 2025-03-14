import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final List<Widget> children;
  final VoidCallback onPressed;

  const ExpandableFab(
      {super.key, required this.children, required this.onPressed});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isExpanded)
          ...widget.children.map(
            (child) {
              int index = widget.children.indexOf(child);
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final positionAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset(0, -index * 0.1),
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeInOut,
                  ));

                  final opacityAnimation = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeInOut,
                  ));

                  return Positioned(
                    right: 0,
                    bottom: 70.0 + (index * 65),
                    child: FadeTransition(
                      opacity: opacityAnimation,
                      child: SlideTransition(
                        position: positionAnimation,
                        child: child,
                      ),
                    ),
                  );
                },
                child: child,
              );
            },
          ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            onPressed: () {
              _toggle();
              widget.onPressed();
            },
            tooltip: 'Expandir',
            backgroundColor: Colors.grey,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _expandAnimation.value * 0.80,
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
