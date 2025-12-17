import '../../domain/entities/exercise_entity.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.bodyPart,
    required super.equipment,
    required super.target,
    required super.gifUrl,
    required super.instructions,
    super.difficulty,
    super.type,
    super.safetyInfo,
    super.secondaryMuscles,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    String extractFirst(dynamic list) {
      if (list is List && list.isNotEmpty) {
        return list[0].toString();
      }
      return '';
    }

    List<String> extractInstructions(dynamic instructions) {
      if (instructions is List) {
        return instructions.map((e) => e.toString()).toList();
      }
      return [];
    }

    return ExerciseModel(
      id: json['exerciseId'] ?? json['name'] ?? 'unknown',
      name: json['name'] ?? '',
      bodyPart: extractFirst(json['bodyParts']),
      equipment: extractFirst(json['equipments']),
      target: extractFirst(json['targetMuscles']),
      gifUrl: json['gifUrl'] ?? '',
      instructions: extractInstructions(json['instructions']),

      difficulty: json['difficulty'] ?? '',
      type: json['type'] ?? '',
      secondaryMuscles:
          (json['secondaryMuscles'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      safetyInfo: json['safety_info'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': id,
      'name': name,
      'bodyParts': [bodyPart],
      'equipments': [equipment],
      'targetMuscles': [target],
      'gifUrl': gifUrl,
      'instructions': instructions,
      'difficulty': difficulty,
      'type': type,
      'safety_info': safetyInfo,
    };
  }
}
