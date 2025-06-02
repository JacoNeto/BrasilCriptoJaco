class ApiResponse<T> {
  final int? statusCode;
  final T? data;

  ApiResponse(this.statusCode, this.data);
}