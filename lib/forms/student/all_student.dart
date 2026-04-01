import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:lib17000ft/components/circular_indicator.dart';
import 'package:lib17000ft/components/custom_appbar.dart';
import 'package:lib17000ft/components/custom_drawer.dart';
import 'package:lib17000ft/configs/color/color.dart';
import 'package:lib17000ft/forms/filters/filter_bottom_sheet.dart';
import 'package:lib17000ft/forms/student/student_cubit.dart';
import 'package:lib17000ft/forms/student/student_idcard.dart';
import 'package:lib17000ft/models/student_registration/student_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lib17000ft/services/csv_exporter.dart';
import 'package:lib17000ft/components/student_details_bottom_sheet.dart';
import 'package:lib17000ft/forms/filters/filter_content_widget.dart';

import '../../services/permission_storage.dart';

class AllStudentList extends StatefulWidget {
    String? state;
    String? district;
    String? block;
    String? school;
    String? from;
    String? to;
    AllStudentList({super.key,this.state,this.district,this.block,this.school,this.from,this.to});


  @override
  State<AllStudentList> createState() => _AllStudentListState();
}

class _AllStudentListState extends State<AllStudentList> {
  final ScrollController _scrollController = ScrollController();
  final bool _isLoadingMore = false;
  String _searchQuery = '';
  String? userId;
  DateTimeRange? _selectedDateRange;
  String? rights;
  String? userRole;
  String? libSchool;
  bool? isSuperAdmin;

  String? stateName;
  String? block;
  String? school;
  String? districtName;

