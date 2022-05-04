import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String authId,
    required String username,
  }) = _User;

  const User._();

  static User? fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }
    return User.fromJson(data);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
