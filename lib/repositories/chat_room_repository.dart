import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/foundation.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/models/chat_room.dart';
import 'package:xlo_mobx/models/user.dart';

class ChatRoomRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _subscription;

  /// Query base
  Query getQuery(User user) {
    return firestore
        .collection('chat_xlo_mobx_flutter')
        .where('users_xlo_mobx_flutter', arrayContains: user.id)
        .orderBy('lastMessageDate', descending: true);
  }

  /// Lista de salas
  Future<List<ChatRoom>> getChatRoomList(User user) async {
    try {
      final snapshot = await getQuery(user).get();

      return snapshot.docs.map((doc) => ChatRoom.fromFirebase(doc)).toList();
    } catch (e) {
      return Future.error('Falha ao recuperar lista de salas de chat');
    }
  }

  /// Sala por ID
  Future<ChatRoom?> getChatRoomById(String id) async {
    try {
      final doc = await firestore
          .collection('chat_xlo_mobx_flutter')
          .doc(id)
          .get();

      if (!doc.exists) return null;

      return ChatRoom.fromFirebase(doc);
    } catch (e) {
      return Future.error('Falha ao recuperar sala de chat');
    }
  }

  /// Listener em tempo real
  Future<void> liveChatRoomList({
    required User user,
    required VoidCallback onChange,
  }) async {
    _subscription = getQuery(user).snapshots().listen((_) {
      onChange();
    });
  }

  /// Criar sala
  Future<ChatRoom> createChatRoom({
    required Ad ad,
    required List<User?> users,
  }) async {
    try {
      final usersIds = users.map((u) => u!.id).toList();

      final docRef = await firestore.collection('chat_xlo_mobx_flutter').add({
        'users_xlo_mobx_flutter': usersIds,
        'adId': ad,
        'lastMessage': null,
        'lastMessageDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return await getChatRoomById(docRef.id) as ChatRoom;
    } catch (e) {
      return Future.error('Falha ao criar sala de bate-papo');
    }
  }

  /// Excluir sala
  Future<void> deleteChatRoom(ChatRoom chatRoom) async {
    try {
      await firestore
          .collection('chat_xlo_mobx_flutter')
          .doc(chatRoom.id)
          .delete();
    } catch (e) {
      return Future.error('Falha ao excluir sala de bate-papo');
    }
  }

  /// Cancelar listener
  void cancelLiveQuery() {
    _subscription?.cancel();
    _subscription = null;
  }
}
