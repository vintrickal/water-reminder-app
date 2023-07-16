import 'package:json_annotation/json_annotation.dart';
part 'cup_model.g.dart';

@JsonSerializable()
class CupModel {
  String? id;
  String? type;
  String? capacity;
  String? path;

  CupModel({this.id, this.type, this.capacity, this.path});

  factory CupModel.fromJson(Map<String, dynamic> json) =>
      _$CupModelFromJson(json);
  Map<String, dynamic> toJson() => _$CupModelToJson(this);
}
