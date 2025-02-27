import 'package:expense_management_app/domain/entities/user.dart';
import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@HiveType(typeId: 0)
class UserModel with _$UserModel implements UserEntity {
  factory UserModel({
    @HiveField(0) required String uid,
    @HiveField(1) required String email,
    @HiveField(2) required String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
