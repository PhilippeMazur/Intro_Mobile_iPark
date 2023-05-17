// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Account {
  String username;
  String email;
  late String id;
  Account({
    required this.username,
    required this.email,
  });

  Account copyWith({
    String? username,
    String? email,
  }) {
    return Account(
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Account(username: $username, email: $email)';

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.username == username && other.email == email;
  }

  @override
  int get hashCode => username.hashCode ^ email.hashCode;
}
