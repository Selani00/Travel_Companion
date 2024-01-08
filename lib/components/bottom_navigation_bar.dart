import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_journal/components/app_colors.dart';
import 'package:travel_journal/config/app_images.dart';
import 'package:travel_journal/components/bottom_navigation_item.dart';

enum Menus {
  home,
  weather,
  add,
  map,
  user,
}

class MyBottonNavigation extends StatelessWidget {
  final Menus currentIndex;
  final ValueChanged<Menus> onTap;
  const MyBottonNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(children: [
                Expanded(
                    child: MyBottonNavigationItem(
                        iconname: "Home",
                        onPressed: () => onTap(Menus.home),
                        icon: AppImages.ic_home,
                        currentItem: currentIndex,
                        name: Menus.home)),
                Expanded(
                    child: MyBottonNavigationItem(
                        iconname: "Weather",
                        onPressed: () => onTap(Menus.weather),
                        icon: AppImages.ic_weather,
                        currentItem: currentIndex,
                        name: Menus.weather)),
                const Spacer(),
                Expanded(
                    child: MyBottonNavigationItem(
                        iconname: "Map",
                        onPressed: () => onTap(Menus.map),
                        icon: AppImages.ic_map,
                        currentItem: currentIndex,
                        name: Menus.map)),
                Expanded(
                    child: MyBottonNavigationItem(
                        iconname: "User",
                        onPressed: () => onTap(Menus.user),
                        icon: AppImages.ic_user,
                        currentItem: currentIndex,
                        name: Menus.user)),
              ]),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () => onTap(Menus.add),
              child: SizedBox(
                height: 70,
                child: SvgPicture.asset(
                  AppImages.ic_add,
                  colorFilter: ColorFilter.mode(
                      currentIndex == Menus.add ? Colors.amber : Colors.white,
                      BlendMode.srcIn),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
