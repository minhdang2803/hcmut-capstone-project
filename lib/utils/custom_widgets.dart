import 'package:capstone_project_hcmut/view_models/theme_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

dynamic showsnackBar({required BuildContext context, required String message}) {
  final snackBar = SnackBar(
    backgroundColor: Theme.of(context).primaryColor,
    content: Text(
      message,
      style: Theme.of(context).textTheme.headline4?.copyWith(
            color: Theme.of(context).backgroundColor,
            fontWeight: FontWeight.normal,
          ),
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
    {required BuildContext context,
    required String title,
    required String message,
    required String buttonText,
    required void Function()? onPressed}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline3!.copyWith(
              fontWeight: FontWeight.normal,
            ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            buildThemeButton(
              context,
              widget: Text(
                buttonText,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).backgroundColor),
              ),
              color: Theme.of(context).primaryColor,
              function: onPressed,
            )
          ],
        ),
      ),
    ),
  );
}

Widget buildThemeButton(BuildContext context,
    {required Widget widget,
    required Color color,
    double? elevation,
    double? width,
    double? height,
    double? borderRadius,
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
            borderRadius: BorderRadius.circular(borderRadius ?? 18.0),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      onPressed: function,
      child: widget,
    ),
  );
}

Widget buildThemeTextFormField(
  BuildContext context,
  Size size, {
  required String hintText,
  required Icon prefixIcon,
  Widget? posfixIcon,
  bool isPassword = false,
  TextEditingController? controller,
  String? Function(String?)? validator,
  void Function(String?)? onSaved,
  void Function(String)? onChanged,
  void Function()? onEditingComplete,
}) {
  return SizedBox(
    width: size.width * 0.9,
    child: TextFormField(
      validator: validator,
      controller: controller,
      autocorrect: false,
      enableSuggestions: false,
      style: Theme.of(context)
          .textTheme
          .headline4!
          .copyWith(decoration: TextDecoration.none),
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 20, bottom: 20),
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).backgroundColor,
          prefixIcon: prefixIcon,
          suffixIcon: posfixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 3,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Theme.of(context).errorColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Theme.of(context).errorColor,
              width: 2,
            ),
          ),
          errorStyle: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: Theme.of(context).errorColor)),
      obscureText: isPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: onSaved,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
    ),
  );
}

Widget buildAuthTopBar(
  BuildContext context,
  Size size, {
  Color color = Colors.black,
  required String title,
  required void Function()? function,
}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: function,
          icon: Icon(
            Icons.arrow_back,
            color: color,
            size: 35,
          ),
        ),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline3
              ?.copyWith(fontWeight: FontWeight.normal, color: color),
        ),
        SizedBox(
          width: size.width * 0.1,
        ),
      ],
    ),
  );
}

Widget buildSignUpProcessBar(BuildContext context, Size size, double process) {
  double value = process == 1 / 3
      ? 1
      : process == 2 / 3
          ? 2
          : 3;
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(left: size.width * 0.8),
        child: Text(
          '${value.toInt()} of 3',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      SizedBox(height: size.height * 0.01),
      Center(
        child: SizedBox(
          width: size.width * 0.9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: process,
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
              minHeight: size.height * 0.01,
            ),
          ),
        ),
      )
    ],
  );
}
