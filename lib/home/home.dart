import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib17000ft/components/custom_drawer.dart';
import 'package:lib17000ft/components/nointernet_widget.dart';
import 'package:lib17000ft/configs/helper/responsive_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_appbar.dart';
import '../configs/color/color.dart';
import '../configs/routes/routes_name.dart';
import '../login/bloc/network_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  String? username;
  String? school;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    context.read<NetworkCubit>();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      username = prefs.getString('username');
      school = prefs.getString('school');
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: const Color.fromARGB(255, 245, 199, 201),
      appBar: const CustomAppbar(title: 'All Forms'),
      body: BlocConsumer<NetworkCubit, NetworkState>(
        listener: (context, networkState) {
          if (networkState is NetworkDisconnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No Internet Connection'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, networkState) {
          if (networkState is NetworkConnected) {
            return Padding(
              padding: responsive.responsivePadding(8, 16, 24),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount:
                    responsive.responsiveValue(small: 2, medium: 3, large: 4),
                crossAxisSpacing:
                    responsive.responsiveValue(small: 8, medium: 12, large: 16),
                mainAxisSpacing:
                    responsive.responsiveValue(small: 8, medium: 12, large: 16),
                childAspectRatio: responsive.responsiveValue(
                    small: 1.1, medium: 1.2, large: 1.3),
                children: [
                  _buildGridItem(
                      context,
                      'Student Registration',
                      RoutesName.studentRegistration,
                      'assets/registration.png',
                      responsive),
                  _buildGridItem(context, 'Book Issue', RoutesName.bookIssue,
                      'assets/bookissue.png', responsive),
                  _buildGridItem(context, 'Book Return', RoutesName.bookReturn,
                      'assets/bookreturn.png', responsive),
                ],
              ),
            );
          }

          if (networkState is NetworkDisconnected) {
            return NoInternetWidget(
              onRetry: () {
                context.read<NetworkCubit>();
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        child: const Icon(Icons.logout),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
    });
  }

  Widget _buildGridItem(
    BuildContext context,
    String title,
    String route,
    String path,
    Responsive responsive,
  ) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: responsive.responsiveTextSize(14, 18, 20),
      color: AppColors.background,
    );

    return Card(
      color: AppColors.onPrimary,
      margin: responsive.responsiveMargin(6, 8, 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, route),
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: Container(
          padding: responsive.responsivePadding(8, 12, 16),
          constraints: const BoxConstraints(
            minHeight: 120, // Ensure consistent height
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image with responsive sizing
              Flexible(
                child: FractionallySizedBox(
                  widthFactor: 0.7, // Takes 70% of available width
                  child: Image.asset(
                    path,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Text with proper overflow handling
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textStyle,
                  maxLines: 2, // Limit to 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
