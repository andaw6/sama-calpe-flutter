import 'package:ehac_money/models/pagination.dart';

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;             
  final List<T>? dataList;   
  final Pagination? pagination;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.dataList,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final dataJson = json['data'];

    // Si 'data' est une liste, le remplir dans 'dataList', sinon dans 'data'
    return ApiResponse<T>(
      success: json['status'] == 'SUCCESS',
      message: json['message'],
      data: (dataJson != null && dataJson is! List) ? fromJsonT(dataJson) : null,
      dataList: (dataJson != null && dataJson is List) ? dataJson.map((item) => fromJsonT(item)).toList() : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );

  }
}

