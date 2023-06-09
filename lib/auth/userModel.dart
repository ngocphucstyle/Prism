// ignore_for_file: cast_nullable_to_non_nullable

import 'package:Prism/auth/badgeModel.dart';
import 'package:Prism/auth/transactionModel.dart';
import 'package:Prism/logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

@HiveType(typeId: 15)
@JsonSerializable(
  explicitToJson: true,
)
class PrismUsersV2 {
  @HiveField(0)
  String username;
  @HiveField(1)
  String email;
  @HiveField(2)
  String id;
  @HiveField(3)
  String createdAt;
  @HiveField(4)
  bool premium;
  @HiveField(5)
  String lastLoginAt;
  @HiveField(6)
  Map links;
  @HiveField(7)
  List followers;
  @HiveField(8)
  List following;
  @HiveField(9)
  String profilePhoto;
  @HiveField(10)
  String bio;
  @HiveField(11)
  bool loggedIn;
  @HiveField(12)
  List<Badge> badges;
  @HiveField(13)
  List subPrisms;
  @HiveField(14)
  int coins;
  @HiveField(15)
  List<PrismTransaction> transactions;
  @HiveField(16)
  String name;
  @HiveField(17)
  String? coverPhoto;

  PrismUsersV2({
    required this.username,
    required this.email,
    required this.id,
    required this.createdAt,
    required this.premium,
    required this.lastLoginAt,
    required this.links,
    required this.followers,
    required this.following,
    required this.profilePhoto,
    required this.bio,
    required this.loggedIn,
    required this.badges,
    required this.subPrisms,
    required this.coins,
    required this.transactions,
    required this.name,
    this.coverPhoto,
  }) {
    logger.d("Default constructor !!!!");
  }

  factory PrismUsersV2.fromJson(Map<String, dynamic> json) =>
      _$PrismUsersV2FromJson(json);
  factory PrismUsersV2.fromDocumentSnapshot(DocumentSnapshot doc, User user) =>
      PrismUsersV2(
        name: ((doc.data() as Map<String, dynamic>)["name"]  ?? user.displayName).toString(),
        username: ((doc.data() as Map<String, dynamic>)["username"] ?? user.displayName)
            .toString()
            .replaceAll(RegExp(r"(?: |[^\w\s])+"), ""),
        email: ((doc.data() as Map<String, dynamic>)["email"] ?? user.email).toString(),
        id: (doc.data() as Map<String, dynamic>)["id"].toString(),
        createdAt: (doc.data() as Map<String, dynamic>)["createdAt"].toString(),
        premium: (doc.data() as Map<String, dynamic>)["premium"] as bool,
        lastLoginAt: (doc.data() as Map<String, dynamic>)["lastLoginAt"]?.toString() ??
            DateTime.now().toUtc().toIso8601String(),
        links: (doc.data() as Map<String, dynamic>)["links"] as Map<String, dynamic> ?? {},
        followers: (doc.data() as Map<String, dynamic>)["followers"] as List ?? [],
        following: (doc.data() as Map<String, dynamic>)["following"] as List ?? [],
        profilePhoto: ((doc.data() as Map<String, dynamic>)["profilePhoto"] ?? user.photoURL).toString(),
        bio: ((doc.data() as Map<String, dynamic>)["bio"] ?? "").toString(),
        loggedIn: true,
        badges: ((doc.data() as Map<String, dynamic>)['badges'] as List<dynamic> ?? [])
            .map((e) => Badge.fromJson(e as Map<String, dynamic>))
            .toList(),
        subPrisms: (doc.data() as Map<String, dynamic>)['subPrisms'] as List<dynamic> ?? [],
        coins: (doc.data() as Map<String, dynamic>)['coins'] as int ?? 0,
        transactions: ((doc.data() as Map<String, dynamic>)['transactions'] as List<dynamic> ?? [])
            .map((e) => PrismTransaction.fromJson(e as Map<String, dynamic>))
            .toList(),
        coverPhoto: (doc.data() as Map<String, dynamic>)["coverPhoto"]?.toString(),
      );

  factory PrismUsersV2.fromDocumentSnapshotWithoutUser(DocumentSnapshot doc) =>
      PrismUsersV2(
        name: ((doc.data() as Map<String, dynamic>)["name"] ?? "").toString(),
        username: ((doc.data() as Map<String, dynamic>)["username"] ?? "")
            .toString()
            .replaceAll(RegExp(r"(?: |[^\w\s])+"), ""),
        email: ((doc.data() as Map<String, dynamic>)["email"] ?? "").toString(),
        id: (doc.data() as Map<String, dynamic>)["id"].toString(),
        createdAt: DateTime.parse((doc.data() as Map<String, dynamic>)["createdAt"] as String)
            .toUtc()
            .toIso8601String(),
        premium: (doc.data() as Map<String, dynamic>)["premium"] as bool,
        lastLoginAt: (doc.data() as Map<String, dynamic>)["lastLoginAt"]?.toString() ??
            DateTime.now().toUtc().toIso8601String(),
        links: (doc.data() as Map<String, dynamic>)["links"] as Map<String, dynamic> ?? {},
        followers: (doc.data() as Map<String, dynamic>)["followers"] as List ?? [],
        following: (doc.data() as Map<String, dynamic>)["following"] as List ?? [],
        profilePhoto: ((doc.data() as Map<String, dynamic>)["profilePhoto"] ?? "").toString(),
        bio: ((doc.data() as Map<String, dynamic>)["bio"] ?? "").toString(),
        loggedIn: true,
        badges: ((doc.data() as Map<String, dynamic>)['badges'] as List<dynamic> ?? [])
            .map((e) => Badge.fromJson(e as Map<String, dynamic>))
            .toList(),
        subPrisms: (doc.data() as Map<String, dynamic>)['subPrisms'] as List<dynamic> ?? [],
        coins: (doc.data() as Map<String, dynamic>)['coins'] as int ?? 0,
        transactions: ((doc.data() as Map<String, dynamic>)['transactions'] as List<dynamic> ?? [])
            .map((e) => PrismTransaction.fromJson(e as Map<String, dynamic>))
            .toList(),
        coverPhoto: (doc.data() as Map<String, dynamic>)["coverPhoto"]?.toString(),
      );
  Map<String, dynamic> toJson() => _$PrismUsersV2ToJson(this);
}
