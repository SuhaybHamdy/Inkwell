import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import '../../controllers/note_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/util.dart';

class CustomDrawer extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesController>(
      builder: (logic) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('John Doe'),
                accountEmail: Text('johndoe@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://media.istockphoto.com/id/1327592506/vector/default-avatar-photo-placeholder-icon-grey-profile-picture-business-man.webp?s=2048x2048&w=is&k=20&c=d1b4VHqWm1Gt8V148JOvaYSnyIvsFZEpGRCxLK-hGU4='),
                ),
                otherAccountsPictures: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://example.com/images/other.jpg'),
                  ),
                ],
                onDetailsPressed: () {
                  print('Details pressed');
                },
              ),
              ListTile(
                leading: Icon(Icons.view_list),
                title: Text('List View'),
                onTap: () {
                  logic.toggleViewMode(ViewMode.list);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.grid_view),
                title: Text('Grid View'),
                onTap: () {
                  logic.toggleViewMode(ViewMode.grid);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Day View'),
                onTap: () {
                  logic.toggleViewMode(ViewMode.calendar);

                  logic.changeCalendarFormat(CustomCalendarFormat.day);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_view_week),
                title: Text('Week View'),
                onTap: () {
                  logic.toggleViewMode(ViewMode.calendar);

                  logic.changeCalendarFormat(CustomCalendarFormat.week);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_view_month),
                title: Text('Month View'),
                onTap: () {
                  // ViewMode.calendar
                   logic.toggleViewMode(ViewMode.calendar);
                  logic.changeCalendarFormat(CustomCalendarFormat.month);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_6),
                title: Text('Toggle Theme'),
                onTap: () {
                  // Get.find<ThemeController>().toggleTheme();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Get.toNamed(AppRoutes.settings);
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () async {

                  // Navigate to about screen
                  // Get.toNamed(AppRoutes.about);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  controller.logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
