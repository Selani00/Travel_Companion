import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_journal/components/bottom_navigation_bar.dart';

class MyBottonNavigationItem extends StatelessWidget {
  final String iconname;
  final VoidCallback onPressed;
  final String icon;
  final Menus currentItem;
  final Menus name;
  const MyBottonNavigationItem(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.currentItem,
      required this.name,
      required this.iconname});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 40,
        child: IconButton(
          onPressed: () => {
            if (currentItem != name) {onPressed()}
          },
          icon: SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
                currentItem == name ? Colors.amber : Colors.white,
                BlendMode.srcIn),
          ),
        ),
      ),
      Text(iconname,
          style: TextStyle(
              fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
    ]);
  }
}
