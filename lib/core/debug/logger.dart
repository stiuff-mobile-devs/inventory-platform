import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error }

class LogEntry {
  final String message;
  final LogLevel level;
  final DateTime timestamp;
  final StackTrace? stackTrace;

  LogEntry({
    required this.message,
    required this.level,
    required this.timestamp,
    this.stackTrace,
  });
}

class Logger {
  // Static list to store logs
  static final List<LogEntry> logs = [];

  // Maximum number of logs to store (to prevent memory issues)
  static const int _maxLogEntries = 1000;

  // Original Flutter error handler
  static FlutterExceptionHandler? _originalOnError;

  // Initialize the debug logger (DON'T call this directly - call from main())
  static void init() {
    if (kDebugMode) {
      // Store the original error handler
      _originalOnError = FlutterError.onError;

      // Set custom error handler
      FlutterError.onError = _handleFlutterError;
    }
  }

  // Log an info message
  static void info(String message) {
    _addLog(message, LogLevel.info);
  }

  // Log a warning message
  static void warning(String message) {
    _addLog(message, LogLevel.warning);
  }

  // Log an error message
  static void error(String message, [StackTrace? stackTrace]) {
    _addLog(message, LogLevel.error, stackTrace);
  }

  // Add log entry to the list
  static void _addLog(String message, LogLevel level,
      [StackTrace? stackTrace]) {
    print(message);
    logs.insert(
      0, // Insert at the beginning to show newest first
      LogEntry(
        message: message,
        level: level,
        timestamp: DateTime.now(),
        stackTrace: stackTrace,
      ),
    );

    // Trim logs if they exceed max count
    if (logs.length > _maxLogEntries) {
      logs.removeLast();
    }

    // Also print to console for development
    if (kDebugMode) {
      switch (level) {
        case LogLevel.info:
          developer.log(message);
          break;
        case LogLevel.warning:
          developer.log(message, name: 'WARNING');
          break;
        case LogLevel.error:
          developer.log(message, name: 'ERROR', error: stackTrace);
          break;
      }
    }
  }

  // Handle Flutter errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    error(
      "Flutter Error: ${details.exception}",
      details.stack ?? StackTrace.current,
    );

    // Call original handler if available
    _originalOnError?.call(details);
  }

  // Clear all logs
  static void clearLogs() {
    logs.clear();
  }
}
