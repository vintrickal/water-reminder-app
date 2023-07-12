// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_water_intake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWaterIntakeModel _$UserWaterIntakeModelFromJson(
        Map<String, dynamic> json) =>
    UserWaterIntakeModel(
      id: json['id'] as String?,
      fusion_id: json['fusion_id'] as String?,
      user_id: json['user_id'] as String?,
      past_intake: (json['past_intake'] as num?)?.toDouble(),
      current_intake: (json['current_intake'] as num?)?.toDouble(),
      goal_intake: (json['goal_intake'] as num?)?.toDouble(),
      percent_intake: (json['percent_intake'] as num?)?.toDouble(),
      date_time: UserWaterIntakeModel._fromJson(json['date_time'] as int),
    );

Map<String, dynamic> _$UserWaterIntakeModelToJson(
        UserWaterIntakeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fusion_id': instance.fusion_id,
      'user_id': instance.user_id,
      'past_intake': instance.past_intake,
      'current_intake': instance.current_intake,
      'goal_intake': instance.goal_intake,
      'percent_intake': instance.percent_intake,
      'date_time': UserWaterIntakeModel._toJson(instance.date_time),
    };
