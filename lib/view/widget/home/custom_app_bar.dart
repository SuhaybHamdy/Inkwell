import "package:flutter/material.dart";
import "package:get/get.dart";


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onOpenDrawer;
  final VoidCallback  iaSuggest;

  CustomAppBar({
    required this.title,
    required this.searchController,
    required this.onSearch,
    required this.onOpenDrawer,
    required this.iaSuggest,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),  IconButton(
          icon: const Icon(Icons.settings_suggest_outlined),
          onPressed: iaSuggest,
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 150.0);
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
