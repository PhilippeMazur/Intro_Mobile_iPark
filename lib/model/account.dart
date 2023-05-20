// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Account {
  String username;
  String email;
  String user_uid;
  late String id;
  Account({
    required this.username,
    required this.email,
    required this.user_uid,
  });

  Account copyWith({
    String? username,
    String? email,
    String? user_uid,
  }) {
    return Account(
      username: username ?? this.username,
      email: email ?? this.email,
      user_uid: user_uid ?? this.user_uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'user_uid': user_uid,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      username: map['username'] as String,
      email: map['email'] as String,
      user_uid: map['user_uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Account(username: $username, email: $email, user_uid: $user_uid)';

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.email == email &&
        other.user_uid == user_uid;
  }

  @override
  int get hashCode => username.hashCode ^ email.hashCode ^ user_uid.hashCode;
}
