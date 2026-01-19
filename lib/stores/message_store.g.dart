// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MessageStore on _MessageStore, Store {
  Computed<List<User?>>? _$usersComputed;

  @override
  List<User?> get users => (_$usersComputed ??= Computed<List<User?>>(
    () => super.users,
    name: '_MessageStore.users',
  )).value;

  late final _$loadingAtom = Atom(
    name: '_MessageStore.loading',
    context: context,
  );

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$errorAtom = Atom(name: '_MessageStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$messageListAtom = Atom(
    name: '_MessageStore.messageList',
    context: context,
  );

  @override
  ObservableList<Message> get messageList {
    _$messageListAtom.reportRead();
    return super.messageList;
  }

  @override
  set messageList(ObservableList<Message> value) {
    _$messageListAtom.reportWrite(value, super.messageList, () {
      super.messageList = value;
    });
  }

  late final _$getMessagesListAsyncAction = AsyncAction(
    '_MessageStore.getMessagesList',
    context: context,
  );

  @override
  Future getMessagesList() {
    return _$getMessagesListAsyncAction.run(() => super.getMessagesList());
  }

  late final _$liveMessageListAsyncAction = AsyncAction(
    '_MessageStore.liveMessageList',
    context: context,
  );

  @override
  Future liveMessageList() {
    return _$liveMessageListAsyncAction.run(() => super.liveMessageList());
  }

  late final _$sendMessageAsyncAction = AsyncAction(
    '_MessageStore.sendMessage',
    context: context,
  );

  @override
  Future sendMessage(String message) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(message));
  }

  late final _$_MessageStoreActionController = ActionController(
    name: '_MessageStore',
    context: context,
  );

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_MessageStoreActionController.startAction(
      name: '_MessageStore.setLoading',
    );
    try {
      return super.setLoading(value);
    } finally {
      _$_MessageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String value) {
    final _$actionInfo = _$_MessageStoreActionController.startAction(
      name: '_MessageStore.setError',
    );
    try {
      return super.setError(value);
    } finally {
      _$_MessageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
messageList: ${messageList},
users: ${users}
    ''';
  }
}
