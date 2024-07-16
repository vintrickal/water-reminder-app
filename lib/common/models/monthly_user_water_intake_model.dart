import 'package:json_annotation/json_annotation.dart';
part 'monthly_user_water_intake_model.g.dart';

@JsonSerializable()
class MonthlyUserWaterIntakeModel {
  String? id;
  int? month;
  double? water_intake;
  int? year;
  String? user_id;

  MonthlyUserWaterIntakeModel({
    this.id,
    this.month,
    this.water_intake,
    this.year,
    this.user_id,
  });

  factory MonthlyUserWaterIntakeModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyUserWaterIntakeModelFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyUserWaterIntakeModelToJson(this);
}
