import '/libraries/custom_packages.dart';
import '/app/data/token_data.dart';
import '/app/core/base_repository.dart';

class TokenRepository extends BaseRepository<TokenData> {
  TokenRepository._internal();
  static final TokenRepository _instance = TokenRepository._internal();
  factory TokenRepository() => _instance;

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  @override
  Future<void> save(TokenData tokens) async {
    await _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
  }

  @override
  Future<TokenData> get() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey) ?? '';
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey) ?? '';
    return TokenData(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> clear() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}