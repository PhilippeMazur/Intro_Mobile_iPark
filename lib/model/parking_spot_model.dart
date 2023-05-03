// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSpotModel {
  final String? id;
  final GeoPoint coordinate;

  ParkingSpotModel({
    this.id,
    required this.coordinate,
  });

  ParkingSpotModel copyWith({
    String? id,
    GeoPoint? coordinate,
  }) {
    return ParkingSpotModel(
      id: id ?? this.id,
      coordinate: coordinate ?? this.coordinate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'coordinate': coordinate,
    };
  }

  factory ParkingSpotModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpotModel(
      id: map['id'] != null ? map['id'] as String : null,
      coordinate: map['coordinate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkingSpotModel.fromJson(String source) =>
      ParkingSpotModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ParkingSpotModel(id: $id, coordinate: $coordinate)';

  @override
  bool operator ==(covariant ParkingSpotModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.coordinate == coordinate;
  }

  @override
  int get hashCode => id.hashCode ^ coordinate.hashCode;
}
