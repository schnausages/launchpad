import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:launchpad/models/post.dart';
import 'package:launchpad/services/fs_services.dart';

class FeedService with ChangeNotifier {
  List<PostModel> _homeFeedPosts = [];
  List<PostModel> get feedPosts => _homeFeedPosts;
  bool _hasError = false;
  bool _loading = false;
  bool get hasError => _hasError;
  Future refreshFp() async {
    _homeFeedPosts.clear();

    await fetchHomeFeedPosts();
  }

  Future fetchHomeFeedPosts() async {
    print("PURT TRUING ETCH");
    if (!_loading) {
      if (_homeFeedPosts.isEmpty) {
        _loading = true;
        _homeFeedPosts.clear();
        List<PostModel> newPosts = await FirestoreServices.getMostRecentPosts();
        _homeFeedPosts.addAll(newPosts);

        notifyListeners();
        _loading = false;
      } else {
        _loading = true;
        List<PostModel> _next10Posts = await FirestoreServices.getNext10Posts(
            _homeFeedPosts.last.documentSnapshot!);
        if (_next10Posts.isNotEmpty) {
          _next10Posts.forEach((doc) {
            _homeFeedPosts.add(doc);
          });
        }

        notifyListeners();
        _loading = false;
      }
    }
  }

  loadFirst10Posts() async {
    _homeFeedPosts = await FirestoreServices.getMostRecentPosts();
    notifyListeners();
  }

  loadNextPosts(DocumentSnapshot lastDoc) async {
    print("PURT LOADING NEXT");
    List<PostModel> _nextPostsToInsert = [];
    _nextPostsToInsert = await FirestoreServices.getNext10Posts(lastDoc);

    _homeFeedPosts.addAll(_nextPostsToInsert);
    notifyListeners();
  }

  // FirestoreServices.getCommentsOnApplication(
  //       appId: widget.app.launchpadAppId)
  loadAppPosts(String appId) async {
    _homeFeedPosts =
        await FirestoreServices.getCommentsOnApplication(appId: appId);
    notifyListeners();
  }

  addPost(PostModel post) {
    _homeFeedPosts.add(post);
    _homeFeedPosts.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    notifyListeners();
  }

  removePost(PostModel post) {
    _homeFeedPosts.remove(post);
    notifyListeners();
  }

  clearFeed() {
    _homeFeedPosts.clear();
    notifyListeners();
  }
}
