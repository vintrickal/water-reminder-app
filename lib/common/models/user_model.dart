import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? id;
  String? user_id;
  String? status;
  String? gender;
  int? weight;
  String? wake_up_time;
  String? sleep_time;

  UserModel(
      {this.id,
      this.user_id,
      this.status,
      this.gender,
      this.weight,
      this.wake_up_time,
      this.sleep_time});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
