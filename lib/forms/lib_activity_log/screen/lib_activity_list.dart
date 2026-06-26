import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/circular_indicator.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_drawer.dart';
import '../../../configs/color/color.dart';
import '../../dashboard/dash_cubit.dart';
import '../../dashboard/dash_state.dart';

class LibActivityList extends StatefulWidget {
  const LibActivityList({super.key});

  @override
  State<LibActivityList> createState() => _LibActivityListState();
}

class _LibActivityListState extends State<LibActivityList> {

  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // void _loadUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getString('userId');
  //   print("This is the user ID : $userId");
  // }
  // 1. Update _loadUser to trigger a rebuild
  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
    print("This is the user ID : $userId");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Lib Activity Form List',
        backbutton: true,
      ),
      body: SafeArea(
        child: BlocConsumer<DashCubit, DashState>(
          listener: (context, state) {

          },
          builder: (context, state) {
            if (state is DashLoading) {
              return const Center(
                child: TextWithCircularProgress(
                  text: 'Loading data...',
                  indicatorColor: AppColors.primary,
                  fontsize: 16,
                  strokeSize: 3,
                ),
              );
            }

            if (state is DashFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }


            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 24.0,
                vertical: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height:14),
                    _buildFormLogsSection(isMobile),
                    // : const SizedBox(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormLogsSection(bool isMobile) {
    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<dynamic>?>(
          future: context.read<DashCubit>().fetchFormLogs(adminId: userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text("No activity logs found.")),
              );
            }

            final logs = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                // return Card(
                //   margin: const EdgeInsets.only(bottom: 8),
                //   elevation: 0,
                //   shape: RoundedRectangleBorder(
                //     side: BorderSide(color: Colors.grey.shade200),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: ListTile(
                //     leading: Container(
                //       padding: const EdgeInsets.all(8),
                //       decoration: BoxDecoration(
                //         color: AppColors.primary.withOpacity(0.1),
                //         shape: BoxShape.circle,
                //       ),
                //       child: const Icon(Icons.description_outlined, color: AppColors.primary),
                //     ),
                //     title: Text(
                //       log['activity_name'] ?? 'Form Submission',
                //       style: const TextStyle(fontWeight: FontWeight.w600),
                //     ),
                //     subtitle: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text("Date: ${log['created_at'] ?? 'N/A'}"),
                //         const SizedBox(height: 4),
                //         Text("Participants : ${log['participants_number'] ?? 'N/A'}"),
                //         const SizedBox(height: 4),
                //         Text("Grade: ${log['participants_grades'] ?? 'N/A'}"),
                //       ],
                //     ),
                //
                //     //trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                //   ),
                // );
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Section
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.15),
                                AppColors.primary.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.description_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Content Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title + Arrow Row
                              Text(
                                log['activity_name'] ?? 'Form Submission',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  letterSpacing: -0.2,
                                  color: Color(0xFF1A1A2E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                log['activity_description'] ?? 'No description available',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  letterSpacing: -0.2,
                                  color: Colors.black38,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 10),

                              // Chips Row
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _InfoChip(
                                    icon: Icons.calendar_today_rounded,
                                    label: log['created_at'] ?? 'N/A',
                                  ),
                                  _InfoChip(
                                    icon: Icons.people_alt_rounded,
                                    label: formatParticipants(log['participants_number']),
                                  ),
                                  _InfoChip(
                                    icon: Icons.grade_rounded,
                                    label: 'Grade ${log['participants_grades'] ?? 'N/A'}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
  String formatParticipants(dynamic participantsData) {
    if (participantsData == null || participantsData.toString().isEmpty) {
      return 'N/A';
    }

    try {
      final decoded = participantsData is String
          ? jsonDecode(participantsData)
          : participantsData;

      if (decoded is List) {
        return decoded.map((item) {
          return "${item['grade']} (${item['total']})";
        }).join(', ');
      }

      return participantsData.toString();
    } catch (e) {
      return participantsData.toString();
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF888899)),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 3,
            softWrap: true,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555566),
              fontWeight: FontWeight.w500,

            ),
          ),
        ],
      ),
    );
  }
}
