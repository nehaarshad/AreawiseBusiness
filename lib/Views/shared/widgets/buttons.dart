import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color = Colors.blue;
  final Color textColor = Colors.white;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: Appcolors.blueColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child:
              isLoading
                  ? CircularProgressIndicator(color: Appcolors.whiteColor)
                  : Text(text, style: TextStyle(color: Appcolors.whiteColor)),
        ),
      ),
    );
  }
}
