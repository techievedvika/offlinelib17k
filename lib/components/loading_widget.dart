import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lib17000ft/configs/color/color.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;

  const LoadingWidget({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: kIsWeb
          ? CircularProgressIndicator(
              color: AppColors.onPrimary,
              strokeCap: StrokeCap.round,
              strokeWidth: size ?? 50,
            )
          : (Theme.of(context).platform == TargetPlatform.android
              ? CircularProgressIndicator(
                  color: AppColors.onPrimary,
                  strokeCap: StrokeCap.round,
                  strokeWidth: size ?? 50,
                )
              : const CupertinoActivityIndicator(
                  color: AppColors.onPrimary,
                )),
    );
  }
}
