class TokenData {
  String accessToken;
  String refreshToken;

  TokenData({required this.accessToken, required this.refreshToken});

  factory TokenData.fromMap(Map<String, String> map) {
    return TokenData(
      accessToken: map['access'] ?? '',
      refreshToken: map['refresh'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
    };
  }
}