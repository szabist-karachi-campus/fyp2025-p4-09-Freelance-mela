import 'package:freelancemarketplace/ui/views/projectsdetils/projectsdetils_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../services/sharedpref_service.dart';
import '../../../common/apihelper/apihelper.dart';
import '../../auth/login/login_view.dart';
import '../../chat/allchat/allchat_view.dart';
import '../../chat/chatting/chatting_view.dart';

class AdminViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _sharedpref = locator<SharedprefService>();

  void logout() {
    _sharedpref.remove('email');
    _sharedpref.remove('cat');
    _sharedpref.remove("auth");
    _navigationService.clearStackAndShow(Routes.loginView);
    _navigationService.replaceWithTransition(const LoginView(),
        routeName: Routes.loginView, transitionStyle: Transition.rightToLeft);
  }

  Future<void> projectdetails(Map data) async {
    await _navigationService.navigateWithTransition(
        ProjectsdetilsView(
          details: data,
          type: "a",
        ),
        routeName: Routes.projectsdetilsView,
        transitionStyle: Transition.rightToLeft);
    notifyListeners();
  }

  Future<void> chat(String did) async {
    Map c = await ApiHelper.registerchat(_sharedpref.readString("email"), did);
    if (c['status']) {
      _navigationService.replaceWithTransition(
          ChattingView(id: c['message'], did: c['did']),
          routeName: Routes.chattingView,
          transitionStyle: Transition.rightToLeft);
    }
  }

  void allchat() {
    _navigationService.replaceWithTransition(const AllchatView(),
        routeName: Routes.allchatView, transitionStyle: Transition.rightToLeft);
  }
}

class StatusData {
  final String status;
  final int count;
  StatusData(this.status, this.count);
}

class ChartData<T> {
  final T x;
  final num y;
  ChartData(this.x, this.y);
}

class Project {
  final String id;
  final String title;
  final String des;
  final List<String> img;
  final double price;
  final bool status;

  Project({
    required this.id,
    required this.title,
    required this.des,
    required this.img,
    required this.price,
    required this.status,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      title: json['title'],
      des: json['des'],
      img: List<String>.from(json['img']),
      price: double.parse(json['price']),
      status: bool.parse(json['status']),
    );
  }
}

class Booking {
  final String id;
  final String uid;
  final String pid;
  final String ppid;
  final DateTime date;
  final bool status;
  final String tracking;

  Booking({
    required this.id,
    required this.uid,
    required this.pid,
    required this.ppid,
    required this.date,
    required this.status,
    required this.tracking,
  });

  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
        id: j['_id'] as String,
        uid: j['uid'] as String,
        pid: j['pid'] as String,
        ppid: j['ppid'] as String,
        date: DateTime.parse(j['date'] as String),
        status: bool.parse(j['status']), // ← cast directly
        tracking: j['tracking'] as String,
      );
}

Map<String, int> countByTracking(List<Booking> bs) {
  final m = <String, int>{};
  for (var b in bs) m[b.tracking] = (m[b.tracking] ?? 0) + 1;
  return m;
}

Map<String, int> countByPartner(List<Booking> bs) {
  final m = <String, int>{};
  for (var b in bs) m[b.ppid] = (m[b.ppid] ?? 0) + 1;
  return m;
}

Map<DateTime, int> countPerDay(List<Booking> bs) {
  final m = <DateTime, int>{};
  for (var b in bs) {
    final d = DateTime(b.date.year, b.date.month, b.date.day);
    m[d] = (m[d] ?? 0) + 1;
  }
  // Sort by day
  return Map.fromEntries(
      m.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
}

class User {
  final String id;
  final String number;
  final String name;
  final String img;
  final String email;
  final String pass;
  final String cat; // 'freelancer' or 'hire'
  final bool status; // true = active, false = inactive

  User({
    required this.id,
    required this.number,
    required this.name,
    required this.img,
    required this.email,
    required this.pass,
    required this.cat,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
        id: j['_id'] as String,
        number: j['number'] as String,
        name: j['name'] as String,
        img: j['img'] as String,
        email: j['email'] as String,
        pass: j['pass'] as String,
        cat: j['cat'] as String,
        status: bool.parse(j['status']),
      );
}

// Aggregation helpers:
Map<String, int> countByCategory(List<User> us) {
  final m = <String, int>{};
  for (var u in us) m[u.cat] = (m[u.cat] ?? 0) + 1;
  return m;
}

Map<String, int> countByStatus(List<User> us) {
  final m = <String, int>{};
  for (var u in us) {
    final key = u.status ? 'Active' : 'Inactive';
    m[key] = (m[key] ?? 0) + 1;
  }
  return m;
}

Map<String, Map<String, int>> countStatusWithinCategory(List<User> us) {
  // { category: { 'Active': n, 'Inactive': m } }
  final m = <String, Map<String, int>>{};
  for (var u in us) {
    m.putIfAbsent(u.cat, () => {'Active': 0, 'Inactive': 0});
    final key = u.status ? 'Active' : 'Inactive';
    m[u.cat]![key] = m[u.cat]![key]! + 1;
  }
  return m;
}

// Generic chart data
class UChartData<T> {
  final T x;
  final num y;
  UChartData(this.x, this.y);
}
