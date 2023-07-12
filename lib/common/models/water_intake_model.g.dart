// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_intake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterIntakeModel _$WaterIntakeModelFromJson(Map<String, dynamic> json) =>
    WaterIntakeModel(
      id: json['id'] as String?,
      user_water_intake_id: json['user_water_intake_id'] as String?,
      intake: (json['intake'] as num?)?.toDouble(),
      type: json['type'] as String?,
      user_id: json['user_id'] as String?,
      time: json['time'] as int?,
    );

Map<String, dynamic> _$WaterIntakeModelToJson(WaterIntakeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_water_intake_id': instance.user_water_intake_id,
      'intake': instance.intake,
      'type': instance.type,
      'user_id': instance.user_id,
      'time': instance.time,
    };
