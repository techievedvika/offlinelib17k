import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lib17000ft/components/circular_indicator.dart';
import 'package:lib17000ft/components/custom_appbar.dart';
import 'package:lib17000ft/forms/book_return/all_bookReturn.dart';
import 'package:lib17000ft/forms/dashboard/bargraph.dart';
import 'package:lib17000ft/forms/dashboard/dash_cubit.dart';
import 'package:lib17000ft/forms/dashboard/dash_state.dart';
import 'package:lib17000ft/forms/filters/filter_bottom_sheet.dart';
import 'package:lib17000ft/forms/filters/filter_cubit.dart';
import 'package:lib17000ft/forms/filters/filter_dropdown.dart';
import 'package:lib17000ft/forms/student/all_student.dart';
import 'package:lib17000ft/models/book_issue/all_bookIssue.dart';
import 'package:lib17000ft/models/dash/dash_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lib17000ft/components/component.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/animated_pie_chart.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  DashModel? dashData;
  String? userId;
  String? role;
  final int _touchedIndex = -1;
  DateTimeRange? _selectedDateRange;
  List<dynamic>? barGraph;
  int? totalBooksIssued;
  String? stateName;
  String? districtName;
  String? block;
  String? school;
  String? rights;
  bool? isSuperAdmin;
  String? libSchool;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    getAppVersion();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutBack,
    );
    _animationController.forward();
    //_requestNotificationPermission();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> getAppVersion() async {
    //PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences prefs = await SharedPreferences.getInstance();


    //current = prefs.getString('userId');

    // String version = packageInfo.version; // e.g. 1.0.0
    // String buildNumber = packageInfo.buildNumber; // e.g. 1

    // final currentVersion = "$version+$buildNumber";
    final currentVersion = prefs.getString('currentVersion');

    final libVersion = await context.read<DashCubit>().fetchLibVersion();

    if(libVersion != currentVersion){
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.onPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'New Version Available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Go to Play store'),
                  onPressed: () async {
                    final Uri url = Uri.parse("https://play.google.com/store/apps/details?id=org.ft17000.lib17000ft");

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),

                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Got it',style: TextStyle(color: AppColors.onPrimary,fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }
    print("Library Version: $libVersion");
    print("Version: $currentVersion");
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    role = prefs.getString('role')?.toLowerCase().toString();
    rights = prefs.getString('rights');
    role ??= 'Guest';
    libSchool = prefs.getString('school');

    if (userId != null && mounted) {
      print('fetchdashdata is called');
      context.read<DashCubit>().dashData(adminId: userId!);
    }
    if(role =='Admin'.toLowerCase().trim() || role =='Librarian'.toLowerCase().trim()){
      isSuperAdmin = false;
    } else {
      isSuperAdmin = true;
    }
  }

  Future<void> _pickDateRange_without() async {
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

      // Format dates to YYYY-MM-DD
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String fromDate = formatter.format(picked.start);
      final String toDate = formatter.format(picked.end);

      print("From: $fromDate, To: $toDate"); // Optional: for debugging

      if (userId != null) {
        context.read<DashCubit>().dashData(
              adminId: userId!,
              from: fromDate,
              to: toDate,
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
        context.read<DashCubit>().dashData(
              adminId: userId!,
              from: fromDate,
              to: toDate,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth < 900;

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Dashboard',
        notification: true,
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: BlocConsumer<DashCubit, DashState>(
          listener: (context, state) {
            if (state is DashSuccess) {
              dashData = state.data;
              barGraph = state.data.bargraph;
              totalBooksIssued = barGraph!
                  .fold(0, (sum, item) => sum! + (item['total_issues'] as int));

              // barGraph
            }
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

            if (dashData == null) {
              return const Center(child: Text("No dashboard data found."));
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
                    _buildHeader(isMobile),
                    const SizedBox(height: 14),
                    // New Filter Section
                    //_buildFiltersSection(isMobile),
                    const SizedBox(height: 14),
                    const SizedBox(height: 20),
                    _buildMetricsGrid(isMobile, isTablet),
                    const SizedBox(height: 14),
                    _buildBookActivityChart(isMobile),
                    // : const SizedBox(),
                    const SizedBox(height: 14),
                    BookStatsChart(
                      barGraphData: dashData!.bargraph,
                      //An totalBooksIssued: totalBooksIssued!,
                    )
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

  void _applyFilters() {
    print('apply filter is called');
    context.read<DashCubit>().dashData(
          adminId: userId!,
          from: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)
              : null,
          to: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)
              : null,
          stateName: stateName,
          block: block,
          school: school,
        );
  }

  Widget _buildHeader(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Role
            Flexible(
              child: Text(
                role?.isNotEmpty == true ? role! : '',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Right: Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rights?.contains("7") ?? false)
                  IconButton(
                    onPressed: () {
                      showFilterBottomSheet(
                        title: 'Filter Dashboard',
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
                    tooltip: 'Filter',
                  ),
                IconButton(
                  onPressed: () {
                    _pickDateRange_without();
                  },
                  icon: const Icon(Icons.calendar_month, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  tooltip: 'Date Filter',
                ),
                if (_selectedDateRange != null)
                  Container(
                    constraints: const BoxConstraints(maxWidth: 160),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            '${DateFormat('d MMM').format(_selectedDateRange!.start)} - ${DateFormat('d MMM').format(_selectedDateRange!.end)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDateRange = null;
                            });
                            if (userId != null) {
                              context.read<DashCubit>().dashData(
                                    adminId: userId!,
                                    from: null,
                                    to: null,
                                  );
                            }
                          },
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricsGrid(bool isMobile, bool isTablet) {
    // Get the screen width to adjust grid based on device size
    final screenWidth = MediaQuery.of(context).size.width;

    // Define the crossAxisCount based on screen width
    final crossAxisCount = screenWidth < 600
        ? 3 // Mobile devices
        : screenWidth < 1200
            ? 3 // Tablets
            : 4; // Larger screens (e.g., iPad 13-inch)

    // Define the childAspectRatio for different devices
    final childAspectRatio = screenWidth < 600
        ? 0.6 // Mobile devices (compact)
        : screenWidth < 1200
            ? 1.2 // Tablets (balanced)
            : 1.5; // Larger screens (spacious)

    // The metrics to display on the grid
    final metrics = [
      {
        'title': 'Total Students',
        'value': dashData!.students,
        'icon': Icons.people_alt,
        'color': Colors.blue
      },
      {
        'title': 'Books Issued',
        'value': dashData!.bookIssued,
        'icon': Icons.book,
        'color': Colors.green
      },
      {
        'title': 'Pending Returns',
        'value': dashData!.pendingReturn,
        'icon': Icons.pending,
        'color': Colors.orange
      },
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: childAspectRatio,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return _buildMetricCard(
          metric['title'].toString(),
          metric['value'].toString(),
          metric['icon'] as IconData,
          metric['color'] as Color,
        );
      },
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Get the screen size
        double screenWidth = MediaQuery.of(context).size.width;

        // Set responsive values
        double iconSize =
            screenWidth < 600 ? 16 : 22; // Smaller for smaller screens
        // double fontSizeTitle = screenWidth < 600 ? 14 : 20;
        double fontSizeValue = screenWidth < 600 ? 18 : 22;
        double padding =
            screenWidth < 600 ? 12 : 16; // More padding for larger screens

        return Transform.scale(
          scale: _animation.value,
          child: InkWell(
            onTap: () {
              if (title.contains('Total Students')) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  AllStudentList(state:stateName,district: districtName,block: block,school: school,from:_selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)
              : null ,to: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)
              : null,)));
              }
              if (title.contains('Pending Returns')) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  AllBookReturnList(state:stateName,district: districtName,block: block,school: school,from:_selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)
              : null ,to: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)
              : null,)));
              }
              if (title.contains('Books Issued')) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  AllBookIssueList(state:stateName,district: districtName,block: block,school: school,from:_selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)
              : null ,to: _selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)
              : null,)));
              }
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.1),
                      color.withOpacity(0.05),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: Responsive(context).screenWidth() < 600
                                ? 16
                                : 26,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: Responsive(context).screenWidth() < 600
                                ? 12
                                : 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: TextStyle(
                            color: color,
                            fontSize: fontSizeValue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookActivityChart(bool isMobile) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.withOpacity(0.05),
              Colors.indigo.withOpacity(0.02),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GROW Level',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              ],
            ),
            const SizedBox(height: 16),
            (dashData!.green > 0 ||
                    dashData!.red > 0 ||
                    dashData!.orange > 0 ||
                    dashData!.white > 0)
                ? SizedBox(
                    height: isMobile ? 220 : 300,
                    child: Row(
                      children: [
                        Expanded(
                          flex: isMobile ? 4 : 3,
                          child: AnimatedPieChart(
                            touchedIndex: _touchedIndex,
                            animation: _animation,
                            green: dashData!.green,
                            red: dashData!.red,
                            orange: dashData!.orange,
                            white: dashData!.white,
                            na: dashData!.na,
                          ),
                        ),
                        Expanded(
                          flex: isMobile ? 2 : 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildChartIndicator('Green', Colors.green),
                                _buildChartIndicator('Red', Colors.red),
                                _buildChartIndicator('Orange', Colors.orange),
                                _buildChartIndicator('White', Colors.white),
                                _buildChartIndicator('Others', Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 150,
                    child: Center(
                      child: Text(
                        'No data available to display the chart.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  ///Filter update
  Widget _buildFilterContent(
      bool isMobile, void Function(VoidCallback fn) setModalState) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, filterState) {
        context.read<FilterCubit>().fetchStates();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // State Dropdown
            if(isSuperAdmin == false)
            FilterDropdown(
                value: filterState.selectedSchool,
                hint: 'Select School',
                items: (libSchool!= null ? [libSchool!] : []),
                onChanged: (value) {
                  context.read<FilterCubit>().updateSelectedSchool(value!);
                  context.read<FilterCubit>().selectSchool(value);
                  setState(() {
                    libSchool = value;
                  });
                  setModalState(() {});
                },
                isMobile: isMobile
            ),
            if(isSuperAdmin == true)
            FilterDropdown(
                value: filterState.selectedState,
                hint: 'Select State',
                items:['All', ...filterState.states],
                onChanged: (value) {
                  context.read<FilterCubit>().updateSelectedState(value!);

                  setState(() {
                    stateName = value;
                  });
                  //  context.read<FilterCubit>().fetchBlocks(value);

                  setModalState(() {});
                },
                isMobile: isMobile
            ),
            const SizedBox(height: 12),
            if (filterState.districts.isNotEmpty && isSuperAdmin == true)
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
            const SizedBox(height: 12),
            if (filterState.blocks.isNotEmpty &&
                filterState.districts.isNotEmpty && isSuperAdmin == true)
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
            //if (filterState.blocks.isNotEmpty) const SizedBox(height: 12),
            const SizedBox(height: 12),
            // School Dropdown
            if (filterState.schools.isNotEmpty && isSuperAdmin == true)
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
            if (filterState.schools.isNotEmpty)
            const SizedBox(height: 12),

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

  Widget _buildChartIndicator(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
      child: Row(
        children: [
          Container(
            width: Responsive(context).screenWidth() < 600 ? 9 : 22,
            height: Responsive(context).screenWidth() < 600 ? 9 : 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: Responsive(context).screenWidth() < 600 ? 4 : 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: Responsive(context).screenWidth() < 600 ? 9 : 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });
}


// in this a date filter used using inkwell, the working is fine, but i don't like the UI/UX of filter at piechart, and i need an option to clear filter, and suggest me the new UI for filter minimalized and GenZ and modular kind 
