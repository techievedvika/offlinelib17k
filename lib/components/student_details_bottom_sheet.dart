import 'package:flutter/material.dart';
import 'package:lib17000ft/models/student_registration/student_model.dart';

import 'custom_button.dart';

/// Shows a modal bottom sheet with details for the given [student].
void showStudentDetailsBottomSheet(BuildContext context, StudentModel student) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Student Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      _getInitials(student.name),
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Name + ID
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Student ID: ${student.rollNo}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'APAAR ID: ${student.apaarId ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        CustomButton(
                          onPressedButton: (){
                            Navigator.pushNamed(
                              context,
                              '/student_edit',
                              arguments: student,
                            );
                          },
                          title: 'Edit',
                          icon: Icons.edit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info Grid
            Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                _infoCard(context, Icons.class_, "Class", student.classs),
                _infoCard(context, Icons.wc, "Gender", student.gender),
                _infoCard(context, Icons.school, "School", student.school ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

/// A private helper widget to display a piece of student information.
Widget _infoCard(BuildContext context, IconData icon, String label, String value) {
  return Container(
    width: (MediaQuery.of(context).size.width / 2) - 36,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSecondaryContainer),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[700],
                  )),
              Text(value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A private helper to get initials from a name string.
String _getInitials(String name) {
  final nameParts = name.trim().split(' ');
  if (nameParts.isEmpty || nameParts.first.isEmpty) return '?';
  if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
  return '${nameParts[0][0]}${nameParts.last[0]}'.toUpperCase();
}
