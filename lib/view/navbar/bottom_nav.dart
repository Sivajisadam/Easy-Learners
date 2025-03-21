import 'package:easy_learners/_controllers/bottom_nav_controller.dart';
import 'package:easy_learners/view/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/iconoir.dart';
import 'package:iconify_flutter_plus/icons/majesticons.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';

class BottomNav extends GetWidget<BottomNavController> {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool result, _) {
            if (controller.currentIndex.value != 0) {
              controller.changeIndex(0);
            } else {
              // exit(0);
            }
          },
          child: Scaffold(
            body: controller.pages[controller.currentIndex.value],
            bottomNavigationBar: BottomNavigationBar(
              onTap: controller.changeIndex,
              currentIndex: controller.currentIndex.value,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Iconify(
                    MaterialSymbols.home_rounded,
                    color: controller.currentIndex.value == 0
                        ? ColorConstants.primaryColor
                        : Colors.black38,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Iconify(
                    Tabler.triangle_square_circle,
                    color: controller.currentIndex.value == 1
                        ? ColorConstants.primaryColor
                        : Colors.black38,
                  ),
                  label: 'Assistant',
                ),
                BottomNavigationBarItem(
                    icon: Iconify(
                      Majesticons.map_marker,
                      color: controller.currentIndex.value == 2
                          ? ColorConstants.primaryColor
                          : Colors.black38,
                    ),
                    label: 'Maps'),
                BottomNavigationBarItem(
                  icon: Iconify(
                    Iconoir.settings_profiles,
                    color: controller.currentIndex.value == 3
                        ? ColorConstants.primaryColor
                        : Colors.black38,
                  ),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: ColorConstants.primaryColor,
              unselectedItemColor: Colors.grey[600],
              unselectedLabelStyle: TextStyle(color: Colors.grey[600]),
              // unselectedLabelStyle:
              //     TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ));
  }
}
