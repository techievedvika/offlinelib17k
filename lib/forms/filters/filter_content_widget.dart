import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lib17000ft/forms/filters/filter_cubit.dart';
import 'package:lib17000ft/forms/filters/filter_dropdown.dart';

// This widget is now much simpler. It just displays the form
// and calls a callback whenever a value changes.

class FilterContentWidget extends StatefulWidget {
  final bool isSuperAdmin;
  final String? libSchool;
  final bool showDateFilter;
  // NEW: ValueChanged callbacks for each filter type
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String?>? onDistrictChanged;
  final ValueChanged<String?>? onBlockChanged;
  final ValueChanged<String?>? onSchoolChanged;
  final ValueChanged<DateTimeRange?>? onDateRangeChanged;
  final VoidCallback onClear;

  const FilterContentWidget({
    super.key,
    required this.isSuperAdmin,
    this.showDateFilter = true,
    this.libSchool,
    required this.onStateChanged,
    this.onDistrictChanged,
    this.onBlockChanged,
    this.onSchoolChanged,
    this.onDateRangeChanged,
    required this.onClear,
  });

  @override
  State<FilterContentWidget> createState() => _FilterContentWidgetState();
}

class _FilterContentWidgetState extends State<FilterContentWidget> {
  // Local state for dropdowns
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedBlock;
  String? _selectedSchool;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    // Pre-fill the school for librarians
    if (!widget.isSuperAdmin && widget.libSchool != null) {
      _selectedSchool = widget.libSchool;
      // Important: Notify the parent of this initial value
      widget.onSchoolChanged!(_selectedSchool);
    }
    // Fetch initial list of states
    context.read<FilterCubit>().fetchStates();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      // Notify parent of the change
      widget.onDateRangeChanged!(_selectedDateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, filterState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown for Librarian (pre-filled and disabled)
            if (!widget.isSuperAdmin)
              FilterDropdown(
                value: _selectedSchool,
                hint: 'School',
                items: widget.libSchool != null ? [widget.libSchool!] : [],
                // No onChanged needed if it's disabled
                onChanged: (q) {},
                isMobile: isMobile,
              ),

            // Filters for Super Admin
            if (widget.isSuperAdmin) ...[
              FilterDropdown(
                value: _selectedState,
                hint: 'Select State',
                items: ['All', ...filterState.states],
                onChanged: (value) {
                  final finalValue = value == 'All' ? null : value;
                  setState(() {
                    _selectedState = finalValue;
                    // Reset dependent dropdowns
                    _selectedDistrict = null;
                    _selectedBlock = null;
                    _selectedSchool = null;
                  });
                  // Notify parent of all changes
                  widget.onStateChanged(finalValue);
                  widget.onDistrictChanged!(null);
                  widget.onBlockChanged!(null);
                  widget.onSchoolChanged!(null);

                  if (finalValue != null) {
                    context.read<FilterCubit>().fetchDistrict(finalValue);
                  }
                },
                isMobile: isMobile,
              ),
              const SizedBox(height: 12),
              if (filterState.districts.isNotEmpty)
                FilterDropdown(
                  value: _selectedDistrict,
                  hint: 'Select District',
                  items: ['All', ...filterState.districts],
                  onChanged: (value) {
                    final finalValue = value == 'All' ? null : value;
                    setState(() {
                      _selectedDistrict = finalValue;
                      _selectedBlock = null;
                      _selectedSchool = null;
                    });
                    widget.onDistrictChanged!(finalValue);
                    widget.onBlockChanged!(null);
                    widget.onSchoolChanged!(null);
                    if (finalValue != null) {
                      context.read<FilterCubit>().fetchBlocks(finalValue);
                    }
                  },
                  isMobile: isMobile,
                ),
              const SizedBox(height: 12),
              if (filterState.blocks.isNotEmpty)
                FilterDropdown(
                  value: _selectedBlock,
                  hint: 'Select Block',
                  items: ['All', ...filterState.blocks],
                  onChanged: (value) {
                    final finalValue = value == 'All' ? null : value;
                    setState(() {
                      _selectedBlock = finalValue;
                      _selectedSchool = null;
                    });
                    widget.onBlockChanged!(finalValue);
                    widget.onSchoolChanged!(null);
                    if (finalValue != null) {
                      context.read<FilterCubit>().fetchSchools(finalValue);
                    }
                  },
                  isMobile: isMobile,
                ),
              if (filterState.blocks.isNotEmpty) const SizedBox(height: 12),
              if (filterState.schools.isNotEmpty)
                FilterDropdown(
                  value: _selectedSchool,
                  hint: 'Select School',
                  items: ['All', ...filterState.schools],
                  onChanged: (value) {
                    final finalValue = value == 'All' ? null : value;
                    setState(() => _selectedSchool = finalValue);
                    widget.onSchoolChanged!(finalValue);
                  },
                  isMobile: isMobile,
                ),
            ],

            const SizedBox(height: 12),
            if(widget.showDateFilter)
            _buildDateFilterButton(),

            const SizedBox(height: 24), // Add some space

            // --- 3. ADD THIS ROW FOR THE CLEAR BUTTON ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Call the parent's clear callback
                    widget.onClear();

                    // Also clear the local state of this widget
                    setState(() {
                      _selectedState = null;
                      _selectedDistrict = null;
                      _selectedBlock = null;
                      _selectedDateRange = null;
                      // Only clear school if super admin
                      if (widget.isSuperAdmin) {
                        _selectedSchool = null;
                      }
                    });
                  },
                  child: const Text('Clear All Filters'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateFilterButton() {
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 12),
            Text(
              _selectedDateRange != null
                  ? '${DateFormat('MMM d, yyyy').format(_selectedDateRange!.start)} - ${DateFormat('MMM d, yyyy').format(_selectedDateRange!.end)}'
                  : 'Select Date Range',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
