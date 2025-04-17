import 'package:ecommercefrontend/core/services/splashServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class splashView extends ConsumerStatefulWidget {
  const splashView({super.key});

  @override
  ConsumerState<splashView> createState() => _splashViewState();
}

class _splashViewState extends ConsumerState<splashView> {
  @override
  void initState() {
    super.initState();
    ref.read(splashserviceProvider).checkAuth(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("SPLASH SCREEN")));
  }
}
