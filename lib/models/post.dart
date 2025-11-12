import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
    final String postUrl;
  final String profileImage;
  final likes;

  const Post({required this.description, required this.postId, required this.datePublished, required this.postUrl, required this.profileImage, required this.likes,
    required this.username,
    required this.uid,

  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profileImage': profileImage,
        'likes': likes,
        'username': username,
        'uid': uid,
  };


  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
      username: snapshot['username'],
      uid: snapshot['uid'],
    );
  }
}
