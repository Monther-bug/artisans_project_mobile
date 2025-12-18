import 'package:hive_flutter/hive_flutter.dart';
import 'exercise_model.dart';

class ExerciseAdapter extends TypeAdapter<ExerciseModel> {
  @override
  final int typeId = 0;

  @override
  ExerciseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseModel(
      id: fields[0] as String,
      name: fields[1] as String,
      bodyPart: fields[2] as String,
      equipment: fields[3] as String,
      target: fields[4] as String,
      gifUrl: fields[5] as String,
      instructions: (fields[6] as List).cast<String>(),
      difficulty: (fields[7] as String?) ?? '',
      type: (fields[8] as String?) ?? '',
      safetyInfo: (fields[9] as String?) ?? '',
      secondaryMuscles: (fields[10] as List?)?.cast<String>() ?? const [],
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bodyPart)
      ..writeByte(3)
      ..write(obj.equipment)
      ..writeByte(4)
      ..write(obj.target)
      ..writeByte(5)
      ..write(obj.gifUrl)
      ..writeByte(6)
      ..write(obj.instructions)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.safetyInfo)
      ..writeByte(10)
      ..write(obj.secondaryMuscles);
  }
}
