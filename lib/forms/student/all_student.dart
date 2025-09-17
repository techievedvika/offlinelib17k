import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lib17000ft/components/circular_indicator.dart';
import 'package:lib17000ft/components/custom_appbar.dart';
import 'package:lib17000ft/components/custom_drawer.dart';
import 'package:lib17000ft/configs/color/color.dart';
import 'package:lib17000ft/forms/filters/filter_bottom_sheet.dart';
import 'package:lib17000ft/forms/filters/filter_cubit.dart';
import 'package:lib17000ft/forms/filters/filter_dropdown.dart';
import 'package:lib17000ft/forms/student/student_cubit.dart';
import 'package:lib17000ft/forms/student/student_idcard.dart';
import 'package:lib17000ft/models/student_registration/student_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  
  String? stateName;
  String? block;
  String? school;
  String? districtName;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    // _requestStoragePermission();
     

    //_sc
    //rollController.addListener(_scrollListener);
  }
  Future<bool> _requestStoragePermission() async {
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    status = await Permission.storage.request();
  }

  if (status.isGranted) {
    return true;
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
    return false;
  }
  return false;
}


  // Future<bool> _requestStoragePermission() async {
  //   var status = await Permission.manageExternalStorage.status;

  //   if (!status.isGranted) {
  //     status = await Permission.manageExternalStorage.request();
  //   }
  //   if (status.isGranted) {
  //     print("Permission granted");
  //     return true;
  //   } else {
  //     print("Permission denied or permanently denied");
  //     openAppSettings(); // Optional: Guide user to settings
  //     return false;
  //   }
  // }

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
      if (userId != null) {
        
        context.read<StudentCubit>().fetchStudents(adminId: userId,stateName:widget.state,district:widget.district,block:  widget.block,school: widget.school,from: widget.from,to:widget.to);
       
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
          studentAdd: true,
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

              return Column(
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
   rights!.contains("7") ?   SizedBox(
        height: 48,
        width: 48,
        child: IconButton(
          onPressed: () {
            showFilterBottomSheet(
              context: context,
              buildFilterContent: _buildFilterContent,
              onApply: () {
                _applyFilters();
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
      ) : const SizedBox(),
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
              );
            }

            return const Center(child: Text('No students found'));
          },
        ),
        floatingActionButton: BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            if (state is StudentListSuccess && state.studentList.isNotEmpty) {
              return FloatingActionButton.small(
                onPressed: () async {
                  final granted = await _requestStoragePermission();
                  if (granted) {
                    print('PErsmision granted');
                    await _exportToCSV(state.studentList);
                  } else {
                     print('PErsmision not granted');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Storage permission is required')),
                    );
                    openAppSettings();
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

   void _applyFilters() {
    context.read<StudentCubit>().fetchStudents(
        adminId:   userId!,
        stateName: stateName,
        district: districtName,
        block: block,
        school: school,
       
       
          from: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)
              : null,
          to: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)
              : null,
        );
  }


  Widget _buildFilterContent(
      bool isMobile, void Function(VoidCallback fn) setModalState) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, filterState) {
        context.read<FilterCubit>().fetchStates();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // State Dropdown
             const SizedBox(height: 12),
            FilterDropdown(
                value: filterState.selectedState,
                hint: 'Select State',
                items:['All', ... filterState.states],
                onChanged: (value) {
                  context.read<FilterCubit>().updateSelectedState(value!);

                  setState(() {
                    stateName = value;
                  });
                  //  context.read<FilterCubit>().fetchBlocks(value);

                  setModalState(() {});
                },
                isMobile: isMobile),
            const SizedBox(height: 12),
            if (filterState.districts.isNotEmpty)
              FilterDropdown(
                  value: filterState.selectedDistrict,
                  hint: 'Select District',
                  items: ['All', ...filterState.districts],
                  onChanged: (value) {
                    context.read<FilterCubit>().updateSelectedDistrict(value!);

                    setState(() {
                      districtName = value;
                    });
                    //  context.read<FilterCubit>().fetchBlocks(value);

                    setModalState(() {});
                  },
                  isMobile: isMobile),

            // Block Dropdown
            if (filterState.blocks.isNotEmpty) const SizedBox(height: 12),
            FilterDropdown(
                value: filterState.selectedBlock,
                hint: 'Select Block',
                 items: ['All', ...filterState.blocks],
                onChanged: (value) {
                  context.read<FilterCubit>().updateSelectedBlock(value!);
                  setState(() {
                    block = value;
                  });

                  setModalState(() {});
                },
                isMobile: isMobile),
            if (filterState.blocks.isNotEmpty) const SizedBox(height: 12),

            // School Dropdown
            if (filterState.schools.isNotEmpty)
              FilterDropdown(
                  value: filterState.selectedSchool,
                  hint: 'Select School',
                  items: ['All', ...filterState.schools],
                  onChanged: (value) {
                    context.read<FilterCubit>().updateSelectedSchool(value!);
                    context.read<FilterCubit>().selectSchool(value);
                    setState(() {
                      school = value;
                    });
                    setModalState(() {});
                  },
                  isMobile: isMobile),

            if (filterState.schools.isNotEmpty) const SizedBox(height: 12),

            // Date Range
            _buildDateFilterButton(isMobile, setModalState),

            // Clear Filters
            if (filterState.selectedState != null || _selectedDateRange != null)
              TextButton(
                onPressed: () {
                  context.read<FilterCubit>().clearFilters();
                  setState(() {
                    _selectedDateRange = null;
                  });
                  setModalState(() {});
                },
                child: const Text("Clear All Filters"),
              )
          ],
        );
      },
    );
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

  //student infoc ard
  void _showStudentDetailsBottomSheet(
    BuildContext context, StudentModel student) {
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
                      _getInitials(student.name ?? '?'),
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
                          student.name ?? 'N/A',
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
                          'APAAR ID: ${student.apaarId}',
                          style: Theme.of(context).textTheme.bodySmall,
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
                _infoCard(context, Icons.school, "School", student.school!),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
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


Widget _infoRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
        onTap: () =>  _showStudentDetailsBottomSheet(context,student),
        
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
                  child: Text(
                    _getInitials(student.name),
                    style: TextStyle(
                      fontSize: isPortrait ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
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

  Future<void> _exportToCSV(List<StudentModel> students) async {
    final List<List<String>> rows = [
      [
        'Name',
        'Gender',
        'Student ID',
        'Class',
        'APAAR ID',
        'School'
      ], // CSV headers
      ...students.map((student) => [
            student.name,
            student.gender,
            student.rollNo,
            student.classs,
            student.apaarId ?? 'N/A',
            student.school!,
          ])
    ];

    final csvData = const ListToCsvConverter().convert(rows);
    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/students_list.csv';

    final file = File(path);
    await file.writeAsString(csvData);
    if (await Permission.manageExternalStorage.request().isGranted ||
        await Permission.storage.request().isGranted) {
      Directory? downloadsDir;

      if (Platform.isAndroid) {
        downloadsDir =
            Directory('/storage/emulated/0/Download'); // public Downloads
      } else {
        downloadsDir = await getApplicationDocumentsDirectory(); // iOS fallback
      }
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
      final file = File("${downloadsDir.path}/Student_List_$formattedDate.csv");

      //final file = File("${downloadsDir.path}/students.csv");
      await file.writeAsString(csvData);
      print("File saved to: ${file.path}");
    } else {
      print("Storage permission not granted");
    }

    // Save using FileSaver for Android/iOS support
    await FileSaver.instance.saveFile(
      name: 'students_list',
      bytes: file.readAsBytesSync(),
      ext: 'csv',
      mimeType: MimeType.csv,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student list exported successfully!')),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return ListView(
              children: options
                  .map((option) => ListTile(
                        title: Text(option),
                        onTap: () {
                          Navigator.pop(context);
                          onSelected(option);
                        },
                      ))
                  .toList(),
            );
          },
        );
      },
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
