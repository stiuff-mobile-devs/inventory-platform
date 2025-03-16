import 'package:flutter/material.dart';

class ScrollableBottomNavigationBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedTabIndex;

  const ScrollableBottomNavigationBar({
    required this.onTabSelected,
    required this.selectedTabIndex,
    super.key,
  });

  @override
  ScrollableBottomNavigationBarState createState() =>
      ScrollableBottomNavigationBarState();
}

class ScrollableBottomNavigationBarState
    extends State<ScrollableBottomNavigationBar> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = true;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollIndicators);
  }

  void _updateScrollIndicators() {
    setState(() {
      _canScrollLeft = _scrollController.offset > 0;
      _canScrollRight =
          _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
  }

  void _toggleExpandCollapse() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollIndicators();
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleExpandCollapse,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  const Text(
                    'Navegação',
                    style: TextStyle(
                      color: Color.fromARGB(255, 54, 23, 148),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: const Color.fromARGB(255, 54, 23, 148),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.deepPurple.shade800,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? 80.0 : 0.0,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    children: [
                      _buildNavigationBarItem(
                          0, Icons.dashboard_rounded, 'Dashboard'),
                      _buildNavigationBarItem(
                          1, Icons.inventory_rounded, 'Inventories'),
                      _buildNavigationBarItem(2, Icons.data_object, 'Domains'),
                      _buildNavigationBarItem(3, Icons.tag, 'Tags'),
                      _buildNavigationBarItem(
                          4, Icons.barcode_reader, 'Readers'),
                      _buildNavigationBarItem(
                          5, Icons.groups_rounded, 'Members'),
                      _buildNavigationBarItem(6, Icons.device_hub, 'Entities'),
                      _buildNavigationBarItem(
                          7, Icons.summarize, 'Relatório'),
                      _buildNavigationBarItem(
                          8, Icons.admin_panel_settings, 'Admin'),
                    ],
                  ),
                ),
                if (_canScrollLeft)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: _scrollIndicator(Alignment.centerLeft),
                  ),
                if (_canScrollRight)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: _scrollIndicator(Alignment.centerRight),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _scrollIndicator(Alignment alignment) {
    return Container(
      width: 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: alignment == Alignment.centerLeft
              ? Alignment.centerLeft
              : Alignment.centerRight,
          end: alignment == Alignment.centerLeft
              ? Alignment.centerRight
              : Alignment.centerLeft,
          colors: [
            Colors.deepPurple.withOpacity(0.9),
            Colors.deepPurple.withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBarItem(int index, IconData icon, String label) {
    final bool isSelected = index == widget.selectedTabIndex;

    return GestureDetector(
      onTap: () => widget.onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurpleAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade300,
                size: isSelected ? 28 : 24,
              ),
            ),
            if (isSelected)
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
