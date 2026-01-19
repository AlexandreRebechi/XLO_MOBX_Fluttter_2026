import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';

class Message {
  String? id;
  String? chatRoomId;
  String? text;
  String? destinationId;
  DateTime? sendDate;

  Message({
    required this.id,
    required this.chatRoomId,
    required this.text,
    required this.destinationId,
    required this.sendDate, DateTime? dateSend,
  });

  factory Message.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Message(
      id: doc.id,
      chatRoomId: data['chatRoomId'],
      text: data['text'],
      destinationId: data['destinationId'],
      dateSend: data['dateSend'] != null
          ? (data['dateSend'] as Timestamp).toDate()
          : null, sendDate: null,
    );
  }
}
