import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/models/post.dart';
import 'package:uuid/uuid.dart';

import 'storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    String uid,
    Uint8List file,
    String username,
    String profileImage,
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        'posts',
        file,
        true,
      );
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
        username: username,
        uid: uid,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
    // Add Firestore related methods here in the future
  }

  Future<void> likePosts(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
              'profilePic': profilePic,
              'name': name,
              'uid': uid,
              'text': text,
              'commentId': commentId,
              'datePublished': DateTime.now(),
            });
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future <void> deletePost (String postId) async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }
}
