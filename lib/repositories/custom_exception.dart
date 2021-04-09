import 'package:hooks_riverpod/hooks_riverpod.dart';

final customExceptionProvider = StateProvider<CustomException?>((ref) => null);

class CustomException implements Exception {
  final String? message;

  const CustomException({this.message = 'Something went wrong!'});

  @override
  String toString() {
    return 'CustomException {message: $message}';
  }
}
