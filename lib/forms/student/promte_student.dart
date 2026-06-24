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
import 'package:lib17000ft/forms/filters/filter_cubit.dart';
import 'package:lib17000ft/forms/filters/filter_dropdown.dart';
import 'package:lib17000ft/forms/student/student_cubit.dart';
import 'package:lib17000ft/forms/student/student_edit.dart';
import 'package:lib17000ft/services/csv_exporter.dart';
import 'package:lib17000ft/models/student_registration/student_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lib17000ft/forms/filters/filter_content_widget.dart';
import '../../components/student_details_bottom_sheet.dart';
import '../../configs/routes/routes_name.dart';
import '../../services/permission_storage.dart';

class PromoteStudentList extends StatefulWidget {
  const PromoteStudentList({super.key});

  @override
  State<PromoteStudentList> createState() => _PromoteStudentListState();
}

class _PromoteStudentListState extends State<PromoteStudentList> {
  final ScrollController _scrollController = ScrollController();
  final bool _isLoadingMore = false;
  String _searchQuery = '';
  String? userId;
  DateTimeRange? _selectedDateRange;
  String? rights;
  String? userRole;
  bool? isSuperAdmin;
  String? libSchool;

  String? stateName;
  String? districtName;
  String? block;
  String? school;
  String? location;

  String? _tempSelectedState;
  bool _isAscending = true;

  Set<String> _selectedStudentIds = {};
  bool _isSelectAll = false;

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
      libSchool = prefs.getString('school')?.toLowerCase().trim();
      userRole = prefs.getString('role')?.toLowerCase().trim();

