import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart';
import 'package:repo_viewer/auth/infrastructure/credentials_storage/credentials_storage.dart';

class SecureCredentialsStorage implements CredentialsStorage {
  final FlutterSecureStorage _storage;

  SecureCredentialsStorage(this._storage);

  static const _key = 'oauth2_credentials';

  Credentials? _cachedCredentails;

  @override
  Future<Credentials?> read() async {
    if (_cachedCredentails != null) return _cachedCredentails;
    final json = await _storage.read(key: _key);
    if (json == null) return null;
    try {
      return _cachedCredentails = Credentials.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> save(Credentials credentials) async {
    _cachedCredentails = credentials;
    return _storage.write(key: _key, value: credentials.toJson());
  }

  @override
  Future<void> clear() async {
    _cachedCredentails = null;
    return _storage.delete(key: _key);
  }
}
