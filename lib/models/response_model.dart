class ApiResponse {  final bool error;
final String message;

ApiResponse({required this.error, required this.message});

factory ApiResponse.fromJson(Map<String, dynamic> json) {
  return ApiResponse(
    // Ensure error is a bool, default to false if null
    error: json['error'] == true,

    // Force conversion to String and provide fallback
    message: json['message']?.toString() ?? '',
  );
}
}