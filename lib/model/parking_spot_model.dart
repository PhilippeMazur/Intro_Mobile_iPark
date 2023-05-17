// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSpotModel {
  final GeoPoint coordinate;
  final Timestamp from;
  final Timestamp until;
  final String size;
  final String user_uid;
  final String? reserved_by;
  late final String id;
  ParkingSpotModel({
    required this.coordinate,
    required this.from,
    required this.until,
    required this.size,
    required this.user_uid,
    this.reserved_by,
  });

  ParkingSpotModel copyWith({
    GeoPoint? coordinate,
    Timestamp? from,
    Timestamp? until,
    String? size,
    String? user_uid,
    String? reserved_by,
  }) {
    return ParkingSpotModel(
      coordinate: coordinate ?? this.coordinate,
      from: from ?? this.from,
      until: until ?? this.until,
      size: size ?? this.size,
      user_uid: user_uid ?? this.user_uid,
      reserved_by: reserved_by ?? this.reserved_by,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coordinate': coordinate,
      'from': from,
      'until': until,
      'size': size,
      'user_uid': user_uid,
      'reserved_by': reserved_by,
    };
  }

  factory ParkingSpotModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpotModel(
      coordinate: map['coordinate'],
      from: map['from'],
      until: map['until'],
      size: map['size'] as String,
      user_uid: map['user_uid'] as String,
      reserved_by:
          map['reserved_by'] != null ? map['reserved_by'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkingSpotModel.fromJson(String source) =>
      ParkingSpotModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ParkingSpotModel(coordinate: $coordinate, from: $from, until: $until, size: $size, user_uid: $user_uid, reserved_by: $reserved_by)';
  }

  @override
  bool operator ==(covariant ParkingSpotModel other) {
    if (identical(this, other)) return true;

    return other.coordinate == coordinate &&
        other.from == from &&
        other.until == until &&
        other.size == size &&
        other.user_uid == user_uid &&
        other.reserved_by == reserved_by;
  }

  @override
  int get hashCode {
    return coordinate.hashCode ^
        from.hashCode ^
        until.hashCode ^
        size.hashCode ^
        user_uid.hashCode ^
        reserved_by.hashCode;
  }
}
