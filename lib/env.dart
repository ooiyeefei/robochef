// ignore_for_file: prefer_const_declarations

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'FIREBASE_WEBAPP_API_KEY', obfuscate: true)
  static final String firebaseWebAppApiKey = _Env.firebaseWebAppApiKey;
  @EnviedField(varName: 'AGW_URL', obfuscate: true)
  static final String agwUrl = _Env.agwUrl;
  // @EnviedField(varName: 'KEY2')
  // static const String key2 = _Env.key2;
  // @EnviedField()
  // static const String key3 = _Env.key3;
}
