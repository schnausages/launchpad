import 'package:flutter/material.dart';
import 'package:launchpad/models/post.dart';
import 'package:launchpad/services/fs_services.dart';

class AppCommentsService with ChangeNotifier {
  List<PostModel> _appPosts = [];
  List<PostModel> get appPosts => _appPosts;

  loadAppPosts(String appId) async {
    _appPosts = await FirestoreServices.getCommentsOnApplication(appId: appId);
    notifyListeners();
  }

  addPost(PostModel post) {
    _appPosts.add(post);
    _appPosts.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    notifyListeners();
  }

  removePost(PostModel post) {
    _appPosts.remove(post);
    notifyListeners();
  }

  clearFeed() {
    _appPosts.clear();
    // notifyListeners();
  }
}
