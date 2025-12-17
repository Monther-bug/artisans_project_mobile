import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final String gifUrl;
  final List<String> instructions;
  final String difficulty;
  final String type;
  final String safetyInfo;
  final List<String> secondaryMuscles;

  const ExerciseEntity({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.gifUrl,
    required this.instructions,
    this.difficulty = '',
    this.type = '',
    this.safetyInfo = '',
    this.secondaryMuscles = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    bodyPart,
    equipment,
    target,
    gifUrl,
    instructions,
    difficulty,
    type,
    safetyInfo,
    secondaryMuscles,
  ];
}
