import 'package:dio/dio.dart';

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
      final response = await _dio.get(
        ApiConstants.exercisesEndpoint,
        queryParameters: {
          'offset': offset,
          'limit': limit,
          if (searchQuery != null) 'name': searchQuery,
          if (bodyPart != null) 'muscle': bodyPart,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ExerciseModel.fromJson(e)).toList();
      } else {
        throw ServerException('Failed to load exercises');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          throw NotFoundException('Exercises not found');
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