      if (userId != null) {
        context.read<StudentCubit>().fetchStudents(adminId: userId);
      }
      if(userRole =='Admin'.toLowerCase().trim() || userRole =='Librarian'.toLowerCase().trim()){
        isSuperAdmin = false;
      } else {
        isSuperAdmin = true;
      }
    });
    print("this is the user id $userId");
  }

  List<StudentModel> _filterStudents(
      List<StudentModel> students, String query) {
    if (query.isEmpty) return students;
    return students.where((student) {
      final name = student.name.toLowerCase();
      final roll = student.rollNo?.toLowerCase();
      final classs = student.classs.toLowerCase();
      return name.contains(query.toLowerCase()) ||
          roll!.contains(query.toLowerCase()) ||
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
          title: 'Promote Students',
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
            }
            if (state is StudentPromote) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  context.read<StudentCubit>().fetchStudents(adminId: userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
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
                        onPressed: () => context
                            .read<StudentCubit>()
                            .fetchStudents(adminId: userId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is StudentListSuccess) {
              final filteredStudents =
                  _filterStudents(state.studentList, _searchQuery);

              filteredStudents.sort((a, b) {
                int weightA = _getGradeWeight(a.classs ?? '');
                int weightB = _getGradeWeight(b.classs ?? '');

                // Compare weights
                int compare = weightA.compareTo(weightB);

                // If grades are the same (same weight), sort by name as a secondary criteria
                if (compare == 0) {
                  return (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase());
                }

                return _isAscending ? compare : -compare;
              });

              return Column(
                children: [
                  // Search bar always visible

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

                        // Filter Button stays fixed
                        // rights!.contains("7")
                        //     ? SizedBox(
                        //         height: 48,
                        //         width: 48,
                        //         child: IconButton(
                        //           onPressed: () {
                        //             showFilterBottomSheet(
                        //               title: 'Filter Promote Students',
                        //               context: context,
                        //               buildFilterContent: _buildFilterContent,
                        //               onApply: () {
                        //                 _applyFilters();
                        //               },
                        //             );
                        //           },
                        //           icon: const Icon(Icons.filter_alt, size: 20),
                        //           style: IconButton.styleFrom(
                        //             backgroundColor:
                        //                 AppColors.primary.withOpacity(0.1),
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(12),
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : const SizedBox(),
                        if (rights!.contains("7") && isSuperAdmin == true)
                          SizedBox(
                            height: 48,
                            width: 48,
                            child: IconButton(
                              onPressed: () {
                                //This ensures that every time filter filter button pressed the values are reset
                                _tempSelectedState = null;
                                // _tempSelectedDistrict = null;
                                // _tempSelectedBlock = null;
                                // _tempSelectedSchool = null;
                                // _tempSelectedDateRange = null;

                                showFilterBottomSheet(
                                  title: 'Filter Promote Students',
                                  context: context,
                                  buildFilterContent: (isMobile, setModalState) {
                                    return FilterContentWidget(
                                      isSuperAdmin: isSuperAdmin ?? true,
                                      libSchool: libSchool,
                                      onStateChanged: (value) => _tempSelectedState = value,
                                      showDateFilter:false,
                                      // onDistrictChanged: (value) => _tempSelectedDistrict = value,
                                      // onBlockChanged: (value) => _tempSelectedBlock = value,
                                      // onSchoolChanged: (value) => _tempSelectedSchool = value,
                                      // onDateRangeChanged: (value) => _tempSelectedDateRange = value,
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
                                      // district: _tempSelectedDistrict,
                                      // block: _tempSelectedBlock,
                                      // school: _tempSelectedSchool,
                                      // from: _tempSelectedDateRange?.start != null
                                      //     ? DateFormat('yyyy-MM-dd').format(_tempSelectedDateRange!.start)
                                      //     : null,
                                      // to: _tempSelectedDateRange?.end != null
                                      //     ? DateFormat('yyyy-MM-dd').format(_tempSelectedDateRange!.end)
                                      //     : null,
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       '${filteredStudents.length} ${filteredStudents.length == 1 ? 'student' : 'students'} found',
                  //       style: theme.textTheme.bodySmall?.copyWith(
                  //         color: Colors.grey[600],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //alignment: Alignment.centerLeft,
                      children: [
                        Text(
                          '${filteredStudents.length} ${filteredStudents.length == 1 ? 'student' : 'students'} found',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isAscending == false ? Icons.arrow_upward : Icons.arrow_downward),
                          onPressed: () {
                            setState(() {
                              _isAscending = !_isAscending;
                            });
                          },
                        ),
                        SizedBox(
                          width: screenWidth * 0.2,
                        ),
                        Expanded(
                          child:  Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isSelectAll,
                                    onChanged: (value) {
                                      setState(() {
                                        _isSelectAll = value!;
                                        if (_isSelectAll) {
                                          _selectedStudentIds = filteredStudents.map((s) => s.id!).toSet();
                                        } else {
                                          _selectedStudentIds.clear();
                                        }
                                      });
                                    },
                                  ),
                                  Text("Select All",style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // Logic to refresh the list
                        await context.read<StudentCubit>().fetchStudents(
                          adminId: userId,
                          stateName: stateName, // maintains current filter
                        );
                      },
                      child: filteredStudents.isEmpty
                          ? Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? 'No students found'
                              : 'No matching students',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                      )
                          : () {
                        // 1. Group students by class/grade
                        Map<String, List<StudentModel>> groupedStudents = {};
                        for (var student in filteredStudents) {
                          String grade = student.classs ?? 'Unknown';
                          if (!groupedStudents.containsKey(grade)) {
                            groupedStudents[grade] = [];
                          }
                          groupedStudents[grade]!.add(student);
                        }

                        // 2. Sort the grade keys using the weight logic
                        var sortedGrades = groupedStudents.keys.toList()
                          ..sort((a, b) {
                            int weightA = _getGradeWeight(a);
                            int weightB = _getGradeWeight(b);
                            return _isAscending
                                ? weightA.compareTo(weightB)
                                : weightB.compareTo(weightA);
                          });

                        // 3. Return the grouped ListView
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: sortedGrades.length,
                          itemBuilder: (context, index) {
                            String grade = sortedGrades[index];
                            List<StudentModel> studentsInGrade =
                            groupedStudents[grade]!;

                            // Optional: Sort students by name within the grade
                            studentsInGrade.sort((a, b) => (a.name ?? '')
                                .toLowerCase()
                                .compareTo((b.name ?? '').toLowerCase()));

                            // return Padding(
                            //   padding: const EdgeInsets.only(bottom: 16.0),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       // Grade Header
                            //       Container(
                            //         width: double.infinity,
                            //         padding: const EdgeInsets.symmetric(
                            //             vertical: 8, horizontal: 12),
                            //         decoration: BoxDecoration(
                            //           color: AppColors.primary.withOpacity(0.1),
                            //           borderRadius: BorderRadius.circular(8),
                            //         ),
                            //         child: Text(
                            //           '$grade ("Students: ${studentsInGrade.length}")',
                            //           style: theme.textTheme.titleMedium?.copyWith(
                            //             fontWeight: FontWeight.bold,
                            //             color: AppColors.primary,
                            //           ),
                            //         ),
                            //       ),
                            //       const SizedBox(height: 8),
                            //
                            //       // Students in this specific grade
                            //       ListView.builder(
                            //         shrinkWrap: true,
                            //         physics:
                            //         const NeverScrollableScrollPhysics(),
                            //         itemCount: studentsInGrade.length,
                            //         itemBuilder: (context, studentIndex) {
                            //           final student =
                            //           studentsInGrade[studentIndex];
                            //           final studentJsonData =
                            //           jsonEncode(student.toJson());
                            //
                            //           return _buildStudentCard(
                            //               student, context, studentJsonData);
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ExpansionTile(
                                maintainState: true,

                                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                                title: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  // decoration: BoxDecoration(
                                  //   color: AppColors.primary.withOpacity(0.1),
                                  //   borderRadius: BorderRadius.circular(8),
                                  // ),
                                  child: Text(
                                    '$grade (Students: ${studentsInGrade.length})',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.tertiary,
                                    ),
                                  ),
                                ),
                                collapsedBackgroundColor: AppColors.primary.withOpacity(0.05),
                                backgroundColor: AppColors.primary.withOpacity(0.05),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: studentsInGrade.length,
                                    itemBuilder: (context, studentIndex) {
                                      final student =
                                      studentsInGrade[studentIndex];
                                      final studentJsonData =
                                      jsonEncode(student.toJson());

                                      return _buildStudentCard(
                                          student, context, studentJsonData);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }(),
                    )
                  )
                ]);
            }

            return const Center(child: Text('No students found'));
          },
        ),
        floatingActionButton: BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            if (state is StudentListSuccess && state.studentList.isNotEmpty) {
              final filteredStudents = _filterStudents(state.studentList, _searchQuery);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Promote All Button
                  if (_selectedStudentIds.isNotEmpty)
                    FloatingActionButton.extended(
                      heroTag: 'promote_all_button',
                      onPressed: () {
                        final selectedList = filteredStudents
                            .where((s) => _selectedStudentIds.contains(s.id))
                            .toList();
                        _promoteSelectedStudents(selectedList);
                      },
                      label: Text("Promote : ${_selectedStudentIds.length}",
                          style: const TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.arrow_circle_up, color: Colors.white),
                      backgroundColor: AppColors.primary,
                    ),

                  const SizedBox(height: 12),

                  // Export CSV Button
                  FloatingActionButton.small(
                    heroTag: 'export_csv_btn',
                    onPressed: () async {
                      try {
                        await _exportToCSV(state.studentList);
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Export failed: $e', style: const TextStyle(color: AppColors.onError)),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
                    tooltip: 'Export CSV',
                    child: const Icon(Icons.download, size: 20),
                  ),
                ],
              );
            }
            return const SizedBox.shrink(); // Hide button if there's no data
          },
        ),

      ),
    );
  }

  //To get grade weight to arrange student list accrodingly
  int _getGradeWeight(String grade) {
    String g = grade.toLowerCase().trim();
    if (g.contains('nursery')) return 1;
    if (g.contains('lkg')) return 2;
    if (g.contains('ukg')) return 3;

    // Extract digits for numeric grades (e.g., "Grade 1" or "1st" becomes 1)
    final numericMatch = RegExp(r'\d+').firstMatch(g);
    if (numericMatch != null) {
      return int.parse(numericMatch.group(0)!) + 3; // +3 to stay after UKG
    }

    return 999; // Fallback for unknown strings
  }

  Future<void> _promoteSelectedStudents(List<StudentModel> studentsToPromote) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Mandatory ID Check Loop
    // If any student is missing IDs, we show the edit sheet one by one.
    for (var student in studentsToPromote) {

      bool idsExist = await uniqueID(student);

      // If BOTH are missing, prompt for update
      if (!idsExist) {
        // We 'await' here. If the user clicks 'Proceed without updating' in the sheet,
        // this await finishes and the loop continues to the next student or promotion.
        await _openEditStudentSheet(student);
      }
    }

    // 2. Final Confirmation Dialog
    // This is reached after all selected students have been checked/edited.
    if (!mounted) return;
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Batch Promotion"),
        content: Text("Promote ${studentsToPromote.length} students to the next grade?"),
        actions: [
          TextButton(onPressed: () => Navigator.pushReplacementNamed(context, RoutesName.promoteStudent),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Promote All", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );

    // 3. Execution: Promotion runs regardless of ID status here
    if (confirm == true) {
      for (var student in studentsToPromote) {
        Map<String, dynamic> data = {
          "id": student.id,
          "class": student.classs, // The Cubit logic usually handles +1 grade logic
        };

        // Store the timestamp for future records
        final storageKey = 'promoted_${student.id}';
        final now = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
        await prefs.setString(storageKey, now);

        // Trigger the actual promotion
        context.read<StudentCubit>().promoteStudent(data);
      }

      setState(() {
        _selectedStudentIds.clear();
        _isSelectAll = false;
      });
    }
  }

  Future<void> _openEditStudentSheet(StudentModel student) async {
    await showModalBottomSheet(

      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return EditStudentScreen(
          student: student,
          skipOption: true,
        );
      },
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
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

      /// 3. Save in temporary directory (Scoped Storage safe)
      final tempDir = await getTemporaryDirectory();
      final tempFile =
      File('${tempDir.path}/Student_List_$formattedDate.csv');

      await tempFile.writeAsString(csvData);

      /// 4. Let user choose save location (system file picker)
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
              adminId: userId!,
              from: fromDate,
              to: toDate,
            );
      }
    }
  }



  Widget _buildStudentCard(StudentModel student, BuildContext context, String studentJsonData) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedStudentIds.contains(student.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        controlAffinity: ListTileControlAffinity.leading, // Checkbox on the left
        value: isSelected,
        activeColor: AppColors.primary,
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _selectedStudentIds.add(student.id!);
            } else {
              _selectedStudentIds.remove(student.id);
              _isSelectAll = false; // Uncheck 'Select All' if one is manually removed
            }
          });
        },
        title: Text(
          student.name ?? 'Unknown',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        // subtitle: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const SizedBox(height: 4),
        //     Text('Roll No: ${student.rollNo} | Class: ${student.classs}',style: theme.textTheme.bodyMedium?.copyWith(
        //       color: Colors.grey[600],
        //     ),),
        //     if(student.apaarId != null && student.apaarId != "NA" && student.penId == "NA")
        //       Text(
        //         'APAAR ID: ${student.apaarId}',
        //         style: theme.textTheme.bodyMedium?.copyWith(
        //           color: Colors.grey[600],
        //         ),
        //       ),
        //     if(student.penId != "NA" && student.penId != null && student.apaarId == "NA")
        //       Text(
        //         'PEN ID: ${student.penId}',
        //         style: theme.textTheme.bodyMedium?.copyWith(
        //           color: Colors.grey[600],
        //         ),
        //       ),
        //     if(student.apaarId == "NA" && student.penId == "NA")
        //       Text(
        //         'No APAAR ID/ PEN ID',
        //         style: theme.textTheme.bodyMedium?.copyWith(
        //           color: Colors.grey[600],
        //         ),
        //       ),
        //   ],
        // ),
        // subtitle: Text(
        //   'Lib Code - lib/${student.id ?? ''}',
        //
        //   style: Theme.of(context).textTheme.bodySmall,
        // ),
        secondary: Container(
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
              onPressed: () {
                showStudentDetailsBottomSheet(context, student);
              },
            ),
          ),
        ),
        // IconButton(
        //   icon: const Icon(Icons.info_outline, color: AppColors.primary),
        //   onPressed: () {
        //     // Reusing your existing details sheet logic
        //     showStudentDetailsBottomSheet(context, student);
        //   },
        // ),
      ),
    );
  }

  Future<bool> uniqueID(StudentModel student) async {
    // Returns TRUE only if any IDs is present
    // If both are "NA", it returns FALSE (triggering the redirect to edit)
    bool uniqueIdAvailable = student.penId != "NA" || student.apaarId != "NA";


    return uniqueIdAvailable ;
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

  Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? cancelText,
    String? confirmText,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              onCancel?.call();
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText!),
          ),
          TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            child: Text(confirmText!),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
