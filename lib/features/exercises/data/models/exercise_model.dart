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
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    // Parse equipments: User JSON has "equipments": ["dumbbells", "incline bench"]
    // API Ninjas sometimes sends "equipment": "string"
    String equipmentStr = '';
    if (json['equipments'] != null && json['equipments'] is List) {
      equipmentStr = (json['equipments'] as List).join(', ');
    } else if (json['equipment'] != null) {
      equipmentStr = json['equipment'].toString();
    }

    return ExerciseModel(
      // ID strategy: name as ID since it's unique enough for this list
      id: json['name'] ?? 'unknown',
      name: json['name'] ?? '',
      // 'muscle' maps to bodyPart
      bodyPart: json['muscle'] ?? '',
      equipment: equipmentStr,
      // 'muscle' also maps to target if no specific target field
      target: json['muscle'] ?? '',
      // No dummy GIFs in user data
      gifUrl: '',
      // Instructions
      instructions: json['instructions'] != null
          ? [json['instructions'] as String]
          : [],
      // New fields
      difficulty: json['difficulty'] ?? '',
      type: json['type'] ?? '',
      safetyInfo: json['safety_info'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'muscle': bodyPart,
      'equipments': equipment.split(', '),
      'instructions': instructions.join(' '),
      'difficulty': difficulty,
      'type': type,
      'safety_info': safetyInfo,
    };
  }
}
