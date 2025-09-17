import 'package:flutter/material.dart';
import 'package:lib17000ft/configs/color/color.dart';

class Confirmation extends StatefulWidget {
  final String? desc;
  final String? title;
  final bool? settle;
  final Function? onPressed;
  final String? yes;
  final String? no;
  final IconData? iconname;

  const Confirmation({
    super.key,
    required this.desc,
    required this.title,
    this.settle,
    required this.onPressed,
    required this.yes,
    this.no,
    required this.iconname,
  });

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: AppColors.primary,
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    Icon(
                      widget.iconname,
                      color: Colors.white,
                      size: 40,
                    ),
                    Container(height: 10),
                    Text(
                      widget.title.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Container(height: 10),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    Text(
                      widget.desc ?? "",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: widget.no != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      child: Text(
                        widget.yes!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        widget.onPressed!();
                        Navigator.of(context).pop();
                      },
                    ),
                    if (widget.no != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Text(
                          widget.no!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}