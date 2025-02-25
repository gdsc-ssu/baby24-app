import 'package:hive/hive.dart';
import 'package:pickiverse_app/data/services/token_service.dart';

class TokenServiceImpl implements TokenService {
  static const _boxName = 'auth_tokens';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Box<String>? _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _checkInit();
    await Future.wait([
      _box!.put(_accessTokenKey, accessToken),
      _box!.put(_refreshTokenKey, refreshToken),
    ]);
  }

  @override
  Future<String?> getAccessToken() async {
    await _checkInit();
    return _box!.get(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    await _checkInit();
    return _box!.get(_refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _checkInit();
    await _box!.clear();
  }

  @override
  bool get hasTokens {
    if (_box == null) return false;
    final accessToken = _box!.get(_accessTokenKey);
    final refreshToken = _box!.get(_refreshTokenKey);
    return accessToken != null && refreshToken != null;
  }

  Future<void> _checkInit() async {
    if (_box == null) {
      await init();
    }
  }
}
