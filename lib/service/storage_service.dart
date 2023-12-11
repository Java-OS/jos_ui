import 'dart:html';

class StorageService {
  static final Storage _localStorage = window.localStorage;

  static void addItem(String key,String value) {
    _localStorage[key] = value;
  }

  static void removeItem(String key) {
    _localStorage.remove(key);
  }

  static String? getItem(String key) {
    return _localStorage[key];
  }

  static bool exists(String key) {
    return _localStorage.containsKey(key);
  }
}