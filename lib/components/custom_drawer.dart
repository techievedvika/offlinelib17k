import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lib17000ft/configs/color/color.dart';
import 'package:lib17000ft/configs/routes/routes_name.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? userId;
  String? username;
  String? school;
  String? rights;
  String?role;
  String? currentVersion;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      username = prefs.getString('username');
      school = prefs.getString('school');
      rights = prefs.getString('rights');
       role = prefs.getString('role');
       currentVersion = prefs.getString('currentVersion');
    
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return SafeArea(
      child: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        width: isSmallScreen ? null : 300, // Responsive width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(theme),

            // Menu Items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDrawerSection('Navigation', [

                      // _buildDrawerItem(
                      //   icon: FontAwesomeIcons.home,
                      //   title: 'Home',
                      //   route: RoutesName.homeScreen,
                      // ),

                      rights!.contains("1") ?  _buildDrawerItem(
                        icon: FontAwesomeIcons.chartLine,
                        title: 'Dashboard',
                        route: RoutesName.dashboard,
                      ) : const SizedBox(),

                    ]),

                  _buildDrawerSection('Book Management', [
                  rights!.contains("5") ?       _buildDrawerItem(
                    icon: FontAwesomeIcons.book,
                    title: 'Add Book',
                    route: RoutesName.bookAdd,
                  ) : const SizedBox(),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/offlineTest');
                      },
                      child: Text('Offline Test'),
                    )
                  ]),


                    // _buildDrawerSection('Book Management', [
                    //   rights!.contains("5") ?       _buildDrawerItem(
                    //     icon: FontAwesomeIcons.book,
                    //     title: 'Issue Book',
                    //     route: RoutesName.bookIssue,
                    //   ) : const SizedBox(),
                    //   rights!.contains("5") ?       _buildDrawerItem(
                    //     icon: FontAwesomeIcons.bookBookmark,
                    //     title: 'Return Book',
                    //     route: RoutesName.bookReturn,
                    //   ) : const SizedBox(),
                    //   rights!.contains("4") ?     _buildDrawerItem(
                    //     icon: FontAwesomeIcons.bookOpen,
                    //     title: 'All Issued Books',
                    //     route: RoutesName.allbookIssue,
                    //   ) : const SizedBox(),
                    //   rights!.contains("4") ?    _buildDrawerItem(
                    //     icon: Icons.pending,
                    //     title: 'Pending Returns',
                    //     route: RoutesName.allbookReturn,
                    //   ) : const SizedBox(),
                    // ]),

                    _buildDrawerSection('Student Management', [
                      rights!.contains("6") ?   _buildDrawerItem(
                        icon: FontAwesomeIcons.userPlus,
                        title: 'Add Students',
                        route: RoutesName.studentRegistration,
                      ) : const SizedBox(),
                      rights!.contains("3") ?     _buildDrawerItem(
                        icon: FontAwesomeIcons.peopleGroup,
                        title: 'All Students',
                        route: RoutesName.allStudent,
                      ) : const SizedBox(),
                      rights!.contains("3") ?   _buildDrawerItem(
                        icon: FontAwesomeIcons.userPen,
                        title: 'Promote Students',
                        route: RoutesName.promoteStudent,
                      ) : const SizedBox(),

                    ]),

                    ///This is for the form section
                    _buildDrawerSection('Library Activity', [
                      rights!.contains("6") ?   _buildDrawerItem(
                        icon: FontAwesomeIcons.file,
                        title: 'Activity Log Form',
                        route: RoutesName.libActivityLog,
                      ) : const SizedBox(),

                      rights!.contains("6") ?   _buildDrawerItem(
                        icon: FontAwesomeIcons.list,
                        title: 'Activity Log List',
                        route: RoutesName.libActivityList,
                      ) : const SizedBox(),

                    ]),

                    // _buildDrawerSection('App Version', [
                    //    _buildDrawerItem(
                    //     icon: FontAwesomeIcons.appStore,
                    //     title: '$currentVersion',
                    //      route: '',
                    //   ),
                    //
                    // ]),

                    const SizedBox(height: 15),
                    Text(
                      "App Version : $currentVersion",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        //color: Theme.of(context).primaryColor.withOpacity(0.7),
                        letterSpacing: 1.2,
                      ),
                    ),
                    //const SizedBox(height: 5),
                  ],
                ),
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildLogoutButton(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // User Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                username?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                   Text(
                  role ?? '',
                    style: const TextStyle(
                    color: AppColors.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    (username != null && username!.isNotEmpty)? username![0].toUpperCase() + username!.substring(1).toLowerCase()
                        : 'User',
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
               role!.contains('Super')? const SizedBox(): 
                  Text(
                    school ?? 'School',
                    
                    style: const TextStyle(
                    color: AppColors.onPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Close Button
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildDrawerItem({
    required FaIconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      dense: true,
      leading: FaIcon(icon, size: 18, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      minLeadingWidth: 24,
      onTap: () {
        Navigator.pop(context); // Close drawer first
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 16),
        label: const Text('LOGOUT'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.primary),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: _logout,
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        RoutesName.loginScreen, 
        (route) => false,
      );
    });
  }
}