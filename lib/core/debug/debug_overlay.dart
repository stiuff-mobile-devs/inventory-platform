import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inventory_platform/core/debug/logger.dart';
import 'package:inventory_platform/core/debug/network_logger.dart';

class DebugOverlay extends StatefulWidget {
  final Widget child;

  const DebugOverlay({super.key, required this.child});

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay>
    with SingleTickerProviderStateMixin {
  bool _showDebugPanel = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return widget.child;

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        widget.child,
        // Debug button in bottom right corner
        Positioned(
          right: 16,
          bottom: 16,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showDebugPanel = !_showDebugPanel;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.bug_report, size: 20, color: Colors.white),
              ),
            ),
          ),
        ),

        // Debug panel (when shown)
        if (_showDebugPanel)
          Positioned.fill(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark(),
              home: Scaffold(
                backgroundColor: Colors.transparent,
                body: Material(
                  type: MaterialType.canvas,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text('DEBUG CONSOLE',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _showDebugPanel = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(text: 'LOGS'),
                            Tab(text: 'NETWORK'),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.black,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _LogsTab(),
                                _NetworkTab(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LogsTab extends StatefulWidget {
  @override
  State<_LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends State<_LogsTab> {
  // Controller for auto-scrolling to bottom
  final ScrollController _scrollController = ScrollController();

  // For keeping track of logs count to detect changes
  int _previousLogCount = 0;

  @override
  void initState() {
    super.initState();
    _previousLogCount = Logger.logs.length;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _LogsTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If logs increased, scroll to top (since new logs are at the top)
    if (Logger.logs.length > _previousLogCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    _previousLogCount = Logger.logs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Logger.logs.length} logs",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Clear', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  setState(() {
                    Logger.clearLogs();
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Logger.logs.isEmpty
              ? const Center(child: Text('No logs yet'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: Logger.logs.length,
                  itemBuilder: (context, index) {
                    final log = Logger.logs[index];
                    return ExpansionTile(
                      title: Text(
                        log.message,
                        style: TextStyle(
                          color: _getLogColor(log.level),
                          fontSize: 12,
                          fontWeight: log.level == LogLevel.error
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        log.timestamp.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      // Only show expansion arrow if there's a stack trace
                      trailing: log.stackTrace != null
                          ? const Icon(Icons.keyboard_arrow_down,
                              color: Colors.grey)
                          : null,
                      children: [
                        if (log.stackTrace != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  log.stackTrace.toString(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Color _getLogColor(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Colors.white;
      case LogLevel.warning:
        return Colors.yellow;
      case LogLevel.error:
        return Colors.red;
    }
  }
}

class _NetworkTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: NetworkLogger.requests.length,
      itemBuilder: (context, index) {
        final request = NetworkLogger.requests[index];
        return ExpansionTile(
          title: Text(
            '${request.method} ${request.url}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          subtitle: Text(
            '${request.statusCode} - ${request.timestamp}',
            style: TextStyle(
              color: _getStatusColor(request.statusCode),
              fontSize: 10,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Headers:', style: TextStyle(color: Colors.grey)),
                  Text(request.headers,
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  const Text('Request:', style: TextStyle(color: Colors.grey)),
                  Text(request.requestBody,
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  const Text('Response:', style: TextStyle(color: Colors.grey)),
                  Text(request.responseBody,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(int? statusCode) {
    if (statusCode == null) return Colors.grey;
    if (statusCode >= 200 && statusCode < 300) return Colors.green;
    if (statusCode >= 300 && statusCode < 400) return Colors.blue;
    if (statusCode >= 400 && statusCode < 500) return Colors.orange;
    return Colors.red;
  }
}
