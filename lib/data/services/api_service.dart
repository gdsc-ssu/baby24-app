import 'package:pickiverse_app/data/services/api_result.dart';

abstract class ApiService {
  Future<ApiResult<T>> getData<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  });

  Future<ApiResult<T>> postData<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson,
  });

  Future<ApiResult<T>> putData<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson,
  });

  Future<ApiResult<T>> deleteData<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  });
}
