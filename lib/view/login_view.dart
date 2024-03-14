// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/approver_provider.dart';
import 'home_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'DTR approval login';
    var usr = TextEditingController();
    var pwd = TextEditingController();

    Future<void> authenticate(
      TextEditingController usr,
      TextEditingController pwd,
    ) async {
      final approvers = Provider.of<ApproversProvider>(context, listen: false);

      final result =
          await approvers.login(emloyeeId: usr.text.trim(), password: pwd.text);

      if (result == Auth.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      } else if (result == Auth.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error username or password'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (result == Auth.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Center(
        child: SizedBox(
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: usr,
                style: const TextStyle(fontSize: 14.0),
                decoration: const InputDecoration(
                  label: Text('username'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                ),
              ),
              const SizedBox(height: 5.0),
              TextField(
                controller: pwd,
                style: const TextStyle(fontSize: 14.0),
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('password'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                ),
                onSubmitted: (value) async {
                  await authenticate(usr, pwd);
                },
              ),
              const SizedBox(height: 10.0),
              Container(
                color: Colors.green[300],
                height: 40.0,
                width: 300.0,
                child: TextButton(
                  onPressed: () async {
                    await authenticate(usr, pwd);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
