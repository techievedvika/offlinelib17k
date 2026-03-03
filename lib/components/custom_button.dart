// ignore_for_file: must_be_immutable

//Custom ButtonClass
import 'package:flutter/material.dart';
import 'package:lib17000ft/configs/color/color.dart';
import 'package:lib17000ft/configs/helper/responsive_helper.dart';

class CustomButton extends StatefulWidget {
  double? height;
  double? width;
  void Function()? onPressedButton;
  String? title;
  IconData? icon;
  Padding? padding;

  CustomButton(
      {super.key, this.height, this.width, this.title, this.onPressedButton,this.icon,this.padding});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return SizedBox(
        height:
            responsive.responsiveValue(small: 60.0, medium: 60.0, large: 65.0),
        width: responsive.responsiveValue(
            small: 190.0, medium: 260.0, large: 280.0),
        child: Center(
          child: ElevatedButton(
  style: AppStyles.primaryButtonStyle(context, AppColors.primary),
  onPressed: widget.onPressedButton,
  child: Row(
    mainAxisSize: MainAxisSize.min, // Ensures the button doesn't take unnecessary space
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        widget.title!,
        style: AppStyles.buttonText(context, AppColors.onPrimary),
      ),
      const SizedBox(width: 8), // Adds some spacing between text and icon
      widget.icon !=  null ?
      Icon(widget.icon,color: AppColors.onPrimary) : const SizedBox(),
    ],
  ),
)

          // style:ElevatedButton.styleFrom(backgroundColor: AppColors.mainBackground,elevation: 3,), child: Text(title!),
        ));
  }
}

class CustomSmallButton extends StatefulWidget {
  double? height;
  double? width;
  Function onPressedButton;
  String? title;

  CustomSmallButton(
      {super.key,
      this.height,
      this.width,
      this.title,
      required this.onPressedButton});

  @override
  State<CustomSmallButton> createState() => _CustomSmallButtonState();
}

class _CustomSmallButtonState extends State<CustomSmallButton> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return SizedBox(
        height:
            responsive.responsiveValue(small: 55.0, medium: 50.0, large: 65.0),
        width: responsive.responsiveValue(
            small: 100.0, medium: 150.0, large: 200.0),
        child: Center(
          child: ElevatedButton(
            style: AppStyles.smallButtonStyle(context, AppColors.primary),
            onPressed: () => widget.onPressedButton(),
            child: Text(
              widget.title!,
              style: AppStyles.smallButtonText(context, AppColors.onPrimary),
            ),
          ),
          // style:ElevatedButton.styleFrom(backgroundColor: AppColors.mainBackground,elevation: 3,), child: Text(title!),
        ));
  }
}
