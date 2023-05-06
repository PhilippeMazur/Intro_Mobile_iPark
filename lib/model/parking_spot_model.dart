// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSpotModel {
  final GeoPoint coordinate;
  final String from;
  final String until;
  final String size;
  final String user_uid;
  ParkingSpotModel({
    required this.coordinate,
    required this.from,
    required this.until,
    required this.size,
    required this.user_uid,
  });

  ParkingSpotModel copyWith({
    GeoPoint? coordinate,
    String? from,
    String? until,
    String? size,
    String? user_uid,
  }) {
    return ParkingSpotModel(
      coordinate: coordinate ?? this.coordinate,
      from: from ?? this.from,
      until: until ?? this.until,
      size: size ?? this.size,
      user_uid: user_uid ?? this.user_uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coordinate': coordinate,
      'from': from,
      'until': until,
      'size': size,
      'user_uid': user_uid,
    };
  }

  factory ParkingSpotModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpotModel(
      coordinate: map['coordinate'],
      from: map['from'] as String,
      until: map['until'] as String,
      size: map['size'] as String,
      user_uid: map['user_uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkingSpotModel.fromJson(String source) =>
      ParkingSpotModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ParkingSpotModel(coordinate: $coordinate, from: $from, until: $until, size: $size, user_uid: $user_uid)';
  }

  @override
  bool operator ==(covariant ParkingSpotModel other) {
    if (identical(this, other)) return true;

    return other.coordinate == coordinate &&
        other.from == from &&
        other.until == until &&
        other.size == size &&
        other.user_uid == user_uid;
  }

  @override
  int get hashCode {
    return coordinate.hashCode ^
        from.hashCode ^
        until.hashCode ^
        size.hashCode ^
        user_uid.hashCode;
  }
}
