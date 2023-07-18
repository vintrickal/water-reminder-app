// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      device_token: json['device_token'] as String?,
      user_id: json['user_id'] as String?,
      status: json['status'] as String?,
      gender: json['gender'] as String?,
      weight: json['weight'] as int?,
      wake_up_time: json['wake_up_time'] as String?,
      sleep_time: json['sleep_time'] as String?,
      selected_cup: json['selected_cup'] as String?,
      user_goal_intake: (json['user_goal_intake'] as num?)?.toDouble(),
      recommended_goal_intake:
          (json['recommended_goal_intake'] as num?)?.toDouble(),
      display_mode: json['display_mode'] as String?,
      hideTips: json['hideTips'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'device_token': instance.device_token,
      'user_id': instance.user_id,
      'status': instance.status,
      'gender': instance.gender,
      'weight': instance.weight,
      'wake_up_time': instance.wake_up_time,
      'sleep_time': instance.sleep_time,
      'selected_cup': instance.selected_cup,
      'user_goal_intake': instance.user_goal_intake,
      'recommended_goal_intake': instance.recommended_goal_intake,
      'display_mode': instance.display_mode,
      'hideTips': instance.hideTips,
    };
