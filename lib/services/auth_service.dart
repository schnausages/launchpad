import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //bool isAuth = false;
  String? _token;
  Map<String, dynamic>? userInformation;
  bool? isContentPartner;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    //if expire date isnt null and its after now...return a token
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    Map<String, dynamic> _data = {};
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final res = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user!;

    QuerySnapshot fs = await firestore
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .get();

    _data = fs.docs.first.data() as Map<String, dynamic>;
    _data.remove('date_joined');
    _data.remove('last_active');
    _data.remove('last_username_change');
    // UserModel _u = UserModel.fromJson(_data);

    _token = user.uid;
    final prefs = await SharedPreferences.getInstance();
    String prefsMap = json.encode(_data);
    prefs.setString('cached_profile', prefsMap);

    notifyListeners();

    //return user;
  }

  Future<QueryDocumentSnapshot> createLaunchpadUser(
      String userID, String email, String username) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('users').add({
        'email': email,
        'date_joined': DateTime.now(),
        'dev_bits': 0,
        'id': userID,
        'pfp_url': 'nopfp.jpg',
        'username': username,
        'last_active': DateTime.now(),
        'last_username_change': DateTime.now().subtract(Duration(days: 65)),
      });
    } catch (e) {}

    QuerySnapshot userInfo = await firestore
        .collection('users')
        .where('id', isEqualTo: userID)
        .get();
    return userInfo.docs.first;
  }

  Future<User> signUpWithEmail(
      {required String email,
      required String password,
      required String username}) async {
    UserCredential res = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user!;
    // await user.sendEmailVerification();
    _token = user.uid;
    notifyListeners();
    Map<String, dynamic> _data = {};

    await createLaunchpadUser(user.uid, user.email!, username).then((value) {
      _data = value.data() as Map<String, dynamic>;
    });

    final prefs = await SharedPreferences.getInstance();
    // _data['token'] = _token;
    try {
      _data.remove('date_joined');
      _data.remove('last_active');
      _data.remove('last_username_change');
    } catch (e) {}
    String prefsMap = json.encode(_data);
    prefs.setString('cached_profile', prefsMap);

    return user;
  }

  Future<void> tryAutoLogin() async {
    final frontpagePrefs = await SharedPreferences.getInstance();
    if (!frontpagePrefs.containsKey('cached_profile')) {
      return;
    }
    final extractedData =
        json.decode(frontpagePrefs.getString('cached_profile')!)
            as Map<String, dynamic>;
    UserModel _profData =
        await FirestoreServices.fetchUserInfo(extractedData['id']);
    Map<String, dynamic> _m = UserModel.toJson(_profData);
    _m.remove('date_joined');
    _m.remove('last_active');
    _m.remove('last_username_change');

    String _profileData = json.encode(_m);
    frontpagePrefs.setString('cached_profile', _profileData);

    _token = DateTime.now().second.toString();

    if (_token == null) {
      return;
    }

    notifyListeners();
    return;
  }

  Future<void> logOut() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    firebaseAuth.signOut();
    await prefs.clear();
    // Navigator.popUntil(context, ModalRoute.withName('/'));

    notifyListeners();
  }
}
