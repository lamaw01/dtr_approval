// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'data/approved_provider.dart';
import 'data/approver_provider.dart';
import 'data/department_provider.dart';
import 'data/disapproved_provider.dart';
import 'data/for_approval_provider.dart';
import 'data/selfies_provider.dart';
import 'data/version_provider.dart';
import 'view/login_view.dart';
import 'view/side_view.dart';

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
      // home: const LoginView(),
      home: const AuthWrapper(),
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

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      String? loginInfo = prefs.getString('login_info');
      if (loginInfo == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SideView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading..'),
      ),
      // body: const Center(
      //   child: CircularProgressIndicator(),
      // ),
      body: StreamBuilder(
        stream: Stream.value('ok'),
        builder: (context, snapshot) {
          return const SideView();
        },
      ),
    );
  }
}