  String? _tempSelectedState;
  String? _tempSelectedDistrict;
  String? _tempSelectedBlock;
  String? _tempSelectedSchool;
  DateTimeRange? _tempSelectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      rights = prefs.getString('rights');
      userRole = prefs.getString('role')?.toLowerCase().trim();
      libSchool = prefs.getString('school')?.toLowerCase().trim();
      if (userId != null) {
        context.read<StudentCubit>().fetchStudents(adminId: userId,stateName:widget.state,district:widget.district,block:  widget.block,school: widget.school,from: widget.from,to:widget.to);
      }
      if(userRole =='Admin'.toLowerCase().trim() || userRole =='Librarian'.toLowerCase().trim()) {
        isSuperAdmin = false;
      } else {
        isSuperAdmin = true;
      }
    });
  }

  List<StudentModel> _filterStudents(
      List<StudentModel> students, String query) {
    if (query.isEmpty) return students;
    return students.where((student) {
      final name = student.name.toLowerCase();
      final roll = student.rollNo.toLowerCase();
      final classs = student.classs.toLowerCase();
      return name.contains(query.toLowerCase()) ||
          roll.contains(query.toLowerCase()) ||
          classs.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => _showExitConfirmationDialog(context),
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'All Students',
          studentAdd: false,
          // download: true,
          backbutton: true,
        ),
        drawer: const CustomDrawer(),
        body: BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading && !_isLoadingMore) {
              return const Center(
                child: TextWithCircularProgress(
                  text: 'Loading students...',
                  indicatorColor: AppColors.primary,
                  fontsize: 16,
                  strokeSize: 3,
                ),
              );
            } else if (state is StudentFailure) {
              // print(state.message);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<StudentCubit>().fetchStudents(adminId: userId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is StudentListSuccess) {
              final filteredStudents =
                  _filterStudents(state.studentList, _searchQuery);

              return SafeArea(
                child: Column(
                  children: [
                    // 🔍 Search bar always visible

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isPortrait ? 16 : 32,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // Search Bar takes all remaining space
                          Expanded(
                            child: SearchBar(
                              hintText: 'Search students by name or ID',
                              hintStyle: WidgetStateProperty.all(
                                  const TextStyle(color: Colors.grey)
                              ),
                              leading: const Icon(Icons.search),
                              elevation: MaterialStateProperty.all(1.0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 8),
                          if (rights?.contains("7") ?? false)
                            SizedBox(
                              height: 48,
                              width: 48,
                              child: IconButton(
                                onPressed: () {
                                  //This ensures that every time filter filter button pressed the values are reset
                                  _tempSelectedState = null;
                                  _tempSelectedDistrict = null;
                                  _tempSelectedBlock = null;
                                  _tempSelectedSchool = null;
                                  _tempSelectedDateRange = null;

                                  showFilterBottomSheet(
                                    title: 'Filter All Students',
                                    context: context,
                                    buildFilterContent: (isMobile, setModalState) {
                                      return FilterContentWidget(
                                          isSuperAdmin: isSuperAdmin ?? true,
                                          libSchool: libSchool,
                                          onStateChanged: (value) => _tempSelectedState = value,
                                          onDistrictChanged: (value) => _tempSelectedDistrict = value,
                                          onBlockChanged: (value) => _tempSelectedBlock = value,
                                          onSchoolChanged: (value) => _tempSelectedSchool = value,
                                          onDateRangeChanged: (value) => _tempSelectedDateRange = value,
                                          onClear: (){
                                            setModalState(() {});
                                          }
                                      );
                                    },
                                    onApply: () {
                                      // Use the temporary values when the button is pressed
                                      context.read<StudentCubit>().fetchStudents(
                                        adminId: userId,
                                        stateName: _tempSelectedState,
                                        district: _tempSelectedDistrict,
                                        block: _tempSelectedBlock,
                                        school: _tempSelectedSchool,
                                        from: _tempSelectedDateRange?.start != null
                                            ? DateFormat('yyyy-MM-dd').format(_tempSelectedDateRange!.start)
                                            : null,
                                        to: _tempSelectedDateRange?.end != null
                                            ? DateFormat('yyyy-MM-dd').format(_tempSelectedDateRange!.end)
                                            : null,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.filter_alt, size: 20),
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primary.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),


                    // 🧮 Student count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${filteredStudents.length} ${filteredStudents.length == 1 ? 'student' : 'students'} found',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),

                    // 🧑‍🎓 Student list or empty state
                    Expanded(
                      child: filteredStudents.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school_outlined,
                                size: 64,
                                color: theme.primaryColor.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No students found'
                                  : 'No matching students',
                              style:
                              theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Add a new student to get started'
                                  : 'Try a different search',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                          : RefreshIndicator(
                        color: theme.primaryColor,
                        onRefresh: () async {
                          await context
                              .read<StudentCubit>()
                              .fetchStudents(adminId:  userId);
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: isPortrait
                                ? screenWidth * 0.03
                                : screenWidth * 0.1,
                            vertical: 8,
                          ),
                          itemCount: filteredStudents.length +
                              (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= filteredStudents.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final student = filteredStudents[index];
                            final studentJsonData =
                            jsonEncode(student.toJson());

                            return _buildStudentCard(
                                student, context, studentJsonData);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No students found'));
          },
        ),
        floatingActionButton: BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            if (state is StudentListSuccess && state.studentList.isNotEmpty) {
              final filteredStudents = _filterStudents(state.studentList, _searchQuery);
              return FloatingActionButton.small(
                onPressed: () async {
                  try {
                    await _exportToCSV(state.studentList);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Export failed: $e')),
                      );
                    }
                  }
                },
                tooltip: 'Export CSV',
                child: const Icon(Icons.download,
                    size: 20), // optional but good for accessibility
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _exportToCSV(List<StudentModel> students) async {
    try {
      /// 1. Prepare CSV Data
      final List<List<String>> rows = [
        ['Name', 'Gender', 'Student ID', 'Class', 'APAAR ID', 'School'],
        ...students.map((student) => [
          student.name ?? '',
          student.gender ?? '',
          student.rollNo ?? '',
          student.classs ?? '',
          student.apaarId ?? 'N/A',
          student.school ?? '',
        ])
      ];

      final csvData = const ListToCsvConverter().convert(rows);

      /// 2. Generate timestamp filename
      final formattedDate =
      DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());

      /// 3. Save in temporary directory (Scoped Storage safe)
      final tempDir = await getTemporaryDirectory();
      final tempFile =
      File('${tempDir.path}/Student_List_$formattedDate.csv');

      await tempFile.writeAsString(csvData);

      /// 4. Let user choose location
      await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          sourceFilePath: tempFile.path,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Student list exported successfully!'),
            backgroundColor: AppColors.primary,
          ),

        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e',style: const TextStyle(color: AppColors.onError),),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickDateRange(
      void Function(VoidCallback fn) setModalState) async {
    final now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      setModalState(() {});

      // Format dates to YYYY-MM-DD
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String fromDate = formatter.format(picked.start);
      final String toDate = formatter.format(picked.end);

      print("From: $fromDate, To: $toDate"); // Optional: for debugging

      if (userId != null) {
        context.read<StudentCubit>().fetchStudents(
             adminId:  userId!,
              from: fromDate,
              to: toDate,
            );
      }
    }
  }


    Widget _buildDateFilterButton(
      bool isMobile, void Function(VoidCallback fn) setModalState) {
    return GestureDetector(
      onTap: () {
        _pickDateRange(setModalState);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              _selectedDateRange == null
                  ? 'Select Date Range'
                  : '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                color: _selectedDateRange == null
                    ? Colors.grey.shade600
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(
      StudentModel student, BuildContext context, String studentData) {
    final theme = Theme.of(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        //onTap: () =>  _showStudentDetailsBottomSheet(context,student),
        //onTap: () => showStudentDetailsBottomSheet(context, student),
        child: Padding(
          padding: EdgeInsets.all(isPortrait ? 12 : 16),
          child: Row(
            children: [
              // Profile initials
              Container(
                width: isPortrait ? 56 : 64,
                height: isPortrait ? 56 : 64,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: TextButton(
                    child: Text(
                      _getInitials(student.name),
                      style: TextStyle(
                        fontSize: isPortrait ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    onPressed:() => showStudentDetailsBottomSheet(context, student),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name and ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Student ID: ${student.rollNo}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'APAAR ID: ${student.apaarId ?? "XXXXXXXXXX"}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // View button
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentIdCard(
                      studentData: studentData,
                    ),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isPortrait ? 12 : 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  'View Card',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '';
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return '${nameParts[0][0]}${nameParts.last[0]}'.toUpperCase();
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit?'),
            content: const Text('Do you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }
}