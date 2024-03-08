import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'data/approved_provider.dart';
import 'data/approvers_provider.dart';
import 'data/department_provider.dart';
import 'data/disapproved_provider.dart';
import 'data/for_approval_provider.dart';
import 'data/selfies_provider.dart';
import 'data/version_provider.dart';
import 'view/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DepartmentProvider>(
          create: (_) => DepartmentProvider(),
        ),
        ChangeNotifierProvider<SelfiesProvider>(
          create: (_) => SelfiesProvider(),
        ),
        ChangeNotifierProvider<VersionProvider>(
          create: (_) => VersionProvider(),
        ),
        ChangeNotifierProvider<ApprovedProvider>(
          create: (_) => ApprovedProvider(),
        ),
        ChangeNotifierProvider<DisapprovedProvider>(
          create: (_) => DisapprovedProvider(),
        ),
        ChangeNotifierProvider<ForApprovalProvider>(
          create: (_) => ForApprovalProvider(),
        ),
        ChangeNotifierProvider<ApproversProvider>(
          create: (_) => ApproversProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DTR Approval',
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.cyan,
      ),
      home: const LoginView(),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
