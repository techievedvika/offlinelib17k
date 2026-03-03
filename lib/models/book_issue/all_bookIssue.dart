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
import 'package:lib17000ft/forms/book_issue/book_issue_cubit.dart';
import 'package:lib17000ft/forms/book_issue/book_issue_state.dart';
import 'package:lib17000ft/forms/filters/filter_bottom_sheet.dart';
import 'package:lib17000ft/forms/filters/filter_cubit.dart';
import 'package:lib17000ft/forms/filters/filter_dropdown.dart';
import 'package:lib17000ft/models/book_issue/book_issue_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/permission_storage.dart';

class AllBookIssueList extends StatefulWidget {
   String? state;
    String? district;
    String? block;
    String? school;
    String? from;
    String? to;
    //String? role;
   AllBookIssueList({super.key,this.state,this.district,this.block,this.school,this.from,this.to});

  @override
  State<AllBookIssueList> createState() => _AllBookIssueListState();
}

class _AllBookIssueListState extends State<AllBookIssueList> {
  final ScrollController _scrollController = ScrollController();
  final bool _isLoadingMore = false;
  String _searchQuery = '';
  String? userId;
  DateTimeRange? _selectedDateRange;
  String? rights;
  String? userRole;
  bool? isSuperAdmin;
  String? stateName;
  String? userSchool;
  String? block;
  String? levels;
  String? language;
  String? school;
  String? districtName;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    //_scrollController.addListener(_scrollListener);
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
      userSchool = prefs.getString('school')?.toLowerCase().trim();

      // Log all stored SharedPreferences data for debugging
      print("---- SharedPreferences Data ----");
      prefs.getKeys().forEach((key) {
        print("$key: ${prefs.get(key)}");
      });
      print("-----------------------------");


      if (userId != null) {
        context.read<BookIssueCubit>().fetchBookIssued(
              adminId: userId,
              stateName:widget.state,
            district:widget.district,
            block:  widget.block,
            //role: widget.role,
            school: widget.school,
            from: widget.from,
            to:widget.to
            );
      }

