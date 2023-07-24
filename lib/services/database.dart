import 'package:firebase_database/firebase_database.dart';
import 'package:message_app/models/post.dart';

final databaseReference = FirebaseDatabase.instance.ref();

String _createdAt = '';

void updateDateTime() {
  _createdAt = DateTime.now().toLocal().toString();
  print('====> database | updateDateTime _createdAt: $_createdAt');
}
// var timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => updateDateTime());

DatabaseReference savePost(Post post) {
  updateDateTime();
  print('====> database | savePost _createdAt: $_createdAt');
  post.createdAt = _createdAt;
  var id = databaseReference.child('posts/').push();
  id
      .set(post.toJson())
      .then((_) => print(
          '====> database | savePost set ${post.toJson()} written to database'))
      .catchError((error) => print('====> database | error: $error'));
  print(
      '====> database | savePost author: ${post.author} body: ${post.body} createdAt: ${post.createdAt} liked: ${post.userLiked} uid: ${post.uid}');
  return id;
}

void updatePost(Post post, DatabaseReference id) async {
  await id.update(post.toJson());
  print('====> database | updatePost update: ${post.toJson()}');
}

void removePost(
  Post post,
  DatabaseReference id,
) async {
  await id
      .child('userLiked')
      .remove()
      .then((_) =>
          print('====> database | removePost: post ${post.toJson()} removed'))
      .catchError(
          (error) => print('====> database | removePost error: $error'));
}

void removeUserLiked(
  Post post,
  DatabaseReference id,
) async {
  await id
      .child('userLiked')
      .remove()
      .then((_) => print(
          '====> database | removeUserLiked: liked ${post.toJson()} removed'))
      .catchError(
          (error) => print('====> database | removePost error: $error'));
}

void removeUserDisLiked(
  Post post,
  DatabaseReference id,
) async {
  await id
      .child('userDisLiked')
      .remove()
      .then((_) => print(
          '====> database | removeUserDisLiked: disliked ${post.toJson()} removed'))
      .catchError(
          (error) => print('====> database | removePost error: $error'));
}

Future<List<Post>> getAllPosts() async {
  DataSnapshot dataSnapshot =
      (await databaseReference.child('posts/').once()).snapshot;
  print('====> database | dataSnapshot.value: ${dataSnapshot.value}');

  List<Post> posts = [];
  if (dataSnapshot.value != null) {
    (dataSnapshot.value as Map<Object?, Object?>).forEach((key, value) {
      print('====> database | getAllPosts value: $value}');
      Post post = createPost(value);
      print('====> database | getAllPosts post: $post}');
      post.setId(databaseReference.child('posts/$key'));
      posts.add(post);
    });
  }

  print('====> database | getAllPosts posts: $posts}');
  return posts;
}
