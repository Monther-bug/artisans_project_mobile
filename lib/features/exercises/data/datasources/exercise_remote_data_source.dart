import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getExercises({
    int limit,
    int offset,
    String? searchQuery,
    String? bodyPart,
  });
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final Dio _dio;

  ExerciseRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ExerciseModel>> getExercises({
    int limit = 10,
    int offset = 0,
    String? searchQuery,
    String? bodyPart,
  }) async {
    try {
      Response response;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        response = await _dio.get(
          ApiConstants.searchEndpoint,
          queryParameters: {'offset': offset, 'limit': limit, 'q': searchQuery},
        );
      } else if (bodyPart != null && bodyPart.isNotEmpty && bodyPart != 'All') {
        response = await _dio.get(
          '${ApiConstants.bodyPartsEndpoint}/$bodyPart/exercises',
          queryParameters: {'offset': offset, 'limit': limit},
        );
      } else {
        response = await _dio.get(
          ApiConstants.exercisesEndpoint,
          queryParameters: {'offset': offset, 'limit': limit},
        );
      }

      debugPrint('API Request: ${response.realUri}');
      debugPrint('API Status: ${response.statusCode}');
      debugPrint('API Data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((e) => ExerciseModel.fromJson(e)).toList();
        } else {
          print('API Error: Success flag missing or data not a list');
          return [];
        }
      } else {
        throw ServerException('Failed to load exercises');
      }
    } on DioException catch (e) {
      print('API DioError: ${e.response?.statusCode} - ${e.message}');
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          return [];
        } else if (e.response?.statusCode == 401) {
          throw UnauthorizedException('Unauthorized access');
        }
      }
      throw ServerException('Network error occurred: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
