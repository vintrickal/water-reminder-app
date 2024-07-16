import 'package:json_annotation/json_annotation.dart';
part 'user_water_intake_model.g.dart';

@JsonSerializable()
class UserWaterIntakeModel {
  String? id;
  String? fusion_id;
  String? user_id;
  String? month_id;
  double? past_intake;
  double? current_intake;
  double? goal_intake;
  double? percent_intake;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime date_time;

  UserWaterIntakeModel({
    this.id,
    this.fusion_id,
    this.user_id,
    this.past_intake,
    this.current_intake,
    this.goal_intake,
    this.percent_intake,
    this.month_id,
    required this.date_time,
  });

  factory UserWaterIntakeModel.fromJson(Map<String, dynamic> json) =>
      _$UserWaterIntakeModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserWaterIntakeModelToJson(this);

  static DateTime _fromJson(int int) =>
      DateTime.fromMillisecondsSinceEpoch(int);
  static int _toJson(DateTime time) => time.millisecondsSinceEpoch;
}
