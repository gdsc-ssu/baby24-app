import 'package:dio/dio.dart';
import 'package:pickiverse_app/data/services/api_exception.dart';
import 'package:pickiverse_app/data/services/api_result.dart';
import 'package:pickiverse_app/data/services/api_service.dart';
import 'package:pickiverse_app/data/services/dio_client.dart';

class ApiServiceImpl implements ApiService {
  ApiServiceImpl({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  @override
  Future<ApiResult<T>> getData<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(endpoint);

      if (fromJson != null) {
        return ApiSuccess(fromJson(response.data));
      }
      return ApiSuccess(response.data as T);
    } on DioException catch (e) {
      return ApiFailure(
        ApiException(
          message: e.message ?? 'Unknown error occurred',
          code: e.response?.statusCode,
          details: e.response?.data,
        ),
      );
    } catch (e) {
      return ApiFailure(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<T>> postData<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dioClient.post<dynamic>(endpoint, data: data);

      if (fromJson != null) {
        return ApiSuccess(fromJson(response.data));
      }
      return ApiSuccess(response.data as T);
    } on DioException catch (e) {
      return ApiFailure(
        ApiException(
          message: e.message ?? 'Unknown error occurred',
          code: e.response?.statusCode,
          details: e.response?.data,
        ),
      );
    } catch (e) {
      return ApiFailure(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<T>> putData<T>(
    String endpoint, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dioClient.put<dynamic>(endpoint, data: data);

      if (fromJson != null) {
        return ApiSuccess(fromJson(response.data));
      }
      return ApiSuccess(response.data as T);
    } on DioException catch (e) {
      return ApiFailure(
        ApiException(
          message: e.message ?? 'Unknown error occurred',
          code: e.response?.statusCode,
          details: e.response?.data,
        ),
      );
    } catch (e) {
      return ApiFailure(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<T>> deleteData<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dioClient.delete<dynamic>(endpoint);

      if (fromJson != null) {
        return ApiSuccess(fromJson(response.data));
      }
      return ApiSuccess(response.data as T);
    } on DioException catch (e) {
      return ApiFailure(
        ApiException(
          message: e.message ?? 'Unknown error occurred',
          code: e.response?.statusCode,
          details: e.response?.data,
        ),
      );
    } catch (e) {
      return ApiFailure(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }
}
