import 'package:equatable/equatable.dart';

final class InternalError extends Equatable implements Exception{
  final int httpCode;
  final String message;
  final int code;
  final List<String>? details;

  const InternalError(this.httpCode, this.message, this.code, [this.details]);
  
  @override
  List<Object?> get props => [httpCode, message, code, details];

  static InternalError fromJson(Map<String, dynamic> json) {
    return InternalError(
      json['httpCode'] as int,
      json['message'] as String,
      json['code'] as int,
      json['details'] != null ? List<String>.from(json['details']) : [],
    );
  }
}