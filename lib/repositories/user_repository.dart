import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/facebook_repository.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';

class UserRepository {
  Future<User> signUp(User user) async {
    final parseUser = ParseUser(user.email, user.password, user.email);

    parseUser.set<String?>(keyUserName, user.name);
    parseUser.set<String?>(keyUserPhone, user.phone);
    parseUser.set(keyUserType, user.type.index);

    final response = await parseUser.signUp();

    if (response.success) {
      return mapParseToUser(response.result);
    } else {
      return Future.error(
        ParseErrors.getDescription(response.error!.code) as Object,
      );
    }
  }

  Future<User> loginWithEmail(String? email, String? password) async {
    final parseUser = ParseUser(email, password, null);

    final response = await parseUser.login();

    if (response.success) {
      return mapParseToUser(response.result);
    } else {
      return Future.error(
        ParseErrors.getDescription(response.error!.code) as Object,
      );
    }
  }

  Future<User?> currentUser() async {
    final parseUser = await ParseUser.currentUser();
    if (parseUser != null) {
      final response = await ParseUser.getCurrentUserFromServer(
        parseUser.sessionToken,
      );
      if (response!.success) {
        return mapParseToUser(response.result);
      } else {
        await parseUser.logout();
      }
    }
    return null;
  }

  Future<void> save(User user) async {
    final ParseUser parseUser = await ParseUser.currentUser() as ParseUser;

    if (parseUser != null) {
      parseUser.set<String>(keyUserName, user.name!);
      parseUser.set<String>(keyUserPhone, user.phone!);
      parseUser.set<int>(keyUserType, user.type.index);

      if (user.password != null) {
        parseUser.password = user.password!;
      }

      final response = await parseUser.save();

      if (!response.success) {
        return Future.error(ParseErrors.getDescription(response.error!.code)!);
      }
      if (user.password != null) {
        await parseUser.logout();
        try {
          final loginResponse = await loginWithEmail(user.email, user.password);
        } catch (e) {
          return Future.error(e);
        }
      }
    }
  }

  Future<void> logout() async {
    final ParseUser currentUser = await ParseUser.createUser();
    await currentUser.logout();
  }

  User mapParseToUser(ParseUser parseUser) {
    final int userTypeIndex =
        parseUser.get<int>(keyUserType) ?? UserType.PARTICULAR.index;

    return User(
      id: parseUser.objectId,
      name: parseUser.get(keyUserName),
      email: parseUser.get(keyUserEmail),
      phone: parseUser.get(keyUserPhone),
      type: UserType.values[userTypeIndex],
      createdAt: parseUser.get(keyUserCreatedAt),
    );
  }

  Future<void> recoverPassword(String email) async {
    final ParseUser user = ParseUser(email.toLowerCase(), '', email);
    final ParseResponse parseResponse = await user.requestPasswordReset();
    if (!parseResponse.success) {
      return Future.error(
        ParseErrors.getDescription(parseResponse.error!.code)!,
      );
    }
    Future<User> loginWithFacebook() async {
      try {
        final Map<String, dynamic>? authData = await FacebookRepository()
            .login();

        ParseResponse parseResponse = await ParseUser.loginWith(
          'facebook',
          authData!,
        );

        if (parseResponse.success) {
          final ParseUser parseUser = parseResponse.results!.first as ParseUser;

          if (authData.containsKey(keyUserEmail)) {
            parseUser.emailAddress = authData[keyUserEmail];
          }

          if (authData.containsKey(keyUserName)) {
            parseUser.set<String>(keyUserName, authData[keyUserName]);
          }

          parseUser.set<int>(keyUserType, UserType.PARTICULAR.index);

          parseResponse = await parseUser.save();

          if (parseResponse.success) {
            return mapParseToUser(parseUser);
          } else {
            return Future.error(
              ParseErrors.getDescription(parseResponse.error!.code)!,
            );
          }
        } else {
          return Future.error(
            ParseErrors.getDescription(parseResponse.error!.code)!,
          );
        }
      } catch (e) {
        return Future.error(e);
      }
    }
  }
}
