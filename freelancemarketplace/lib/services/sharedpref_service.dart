import 'dart:html';

class SharedprefService {
  bool contains(String key) {
    return window.localStorage.containsKey(key);
  }

  void remove(String key) {
    window.localStorage.remove(key);
  }

  void setString(String key, String value) {
    window.localStorage[key] = value;
  }

  String readString(String key) {
    return window.localStorage[key].toString();
  }
}
