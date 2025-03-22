import 'package:logger/logger.dart';

/// A utility class for logging messages in a structured and customizable way.
///
/// This logger uses the `Logger` package and a `PrettyPrinter` to format logs
/// with features like method count, colorful output, emojis, and more.
///
/// ### Developer
/// - **Name:** Md. Shamsuzzaman
/// - **GitHub:** [zamansheikh](https://github.com/zamansheikh)
///
/// ### Usage
/// Use the static methods (`d`, `i`, `w`, `e`, `f`) to log messages directly.
/// Or use the `Loggable` extension to log messages from any object.
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 300, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Logs a debug message.
  ///
  /// Use this to log general information for debugging purposes.
  ///
  /// - [message]: The message to log.
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an informational message.
  ///
  /// Use this to log informational messages or normal app events.
  ///
  /// - [message]: The message to log.
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  ///
  /// Use this to log potential issues that may need attention.
  ///
  /// - [message]: The message to log.
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  ///
  /// Use this to log errors and exceptions.
  ///
  /// - [message]: The message to log.
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a fatal error message.
  ///
  /// Use this to log critical issues that cause application crashes.
  ///
  /// - [message]: The message to log.
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: stackTrace);
  }
}

/// Extension for easier logging on objects.
///
/// This extension adds logging methods (`logD`, `logI`, `logW`, `logE`, `logF`)
/// to any object, making it convenient to log directly from any instance.
///
/// ### Example
/// ```dart
/// "A debug message".logD();
/// 123.logI();
/// ```
extension Loggable on Object {
  /// Logs a debug message using the current object.
  ///
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  void logD([dynamic error, StackTrace? stackTrace]) {
    AppLogger.d(this, error, stackTrace);
  }

  /// Logs an informational message using the current object.
  ///
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  void logI([dynamic error, StackTrace? stackTrace]) {
    AppLogger.i(this, error, stackTrace);
  }

  /// Logs a warning message using the current object.
  ///
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  void logW([dynamic error, StackTrace? stackTrace]) {
    AppLogger.w(this, error, stackTrace);
  }

  /// Logs an error message using the current object.
  ///
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  void logE([dynamic error, StackTrace? stackTrace]) {
    AppLogger.e(this, error, stackTrace);
  }

  /// Logs a fatal error message using the current object.
  ///
  /// - [error]: (Optional) An error object to include in the log.
  /// - [stackTrace]: (Optional) A stack trace to include in the log.
  void logF([dynamic error, StackTrace? stackTrace]) {
    AppLogger.f(this, error, stackTrace);
  }
}
