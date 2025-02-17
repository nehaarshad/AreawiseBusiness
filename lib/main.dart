import 'package:ecommercefrontend/core/utils/routes/routes.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce Seventeen',
        theme: ThemeData(),
        initialRoute: routesName.splash,
        onGenerateRoute: Routes.createroutes,
      ),
    );
  }
}
