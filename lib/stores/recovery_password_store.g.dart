// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_password_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RecoveryPasswordStore on _RecoveryPasswordStore, Store {
  Computed<bool>? _$emailValidComputed;

  @override
  bool get emailValid => (_$emailValidComputed ??= Computed<bool>(
    () => super.emailValid,
    name: '_RecoveryPasswordStore.emailValid',
  )).value;
  Computed<Function?>? _$recoverPressedComputed;

  @override
  Function? get recoverPressed =>
      (_$recoverPressedComputed ??= Computed<Function?>(
        () => super.recoverPressed,
        name: '_RecoveryPasswordStore.recoverPressed',
      )).value;

  late final _$emailAtom = Atom(
    name: '_RecoveryPasswordStore.email',
    context: context,
  );

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$successAtom = Atom(
    name: '_RecoveryPasswordStore.success',
    context: context,
  );

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$loadingAtom = Atom(
    name: '_RecoveryPasswordStore.loading',
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

  late final _$errorAtom = Atom(
    name: '_RecoveryPasswordStore.error',
    context: context,
  );

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

  late final _$_RecoveryPasswordStoreActionController = ActionController(
    name: '_RecoveryPasswordStore',
    context: context,
  );

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_RecoveryPasswordStoreActionController.startAction(
      name: '_RecoveryPasswordStore.setEmail',
    );
    try {
      return super.setEmail(value);
    } finally {
      _$_RecoveryPasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSuccess(bool value) {
    final _$actionInfo = _$_RecoveryPasswordStoreActionController.startAction(
      name: '_RecoveryPasswordStore.setSuccess',
    );
    try {
      return super.setSuccess(value);
    } finally {
      _$_RecoveryPasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_RecoveryPasswordStoreActionController.startAction(
      name: '_RecoveryPasswordStore.setLoading',
    );
    try {
      return super.setLoading(value);
    } finally {
      _$_RecoveryPasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String value) {
    final _$actionInfo = _$_RecoveryPasswordStoreActionController.startAction(
      name: '_RecoveryPasswordStore.setError',
    );
    try {
      return super.setError(value);
    } finally {
      _$_RecoveryPasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
success: ${success},
loading: ${loading},
error: ${error},
emailValid: ${emailValid},
recoverPressed: ${recoverPressed}
    ''';
  }
}
