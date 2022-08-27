import 'dart:ffi';

import 'package:flutter/material.dart';

dynamic showsnackBar({required BuildContext context, required String message}) {
  final snackBar = SnackBar(
    backgroundColor: Theme.of(context).primaryColor,
    content: Text(
      message,
      style: Theme.of(context).textTheme.headline4,
    ),
    action: SnackBarAction(
      label: 'Undo',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showDialogAlert(
    {required BuildContext context, required List<String> info}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Text(info[0]),
      content: Column(
        children: [Text(info[1])],
      ),
    ),
  );
}

Widget buildThemeButton(BuildContext context,
    {required String title,
    required Color color,
    double? elevation,
    TextStyle? textStyle,
    double? width,
    double? height,
    required void Function()? function}) {
  return SizedBox(
    height: height,
    width: width ?? MediaQuery.of(context).size.width,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double?>(elevation),
        backgroundColor: MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      onPressed: function,
      child: Text(
        title,
        style: textStyle ??
            Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
      ),
    ),
  );
}
