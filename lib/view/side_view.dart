import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/approved_provider.dart';
import '../data/department_provider.dart';
import '../data/disapproved_provider.dart';
import '../data/for_approval_provider.dart';
import '../data/selfies_provider.dart';
import '../data/version_provider.dart';
import 'approved_view.dart';
import 'disapproved_view.dart';
import 'for_approval_view.dart';
import 'home_view.dart';

class SideView extends StatefulWidget {
  const SideView({super.key});

  @override
  State<SideView> createState() => _SideViewState();
}

class _SideViewState extends State<SideView> {
  SideMenuController sideMenu = SideMenuController();
  int _currentIndex = 0;
  final menuPages = <Widget>[
    const HomeView(),
    const ForApprovalView(),
    const ApprovedView(),
    const DisapprovedView(),
  ];

  @override
  void initState() {
    final version = Provider.of<VersionProvider>(context, listen: false);
    final department = Provider.of<DepartmentProvider>(context, listen: false);
    final selfies = Provider.of<SelfiesProvider>(context, listen: false);
    final forapproval =
        Provider.of<ForApprovalProvider>(context, listen: false);
    final approved = Provider.of<ApprovedProvider>(context, listen: false);
    final disapproved =
        Provider.of<DisapprovedProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await version.getPackageInfo();
      await department.getDepartment();
      await selfies.getSelfiesAll(department.dropdownValue);
      await forapproval.getForApproval();
      await approved.getApproved();
      await disapproved.getDisapproved();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      SideMenuItem(
        title: 'Home',
        onTap: (index, _) {
          setState(() {
            _currentIndex = index;
            sideMenu.changePage(index);
          });
        },
        icon: const Icon(Icons.home),
      ),
      SideMenuItem(
        title: 'For approval',
        onTap: (index, _) {
          setState(() {
            _currentIndex = index;
            sideMenu.changePage(index);
          });
        },
        icon: const Icon(Icons.access_time),
      ),
      SideMenuItem(
        title: 'Approved',
        onTap: (index, _) {
          setState(() {
            _currentIndex = index;
            sideMenu.changePage(index);
          });
        },
        icon: const Icon(Icons.check),
      ),
      SideMenuItem(
        title: 'Disapproved',
        onTap: (index, _) {
          setState(() {
            _currentIndex = index;
            sideMenu.changePage(index);
          });
        },
        icon: const Icon(Icons.close),
      ),
    ];

    const String title = 'UC-1 DTR Selfie Approval';
    final version = Provider.of<VersionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(title),
            const SizedBox(
              width: 2.5,
            ),
            Text(
              "v${version.version}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            // onDisplayModeChanged: (mode) {},
            items: menuItems,
            style: SideMenuStyle(
              backgroundColor: Colors.grey[300],
              itemInnerSpacing: 16.0,
              iconSize: 16.0,
              itemOuterPadding: EdgeInsets.zero,
              openSideMenuWidth: 160.0,
            ),
          ),
          Expanded(
            child: menuPages.elementAt(_currentIndex),
          ),
        ],
      ),
    );
  }
}
