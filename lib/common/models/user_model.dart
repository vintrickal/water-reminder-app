import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? id;
  String? device_token;
  String? user_id;
  String? status;
  String? gender;
  int? weight;
  String? wake_up_time;
  String? sleep_time;
  String? selected_cup;
  double? user_goal_intake;
  double? recommended_goal_intake;
  String? display_mode;
  bool? hideTips;

  UserModel({
    this.id,
    this.device_token,
    this.user_id,
    this.status,
    this.gender,
    this.weight,
    this.wake_up_time,
    this.sleep_time,
    this.selected_cup,
    this.user_goal_intake,
    this.recommended_goal_intake,
    this.display_mode,
    this.hideTips,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
