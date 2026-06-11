import 'package:json_annotation/json_annotation.dart';

part 'member_api_model.g.dart';

@JsonSerializable()
class MemberApiModel {
  @JsonKey(name: '_id')
  final String memberId;
  final String fullName;
  final String email;

  const MemberApiModel({
    required this.memberId,
    required this.fullName,
    required this.email,
  });

  factory MemberApiModel.fromJson(Map<String, dynamic> json) =>
      _$MemberApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberApiModelToJson(this);
}
