// lib/ui/screens/note_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/controllers/note_controller.dart';
import 'package:inkwell/routes/app_routes.dart';
import 'package:inkwell/ui/widgets/note_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NoteListScreen extends StatelessWidget {
  final NoteController controller = Get.find<NoteController>();
  AuthController authController = Get.find();

  NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    var notes = controller.notes;
    print('this is a note list length: ${notes.length}');
    return GetBuilder<Controller>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Get.theme.colorScheme.background,
          appBar: CustomAppBar(
            title: 'Inkwell',
            searchController: controller.searchController,
            onSearch: () {
              controller.searchNotes(controller.searchController.text);
              // Implement your search logic here
            },
            onOpenDrawer: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.noteDetail),
            child: const Icon(Icons.note_add),
          ),
          body: notes.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  height: Get.height - 100,
                  width: Get.width,
                  child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return NoteCard(
                        note: note,
                        onTap: () {
                          controller.titleController.text = '';
                          controller.quillController.clear();
                          Get.toNamed(AppRoutes.noteDetail, arguments: note.id);
                          controller.initializeNote();
                          controller.update();
                        },
                        onDelete: (note) async {
                          print('deleting call');
                          await controller.deleteNote();
                        },
                      );
                    },
                  ),
                ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                CustomUserAccountsDrawerHeader(
                  accountName: 'John Doe',
                  accountEmail: 'johndoe@example.com',
                  currentAccountPictureUrl:
                      'https://media.istockphoto.com/id/1327592506/vector/default-avatar-photo-placeholder-icon-grey-profile-picture-business-man.webp?s=2048x2048&w=is&k=20&c=d1b4VHqWm1Gt8V148JOvaYSnyIvsFZEpGRCxLK-hGU4=',
                  otherAccountsPicturesUrl:
                      'https://example.com/images/other.jpg',
                  onDetailsPressed: () {
                    // Handle details pressed action here
                    print('Details pressed');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.view_list),
                  title: Text('Toggle View Mode'),
                  onTap: () {
                    // Navigator.pop(context);
                    // toggleViewMode();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    authController.logout();
                    // Navigator.pop(context);
                    // onLogout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// lib/ui/widgets/custom_app_bar.dart

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onOpenDrawer;

  CustomAppBar({
    required this.title,
    required this.searchController,
    required this.onSearch,
    required this.onOpenDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => onSearch,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Get.theme.colorScheme.onPrimary,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => searchController.clear(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 68.0);
}

class CustomUserAccountsDrawerHeader extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final String currentAccountPictureUrl;
  final String otherAccountsPicturesUrl;
  final VoidCallback onDetailsPressed;

  const CustomUserAccountsDrawerHeader({
    super.key,
    required this.accountName,
    required this.accountEmail,
    required this.currentAccountPictureUrl,
    required this.otherAccountsPicturesUrl,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text(accountName),
      accountEmail: Text(accountEmail),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(currentAccountPictureUrl),
      ),
      otherAccountsPictures: <Widget>[
        GestureDetector(
          onTap: onDetailsPressed,
          child: CircleAvatar(
            backgroundImage: NetworkImage(otherAccountsPicturesUrl),
          ),
        ),
      ],
      onDetailsPressed: onDetailsPressed,
    );
  }
}
