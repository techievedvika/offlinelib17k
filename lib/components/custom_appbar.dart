
import 'package:flutter/material.dart';
import 'package:lib17000ft/configs/color/color.dart';
import 'package:lib17000ft/configs/routes/routes_name.dart';
import 'package:lib17000ft/forms/student/student_registration.dart';
import 'package:lib17000ft/splash/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? backbutton;
  final bool? studentAdd;
  final bool? notification;
  final bool? clearButton;
  final VoidCallback? onClear;
  //  final bool? download;

  const CustomAppbar({super.key, required this.title, this.backbutton,this.studentAdd,this.notification,this.clearButton,this.onClear});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: backbutton ?? false,
      actions: [
        studentAdd == true ? 
         IconButton(
          tooltip: 'Add student',
      icon: const Icon(Icons.add_circle),
      onPressed: () {
        // Open add student page
        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentRegistration(),
              ),
            );
      },
    ) : const SizedBox(),
     notification == true ? 
         IconButton(
          tooltip: 'Notifications',
      icon: const Icon(Icons.notifications),
      onPressed: () {
        // Open add student page
        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
      },
    ) : const SizedBox(),
    clearButton == true ? 
         
    IconButton(
      icon: const Icon(Icons.delete_forever),
      onPressed: onClear, // 👈 uses the callback passed in
    ) : const SizedBox(),
    //  download == true ? 
    // IconButton(
    //   icon: const Icon(Icons.download),
    //   tooltip: 'Download',
    //   onPressed: () async {
          
       
    //   },
    // ): const SizedBox(),
      ],
      leading: backbutton == true
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
      title: Row(
        children: [
          Text(title,
              style: AppStyles.appBarTitle(context, AppColors.onPrimary)),
        ],
      ),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(
        color: AppColors.onPrimary,
      ),
    );
    
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}


Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear all saved preferences, including login state
  Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
}
