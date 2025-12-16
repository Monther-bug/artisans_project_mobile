import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/dummy_exercises.dart';
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

@LazySingleton(as: ExerciseRemoteDataSource)
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
      // Use Dummy Data for Demo
      // ignore: unused_local_variable
      final Map<String, dynamic> queryParams = {
        'offset': offset,
        'limit': limit,
      };

      if (searchQuery != null && searchQuery.isNotEmpty) {
        // filter dummy data
        final filtered = DummyExercises.data
            .where(
              (e) => e['name'].toString().toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();
        return filtered.map((e) => ExerciseModel.fromJson(e)).toList();
      } else if (bodyPart != null && bodyPart.isNotEmpty && bodyPart != 'all') {
        // API Ninjas and Dummy data use 'muscle'
        // But for now, let's just return all dummy data or filter if needed
        // The dummy data all have muscle='biceps', so let's just return all for simplicity or verify.
        final filtered = DummyExercises.data
            .where((e) => e['muscle'] == bodyPart)
            .toList();
        if (filtered.isEmpty && bodyPart != 'biceps')
          return []; // Should handle empty
        return filtered.isNotEmpty
            ? filtered.map((e) => ExerciseModel.fromJson(e)).toList()
            : DummyExercises.data
                  .map((e) => ExerciseModel.fromJson(e))
                  .toList();
      }

      // Default return all mock data
      return DummyExercises.data.map((e) => ExerciseModel.fromJson(e)).toList();

      /*
      final response = await _dio.get(
        ApiConstants.exercisesEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ExerciseModel.fromJson(e)).toList();
      } else {
        throw ServerException('Failed to load exercises');
      }
      */
    } on DioException {
      throw ServerException('Network error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
