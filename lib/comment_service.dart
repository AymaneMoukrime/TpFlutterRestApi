import 'dart:convert';
import 'package:http/http.dart' as http;
import 'comments.dart';

class CommentService {
  Future<List<Comment>> fetchComments() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    if (response.statusCode == 200) {
      List<dynamic> jsonComments = json.decode(response.body);
      return jsonComments.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Comment> createComment(Comment comment) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/comments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(comment.toJson()),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<void> updateComment(Comment comment) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/comments/${comment.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(comment.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update comment');
    }
  }

  Future<void> deleteComment(int id) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/comments/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }
  }
}
