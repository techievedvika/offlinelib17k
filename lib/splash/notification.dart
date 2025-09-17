import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lib17000ft/components/custom_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> notifications = [];
  String filterType = "All";

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final all = prefs.getStringList('notifications') ?? [];

    setState(() {
      notifications = filterType == "All"
          ? all
          : all.where((n) => n.startsWith(filterType)).toList();
    });
  }

  Future<void> _deleteNotification(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final all = prefs.getStringList('notifications') ?? [];
    final actualIndex = all.indexOf(notifications[index]);
    if (actualIndex >= 0) {
      all.removeAt(actualIndex);
      await prefs.setStringList('notifications', all);
    }
    await _loadNotifications();
  }

  Future<void> _clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    setState(() => notifications = []);
  }

  String _formatDate(String iso) {
    final dateTime = DateTime.tryParse(iso);
    if (dateTime == null) return '';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Notifications',
        backbutton: true,
        clearButton: true,
       onClear : 
          notifications.isEmpty
              ? null
              : () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Clear All?"),
                      content: const Text("Are you sure you want to delete all notifications?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes")),
                      ],
                    ),
                  );
                  if (confirm == true) await _clearAllNotifications();
                },
        
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          //   child: DropdownButtonFormField<String>(
          //     value: filterType,
          //     items: const [
          //       DropdownMenuItem(value: "All", child: Text("All")),
          //       DropdownMenuItem(value: "Reminder", child: Text("Reminders")),
          //       DropdownMenuItem(value: "Alert", child: Text("Alerts")),
          //       DropdownMenuItem(value: "Info", child: Text("Info")),
          //     ],
          //     onChanged: (value) {
          //       filterType = value!;
          //       _loadNotifications();
          //     },
          //     decoration: const InputDecoration(
          //       labelText: "Filter",
          //       border: OutlineInputBorder(),
          //     ),
          //   ),
          // ),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text(" No notifications", style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final parts = notifications[index].split('|');
                      final title = parts[0];
                      final body = parts[1];
                      final time = parts.length > 2 ? _formatDate(parts[2]) : '';

                      return Dismissible(
                        key: Key(notifications[index]),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteNotification(index),
                        child: Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Future: Show details or go to screen
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: theme.primaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.notifications, color: Colors.white),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(title,
                                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 4),
                                          Text(body,
                                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 6),
                                          Text(time,
                                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
