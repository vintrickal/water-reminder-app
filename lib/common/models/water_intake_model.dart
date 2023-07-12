import 'package:json_annotation/json_annotation.dart';
part 'water_intake_model.g.dart';

@JsonSerializable()
class WaterIntakeModel {
  String? id;
  String? user_water_intake_id;
  double? intake;
  String? type;
  String? user_id;

  // @JsonKey(fromJson: _fromJson, toJson: _toJson)
  int? time;

  WaterIntakeModel(
      {this.id,
      this.user_water_intake_id,
      this.intake,
      this.type,
      this.user_id,
      this.time});

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) =>
      _$WaterIntakeModelFromJson(json);
  Map<String, dynamic> toJson() => _$WaterIntakeModelToJson(this);

  // static DateTime _fromJson(int int) =>
  //     DateTime.fromMillisecondsSinceEpoch(int);
  // static int _toJson(DateTime time) => time.millisecondsSinceEpoch;
}
