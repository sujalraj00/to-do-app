import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String token;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.createdAt,
    required this.updatedAt
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    DateTime? createdAt,
    DateTime? updatedAt
  }){
    return UserModel(
      id: id ?? this.id, 
      name: name ?? this.name, 
      email: email ?? this.email, 
      token: token ?? this.token, 
      createdAt: createdAt ?? this.createdAt, 
      updatedAt: updatedAt ?? this.updatedAt
      );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id' : id,
      'email' : email,
      'name' : name,
      'token' : token,
      'createdAt' : createdAt.millisecondsSinceEpoch,
      'updatedAt' : updatedAt.millisecondsSinceEpoch
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(id: id, name: name, email: email, token: token, createdAt: createdAt, updatedAt: updatedAt)
  }
}