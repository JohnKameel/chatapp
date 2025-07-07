
import 'package:json_annotation/json_annotation.dart';
part 'user_info_model.g.dart';
@JsonSerializable()
class UserInfoModel {
  final String UID;
  final String email;
  final String user_name;
  final String phone_num;
  final String? image_profile;

  UserInfoModel({
    required this.UID,
    required this.email,
    required this.user_name,
    required this.phone_num,
    required this.image_profile,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}