// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameResultAdapter extends TypeAdapter<GameResult> {
  @override
  final int typeId = 0;

  @override
  GameResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameResult(
      fields[0] as String,
      fields[1] as String,
      fields[2] as bool,
      fields[3] as int,
      fields[4] as DateTime,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GameResult obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.guesses)
      ..writeByte(2)
      ..write(obj.didWin)
      ..writeByte(3)
      ..write(obj.numberOfGuesses)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
