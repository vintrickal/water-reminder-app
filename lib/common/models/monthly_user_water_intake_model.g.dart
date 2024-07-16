// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_user_water_intake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyUserWaterIntakeModel _$MonthlyUserWaterIntakeModelFromJson(
        Map<String, dynamic> json) =>
    MonthlyUserWaterIntakeModel(
      id: json['id'] as String?,
      month: json['month'] as int?,
      water_intake: (json['water_intake'] as num?)?.toDouble(),
      year: json['year'] as int?,
      user_id: json['user_id'] as String?,
    );

Map<String, dynamic> _$MonthlyUserWaterIntakeModelToJson(
        MonthlyUserWaterIntakeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'month': instance.month,
      'water_intake': instance.water_intake,
      'year': instance.year,
      'user_id': instance.user_id,
    };
