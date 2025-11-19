
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';

class AuthDialog extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback? onCancel;

  const AuthDialog({
    Key? key,
    required this.onLoginSuccess,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login Required'),
      content: const Text('You need to login to view this product.'),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _navigateToLogin(context);
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

  void _navigateToLogin(BuildContext context) {

    Navigator.pushNamedAndRemoveUntil(context, routesName.login,(route)=>false)
        .then((value) {
            if (value == true) {
              onLoginSuccess();
            }
    });
  }
}