import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Home distributeur"),
    );
  }

  @override Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
