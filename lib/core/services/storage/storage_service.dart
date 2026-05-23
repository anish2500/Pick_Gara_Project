import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/providers/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

class StorageService {
  final SharedPreferences _prefs;

  StorageService({required SharedPreferences sharedPreferences})
    : _prefs = sharedPreferences;

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();
  bool containsKey(String key) => _prefs.containsKey(key);
}
