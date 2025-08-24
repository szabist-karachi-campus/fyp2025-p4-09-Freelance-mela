// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../customwidget/snakbar_helper.dart';

const url = 'http://10.0.2.2:3000/';
const registrationlink = "${url}register";
const updatelink = "${url}update";
const loginlink = "${url}login";
const findonelink = "${url}findone";
const alluserslink = "${url}allusers";
const statususerchangelink = "${url}statususerchange";

// event
const registerprojectlink = "${url}registerproject";
const allprojectlink = "${url}allproject";
const statuschangelink = "${url}statuschange";
const deleteprojectlink = "${url}deleteproject";
const updateprojectlink = "${url}updateproject";

// chat
const registerchatlink = "${url}registerchat";
const allchatbyidlink = "${url}allchatbyid";
const addchatlink = "${url}addchat";
const allchatbydidlink = "${url}allchatbydid";

// faqs
const allfaqslink = "${url}allfaqs";
const registerfaqslink = "${url}registerfaqs";

// complains
const allcomplainslink = "${url}allcomplains";
const registercomplainslink = "${url}registercomplains";

// video
const allvideolink = "${url}allvideo";
const registervideolink = "${url}registervideo";

class ApiHelper {
  static Future<bool> registration(String name, String number, String email,
      String pass, String cat, String img, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(registrationlink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "number": number,
            "email": email,
            "img": img,
            "pass": pass,
            "cat": cat,
            "status": cat != "freelancer" ? "true" : "false"
          }));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      show_snackbar(context, data['message']);
      return data['status'] as bool;
    } catch (e) {
      print(e);
      show_snackbar(context, 'try again later');
      return false;
    }
  }

  static Future<bool> update(String id, String name, String number, String img,
      BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(updatelink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "id": id,
            "name": name,
            "number": number,
            "img": img,
          }));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['status'] as bool;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> statususerchange(String id, String status) async {
    try {
      var response = await http.post(Uri.parse(statususerchangelink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"id": id, "status": status}));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['status'];
    } catch (e) {
      return false;
    }
  }

  static Future<Map> login(
      String email, String pass, String deviceid, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(loginlink),
          headers: {"Content-Type": "application/json"},
          body:
              jsonEncode({"email": email, "pass": pass, "deviceid": deviceid}));
      var data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (data['status']) {
        return data['token'];
      } else {
        show_snackbar(context, data['message']);
        return {};
      }
    } catch (e) {
      show_snackbar(context, 'try again later');
      return {};
    }
  }

  static Future<Map> findone(String number) async {
    try {
      var response = await http.post(Uri.parse(findonelink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": number}));
      var data = jsonDecode(utf8.decode(response.bodyBytes))['data'] as Map;
      return data;
    } catch (e) {
      return {};
    }
  }

  static Future<List> allusers() async {
    try {
      var response = await http.post(Uri.parse(alluserslink),
          headers: {"Content-Type": "application/json"});
      var data = jsonDecode(utf8.decode(response.bodyBytes))['data'];
      return data;
    } catch (e) {
      return [];
    }
  }

  // event
  static Future<bool> registerproject(String title, String des, List img,
      String price, String uid, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(registerprojectlink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "title": title,
            "des": des,
            "img": img,
            "price": price,
            "status": "false",
            "uid": uid
          }));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      show_snackbar(context, data['message']);
      return data['status'] as bool;
    } catch (e) {
      show_snackbar(context, 'try again later');
      return false;
    }
  }

  static Future<List> allproject() async {
    try {
      var response = await http.post(Uri.parse(allprojectlink),
          headers: {"Content-Type": "application/json"});
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['data'];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> statuschange(String id) async {
    try {
      var response = await http.post(Uri.parse(statuschangelink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"id": id, "status": "true"}));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['status'];
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteproject(String id) async {
    try {
      var response = await http.post(Uri.parse(deleteprojectlink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"id": id}));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['status'];
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateproject(String id, String title, String des,
      List img, String price, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(updateprojectlink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "id": id,
            "title": title,
            "des": des,
            "img": img,
            "price": price,
          }));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      show_snackbar(context, data['message']);
      return data['status'] as bool;
    } catch (e) {
      return false;
    }
  }

  // chat
  static Future<Map> registerchat(String uid, String did) async {
    try {
      var response = await http.post(Uri.parse(registerchatlink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "uid": uid,
            "did": did,
            "c": [],
            "date": DateTime.now().toString(),
          }));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } catch (e) {
      return {};
    }
  }

  static Future<Map> allchatbyid(String id) async {
    try {
      var response = await http.post(Uri.parse(allchatbyidlink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"id": id}));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['data'];
    } catch (e) {
      return {};
    }
  }

  static Future<List> allchatbydid(String did) async {
    try {
      var response = await http.post(Uri.parse(allchatbydidlink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"did": did}));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['data'];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addchat(String id, Map dataa, String sendto) async {
    try {
      var response = await http.post(Uri.parse(addchatlink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"id": id, "data": dataa}));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      // Map d = await findone(sendto);
      // await FirebaseHelper.sendPushMessage(
      //     d['deviceid'], "New Message", dataa['mess']);
      return data['status'] as bool;
    } catch (e) {
      return false;
    }
  }

  // faqs
  static Future<List> allfaqs(BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(allfaqslink),
          headers: {"Content-Type": "application/json"});
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['data'] as List;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> registerfaqs(
      String title, String ans, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(registerfaqslink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "title": title,
            "ans": ans,
          }));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['status'] as bool;
    } catch (e) {
      return false;
    }
  }

  // complains
  static Future<List> allcomplains(BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(allcomplainslink),
          headers: {"Content-Type": "application/json"});
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['data'] as List;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> registercomplains(
      String uid, String title, String ans, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(registercomplainslink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "uid": uid,
            "title": title,
            "ans": ans,
          }));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['status'] as bool;
    } catch (e) {
      return false;
    }
  }

  // video
  static Future<List> allvideo(BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(allvideolink),
          headers: {"Content-Type": "application/json"});
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['data'] as List;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> registervideo(
      String uid, String tid, String date, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(registervideolink),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "uid": uid,
            "tid": tid,
            "date": date,
          }));
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['status'] as bool;
    } catch (e) {
      return false;
    }
  }
}
