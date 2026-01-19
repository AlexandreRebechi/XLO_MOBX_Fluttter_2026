import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xlo_mobx/models/chat_room.dart';
import 'package:xlo_mobx/models/messages.dart';
import 'package:xlo_mobx/models/user.dart';

class MessageRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot>? _subscription;

  /// Query base
  Query getQuery(String chatRoomId) {
    return firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('dateSend', descending: true);
  }

  /// Lista de mensagens
  Future<List<Message>> getMessagesList(ChatRoom chatRoom) async {
    try {
      final snapshot = await getQuery(chatRoom.id!).get();

      return snapshot.docs.map((doc) => Message.fromFirebase(doc)).toList();
    } catch (e) {
      return Future.error('Falha ao recuperar lista de mensagens');
    }
  }

  /// Listener em tempo real (nova mensagem)
  Future<void> liveMessageList({
    required ChatRoom chatRoom,
    required Function(Message) onNewMessage,
  }) async {
    _subscription = getQuery(chatRoom.id!).snapshots().listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          onNewMessage(Message.fromFirebase(change.doc));
        }
      }
    });
  }

  /// Salvar mensagem
  Future<Message> saveMessage({
    required ChatRoom chatRoom,
    required String textMessage,
    required List<User?> users,
    required User destination,
  }) async {
    try {
      final docRef = await firestore.collection('messages').add({
        'chatRoomId': chatRoom.id,
        'text': textMessage,
        'destinationId': destination.id,
        'users': users.map((u) => u!.id).toList(),
        'dateSend': FieldValue.serverTimestamp(),
      });

      final doc = await docRef.get();
      return Message.fromFirebase(doc);
    } catch (e) {
      return Future.error('Falha ao enviar a mensagem');
    }
  }

  /// Cancelar listener
  void cancelLiveQuery() {
    _subscription?.cancel();
    _subscription = null;
  }
}
