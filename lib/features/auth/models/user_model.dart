import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.isApproved,
  });

  final String uid;
  final String email;
  final String role;
  final bool isApproved;

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      email: map['email']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user',
      isApproved: map['isApproved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'isApproved': isApproved,
    };
  }

  @override
  List<Object?> get props => [uid, email, role, isApproved];
}
