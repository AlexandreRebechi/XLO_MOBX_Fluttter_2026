import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/models/user.dart';

class ChatRoom {
  final String? id;
  final Ad? adId;
  final List<User?> users;
  final DateTime? lastMessageDate;

  ChatRoom({
    required this.id,
    required this.adId,
    required this.users,
    this.lastMessageDate,
  });

  factory ChatRoom.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatRoom(
      id: doc.id,
      adId: data['adId'],
      users: List<User>.from(data['users']),
      lastMessageDate: data['lastMessageDate'] != null
          ? (data['lastMessageDate'] as Timestamp).toDate()
          : null,
    );
  }
}
