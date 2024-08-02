import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  final String prNo;
  final String department;

  NotificationsPage({super.key, required this.prNo, required this.department});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5062/api/notifications/all'));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          notifications =
              List<Map<String, dynamic>>.from(responseBody['\$values']);
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> _sendNotification(
      String title, String description, String message) async {
    if (widget.department != "Information Systems") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You are not authorized to send notifications.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:5062/api/notifications/send?prNo=${widget.prNo}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'description': description,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        _loadNotifications();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification sent successfully')),
        );
      } else {
        throw Exception('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending notification: $e')),
      );
    }
  }

  Future<void> _deleteNotification(int id) async {
    if (widget.department != "Information Systems") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You are not authorized to delete notifications.')),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:5062/api/notifications/delete/$id?prNo=${widget.prNo}'),
      );

      if (response.statusCode == 200) {
        _loadNotifications();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete notification');
      }
    } catch (e) {
      print('Error deleting notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting notification: $e')),
      );
    }
  }

  void _showAddNotificationDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Notification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                final message = messageController.text;

                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    message.isNotEmpty) {
                  _sendNotification(title, description, message);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: widget.department == "Information Systems"
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddNotificationDialog,
                ),
              ]
            : [],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListTile(
              title: Text(notification['title'] ?? 'No Title'),
              subtitle: Text(notification['description'] ?? 'No Description'),
              onTap: () =>
                  _showMessageDialog(notification['message'] ?? 'No Message'),
              trailing: widget.department == "Information Systems"
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteNotification(notification['id']),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
