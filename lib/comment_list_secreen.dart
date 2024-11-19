import 'package:flutter/material.dart';
import 'comments.dart';
import 'comment_service.dart';
import 'comment_detail_seceen.dart';

class CommentListScreen extends StatefulWidget {
  @override
  _CommentListScreenState createState() => _CommentListScreenState();
}

class _CommentListScreenState extends State<CommentListScreen> {
  final CommentService _commentService = CommentService();
  late Future<List<Comment>> _comments;

  @override
  void initState() {
    super.initState();
    _refreshComments();
  }

  void _refreshComments() {
    setState(() {
      _comments = _commentService.fetchComments();
    });
  }

  Future<void> _showCommentDialog({Comment? comment}) async {
    final nameController = TextEditingController(text: comment?.name ?? '');
    final emailController = TextEditingController(text: comment?.email ?? '');
    final bodyController = TextEditingController(text: comment?.body ?? '');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(comment == null ? 'Add New Comment' : 'Edit Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(comment == null ? 'Add' : 'Update'),
              onPressed: () async {
                final name = nameController.text;
                final email = emailController.text;
                final body = bodyController.text;
                if (name.isNotEmpty && email.isNotEmpty && body.isNotEmpty) {
                  if (comment == null) {
                    await _commentService.createComment(Comment(postId: 1, id: 0, name: name, email: email, body: body));
                  } else {
                    await _commentService.updateComment(Comment(postId: comment.postId, id: comment.id, name: name, email: email, body: body));
                  }
                  _refreshComments();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteComment(int id) async {
    await _commentService.deleteComment(id);
    _refreshComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCommentDialog(),
          ),
        ],
      ),
      body: FutureBuilder<List<Comment>>(
        future: _comments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(comment.name),
                  subtitle: Text(comment.body),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentDetailScreen(comment: comment),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showCommentDialog(comment: comment),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteComment(comment.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