      if(userRole =='Admin'.toLowerCase().trim() || userRole =='Librarian'.toLowerCase().trim()){
        isSuperAdmin = false;
      } else {
        isSuperAdmin = true;
      }
    });
    print("this is the user id $userId");
  }

  List<BookIssueModel> _filterBookIssued(
      List<BookIssueModel> books, String query) {
    if (query.isEmpty) return books;
    return books.where((book) {
      final studentName = book.uniqid!.toLowerCase();
      final bookTitle = book.title!.toLowerCase();

      return studentName.contains(query.toLowerCase()) ||
          bookTitle.contains(query.toLowerCase());
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
          title: 'All Issued Books',
          studentAdd: false,
          backbutton: true,
        ),
        drawer: const CustomDrawer(),
        body: BlocBuilder<BookIssueCubit, BookIssueState>(
          builder: (context, state) {
            if (state is BookIssueLoading && !_isLoadingMore) {
              return const Center(
                child: TextWithCircularProgress(
                  text: 'Loading data...',
                  indicatorColor: AppColors.primary,
                  fontsize: 16,
                  strokeSize: 3,
                ),
              );
            } else if (state is BookIssueFailure) {
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
                            .read<BookIssueCubit>()
                            .fetchBookIssued(adminId: userId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is BookIssuedListSuccess) {
              final filteredIssuedBooks =
                  _filterBookIssued(state.bookIssuedList, _searchQuery);

              return Column(
                children: [
                  // 🔍 Search bar always visible
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isPortrait ? 16 : 32,
                      vertical: 12,
                    ),
                    child: Row(children: [
                      Expanded(
                        child: SearchBar(
                          hintText: 'Search book by student ID or book ID',
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

                      const SizedBox(
                        width: 8,
                      ),

                      // Filter Button stays fixed
                      rights!.contains("7")
                          ? SizedBox(
                              height: 48,
                              width: 48,
                              child: IconButton(
                                onPressed: () {
                                  showFilterBottomSheet(
                                    title: 'Filter All Issued Books',
                                    context: context,
                                    buildFilterContent: _buildFilterContent,
                                    onApply: () {
                                      _applyFilters();
                                    },
                                  );
                                },
                                icon: const Icon(Icons.filter_alt, size: 20),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ))
                          : const SizedBox(),
                    ]),
                  ),

                  // 🧮 Result count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${filteredIssuedBooks.length} ${filteredIssuedBooks.length == 1 ? 'issued book' : 'issued books'} found',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),

                  // 📚 List or Empty State
                  Expanded(
                    child: filteredIssuedBooks.isEmpty
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
                                      ? 'No issued books found'
                                      : 'No matching results',
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'Issue a book to get started'
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
                                  .read<BookIssueCubit>()
                                  .fetchBookIssued(adminId: userId);
                            },
                            child: SafeArea(
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isPortrait
                                      ? screenWidth * 0.03
                                      : screenWidth * 0.1,
                                  vertical: 8,
                                ),
                                itemCount: filteredIssuedBooks.length +
                                    (_isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index >= filteredIssuedBooks.length) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  final student = filteredIssuedBooks[index];
                                  final studentJsonData =
                                  jsonEncode(student.toJson());

                                  return _buildStudentCard(
                                      student, context, studentJsonData);
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              );
            }

            return const Center(child: Text('No Data found'));
          },
        ),
        floatingActionButton: BlocBuilder<BookIssueCubit, BookIssueState>(
          builder: (context, state) {
            if (state is BookIssuedListSuccess &&
                state.bookIssuedList.isNotEmpty) {
              return FloatingActionButton.small(
                // onPressed: () async {
                //   final granted = await _requestStoragePermission();
                //   if (granted) {
                //     await _exportToCSV(state.bookIssuedList);
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //           content: Text('Storage permission is required')),
                //     );
                //   }
                // },
                // onPressed: () async {
                //   //final granted = await _requestStoragePermission();
                //   final granted = await PermissionService.requestStoragePermission();
                //   if (granted) {
                //     // You'll need to implement or call your _exportToCSV method here
                //     await _exportToCSV(state.bookIssuedList);
                //     // ScaffoldMessenger.of(context).showSnackBar(
                //     //   const SnackBar(content: Text('Exporting CSV...')),
                //     // );
                //   } else {
                //     // The bottom sheet will be shown automatically if needed.
                //     // This SnackBar is a fallback for other denial cases.
                //     if (mounted) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //             content: Text('Storage permission is required to export data.')),
                //       );
                //     }
                //   }
                // },
                onPressed: () async {
                  try {
                    await _exportToCSV(state.bookIssuedList);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('CSV exported successfully')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to export CSV')),
                      );
                    }
                  }
                },
                tooltip: 'Export CSV',
                child: const Icon(Icons.download, size: 20),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _applyFilters() {
    context.read<BookIssueCubit>().fetchBookIssued(
          adminId: userId!,
          //stateName: isSuperAdmin == true ? stateName : userState,
          stateName: stateName,
          block: block,
          school: school,
          from: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)
              : null,
          to: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)
              : null,
              level: levels,
              language: language,
    );
  }

  Widget _buildFilterContent(
      bool isMobile, void Function(VoidCallback fn) setModalState) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, filterState) {
        context.read<FilterCubit>().fetchStates();
        context.read<FilterCubit>().fetchLevels();
        context.read<FilterCubit>().fetchLanguage();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            if (filterState.states.isNotEmpty)
              if(isSuperAdmin == false)
                FilterDropdown(
                    value: filterState.selectedSchool,
                    hint: 'Select School',
                    items: (userSchool!= null ? [userSchool!] : []),
                    onChanged: (value) {
                      context.read<FilterCubit>().updateSelectedSchool(value!);
                      context.read<FilterCubit>().selectSchool(value);
                      setState(() {
                        school = value;
                      });
                      setModalState(() {});
                    },
                    isMobile: isMobile),
            if(isSuperAdmin == true)
            FilterDropdown(
                value: filterState.selectedState,
                hint: 'Select State',
                items: ['All', ...filterState.states],  //This is to get either user is Super admin or not
                onChanged: (value) {
                  context.read<FilterCubit>().updateSelectedState(value!);

                  setState(() {
                    stateName = value;
                  });
                    //context.read<FilterCubit>().fetchBlocks(value);

                  setModalState(() {});
                },
                isMobile: isMobile,
            ),
            const SizedBox(height: 12),
            FilterDropdown(
              value: filterState.selectedLevel,
              hint: 'Select Level',
              items:['All', ...filterState.levels] ,
              onChanged: (value) {
                context.read<FilterCubit>().updateSelectedLevel(value!);

                setState(() {
                  levels = value;
                });

                //  context.read<FilterCubit>().fetchBlocks(value);

                setModalState(() {});
              },
              isMobile: isMobile,
            ),
            const SizedBox(height: 12),
            //Select Language
            FilterDropdown(
              value: filterState.selectedLanguage,
              hint: 'Select Language',
              items: ['All', ...filterState.languages],
              onChanged: (value) {
                context.read<FilterCubit>().updateSelectedLanguage(value!);

                setState(() {
                  language = value;
                });

                //  context.read<FilterCubit>().fetchBlocks(value);

                setModalState(() {});
              },
              isMobile: isMobile,
            ),
            const SizedBox(height: 12),
            //if (filterState.districts.isNotEmpty && isSuperAdmin == true)
            if(filterState.districts.isNotEmpty && isSuperAdmin == true)
              FilterDropdown(
                  value: filterState.selectedDistrict,
                  hint: 'Select District',
                  items: ['All', ...filterState.districts],
                  onChanged: (value) {
                    context.read<FilterCubit>().updateSelectedDistrict(value!);

                    setState(() {
                      districtName = value;
                    });
                      //context.read<FilterCubit>().fetchBlocks(value);
                    setModalState(() {});
                    // print('---\n$districtName\n---');
                  },
                  isMobile: isMobile),

            // Block Dropdown
            const SizedBox(height: 12),
            // if (filterState.blocks.isNotEmpty && isSuperAdmin == true)
            if (filterState.blocks.isNotEmpty && filterState.districts.isNotEmpty && isSuperAdmin == true)
            FilterDropdown(
                value: filterState.selectedBlock,
                hint: 'Select Block',
                items: ['All', ...filterState.blocks],
                onChanged: (value) {
                  context.read<FilterCubit>().updateSelectedBlock(value!);
                  setState(() {
                    block = value;
                  });

                  //context.read<FilterCubit>().fetchBlocks(value);
                  setModalState(() {});
                  // print('---\n$block\n---');
                },
                isMobile: isMobile),
            //if (filterState.blocks.isNotEmpty)

            // School Dropdown
            const SizedBox(height: 12),
            // if (filterState.schools.isNotEmpty && isSuperAdmin == true)
            if (filterState.schools.isNotEmpty && filterState.blocks.isNotEmpty && isSuperAdmin == true)
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
                    // print('---\n$school\n---');
                  },
                  isMobile: isMobile,
              ),

            const SizedBox(height: 12),
            if (filterState.schools.isNotEmpty || filterState.states.isNotEmpty)

            // Date Range
            _buildDateFilterButton(isMobile, setModalState),

            // Clear Filters
             if (filterState.selectedState != null || _selectedDateRange != null || filterState.levels != null ||filterState.languages != null)
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

    //  print("From: $fromDate, To: $toDate $levels $language"); // Optional: for debugging

      if (userId != null) {
       //  print("From: $fromDate, To: $toDate $levels $language"); //
        context.read<BookIssueCubit>().fetchBookIssued(
              adminId: userId!,
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

  Widget _buildStudentIDCard(
      BookIssueModel student, BuildContext context, String studentData) {
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
                  _getInitials(student.name.toString()),
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
                    student.uniqid.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'UniqueId: ${student.uniqid}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // View button
            // OutlinedButton(
            //   onPressed: (){},

            //   style: OutlinedButton.styleFrom(
            //     foregroundColor: colorScheme.primary,
            //     side: BorderSide(color: colorScheme.primary),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     padding: EdgeInsets.symmetric(
            //       horizontal: isPortrait ? 12 : 16,
            //       vertical: 8,
            //     ),
            //   ),
            //   child: Text(
            //     student.issuedCount.toString(),
            //     style: theme.textTheme.labelMedium?.copyWith(
            //       color: colorScheme.primary,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(
      BookIssueModel bookReturn, BuildContext context, String studentData) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showBookReturnDetails(context, bookReturn),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book info section
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Book icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.book,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Book details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookReturn.name!,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            bookReturn.uniqid!,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Visual cue for tappability
                    Icon(
                      Icons.chevron_right,
                      color: theme.primaryColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Bottom sheet details view
  void _showBookReturnDetails(BuildContext context, BookIssueModel bookReturn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Book Issued Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Student info
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getInitials(bookReturn.name ?? '?'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                title: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookReturn.name!,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'STUDENT ID:${bookReturn.uniqid?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        'APAAR ID:${bookReturn.apparId ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          bookReturn.gender ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.school, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Class ${bookReturn.studentnclass ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_city,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            bookReturn.school!,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 24),

              // Book info
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  bookReturn.title ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  'by ${bookReturn.author}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              const SizedBox(height: 16),

              // Details grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3,
                children: [
                  _buildDetailItem('ISBN', bookReturn.isbn?? ''),
                  _buildDetailItem('Publisher', bookReturn.publisher ?? ''),
                  _buildDetailItem('Language', bookReturn.language!),
                  _buildDetailItem('Genre', bookReturn.gener ?? ''),
                  _buildDetailItem('Level', bookReturn.level??''),
                  // _buildDetailItem('Book Code', bookReturn.code),
                  _buildDetailItem(
                      'Issued Date', _formatDate(bookReturn.issuedDate?? '')),
                   _buildDetailItem(
                      'Returned Date', _formatDate(bookReturn.returnedDate?? '')),
                  _buildDetailItem('Issued By', bookReturn.createdBy?? ''),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

// Helper functions
  String _getInitials(String name) {
    final nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '';
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return '${nameParts[0][0]}${nameParts.last[0]}'.toUpperCase();
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
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

  // Future<void> _exportToCSV(List<BookIssueModel> bookIssueList) async {
  //   final List<List<String>> rows = [
  //     [
  //       'Name',
  //       'Title',
  //       'School Name',
  //       'Class',
  //       'Gender',
  //       'Student Id',
  //       'APAAR ID',
  //       'Issued Date',
  //       'Issued By',
  //       'ISBN',
  //       'Publisher',
  //       'Author',
  //       'Language',
  //       'Gener',
  //       'Level',
  //       'Code'
  //     ], // CSV headers
  //     ...bookIssueList.map((book) => [
  //           book.name ?? '',
  //           book.title ?? '',
  //           book.school ?? '',
  //           book.studentnclass ?? '',
  //           book.gender ?? '',
  //           book.uniqid ?? '',
  //           book.apparId ?? '',
  //           book.issuedDate ?? '',
  //           book.createdBy ?? '',
  //           book.isbn ?? '',
  //           book.publisher ?? '',
  //           book.author ?? '',
  //           book.language ?? '',
  //           book.gener ?? '',
  //           book.level ?? '',
  //           book.code ?? '',
  //         ])
  //   ];
  //
  //   final csvData = const ListToCsvConverter().convert(rows);
  //   final directory = await getExternalStorageDirectory();
  //   final path = '${directory!.path}/bookIssued_List.csv';
  //
  //   final file = File(path);
  //   await file.writeAsString(csvData);
  //   if (await Permission.manageExternalStorage.request().isGranted ||
  //       await Permission.storage.request().isGranted) {
  //     Directory? downloadsDir;
  //
  //     if (Platform.isAndroid) {
  //       downloadsDir =
  //           Directory('/storage/emulated/0/Download'); // public Downloads
  //     } else {
  //       downloadsDir = await getApplicationDocumentsDirectory(); // iOS fallback
  //     }
  //     final now = DateTime.now();
  //     final formattedDate =
  //         "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
  //     final file =
  //         File("${downloadsDir.path}/bookIssued_List$formattedDate.csv");
  //
  //     //final file = File("${downloadsDir.path}/students.csv");
  //     await file.writeAsString(csvData);
  //     print("File saved to: ${file.path}");
  //   } else {
  //     print("Storage permission not granted");
  //   }
  //
  //   // Save using FileSaver for Android/iOS support
  //   await FileSaver.instance.saveFile(
  //     name: 'bookIssued_List',
  //     bytes: file.readAsBytesSync(),
  //     ext: 'csv',
  //     mimeType: MimeType.csv,
  //   );
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Book Issued list exported successfully!')),
  //   );
  // }
  Future<void> _exportToCSV(List<BookIssueModel> bookIssueList) async {
    try {
      final List<List<String>> rows = [
        [
          'Name',
          'Title',
          'School Name',
          'Class',
          'Gender',
          'Student Id',
          'APAAR ID',
          'Issued Date',
          'Issued By',
          'ISBN',
          'Publisher',
          'Author',
          'Language',
          'Gener',
          'Level',
          'Code'
        ],
        ...bookIssueList.map((book) => [
          book.name ?? '',
          book.title ?? '',
          book.school ?? '',
          book.studentnclass ?? '',
          book.gender ?? '',
          book.uniqid ?? '',
          book.apparId ?? '',
          book.issuedDate ?? '',
          book.createdBy ?? '',
          book.isbn ?? '',
          book.publisher ?? '',
          book.author ?? '',
          book.language ?? '',
          book.gener ?? '',
          book.level ?? '',
          book.code ?? '',
        ])
      ];

      final csvData = const ListToCsvConverter().convert(rows);

      /// ✅ Step 1: Save in temporary directory (Scoped Storage safe)
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/bookIssued_List.csv');

      await tempFile.writeAsString(csvData);

      /// ✅ Step 2: Let user choose save location
      await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          sourceFilePath: tempFile.path,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Book Issued list exported successfully!'),backgroundColor: AppColors.primary),
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
}
