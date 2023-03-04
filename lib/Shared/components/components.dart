import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultTFF({
  var key,
  double height = 50,
  double width = double.infinity,
  TextEditingController? textEditingController,
  String label = "",
  String hint = "",
  String? initialValue,
  InputBorder inputBorder = const OutlineInputBorder(),
  TextInputAction? textInputAction,
  bool isPass = false,
  bool showCursor = true,
  bool autocorrect = false,
  bool autofocus = false,
  bool enableInteractiveSelection = true,
  bool enabled = true,
  TextInputType kbType = TextInputType.text,
  IconData? prefixIcon,
  Widget? suffixIcon,
  FocusNode? focusNode,
  void Function(String)? onChange,
  void Function(String)? onSubmit,
  void Function()? onTap,
  void Function()? onEditingComplete,
  String? Function(String? value)? validator,
}) =>
    TextFormField(
      key: key,

      focusNode: focusNode,

      selectionControls: MaterialTextSelectionControls(),

      cursorRadius: const Radius.circular(60),

      initialValue: initialValue,
      // Not to be assigned along side with the controller

      autofocus: autofocus,

      textAlignVertical: TextAlignVertical.center,

      onEditingComplete: onEditingComplete,

      textInputAction: textInputAction,

      enabled: enabled,

      obscuringCharacter: "#",
      // pretty nice

      showCursor: showCursor,

      enableInteractiveSelection: enableInteractiveSelection,

      controller: textEditingController,

      obscureText: isPass,

      keyboardType: kbType,

      decoration: InputDecoration(
        hintText: hint == "" ? null : hint,
        labelText: label == "" ? null : label,
        border: inputBorder,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
      ),

      onChanged: onChange,

      onFieldSubmitted: onSubmit,

      validator: validator,

      onTap: onTap,
    );

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => widget), (Route<Object?> route) => false);
}

void toast({
  required BuildContext context,
  required String msg,
  ToastState toastState = ToastState.toastDefault,
  Duration toastDuration = const Duration(seconds: 3),
  ToastGravity gravity = ToastGravity.BOTTOM,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) {
  FToast().init(context).showToast(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: ShapeDecoration(color: toastColor(toastState), shape: const StadiumBorder()),
            child: Text(
              msg,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ),
        ),
        // gravity: gravity,
        toastDuration: toastDuration,
      );
}

enum ToastState { toastDefault, success, warning, error }

Color toastColor(ToastState toastState) {
  switch (toastState) {
    case ToastState.success:
      return const Color(0xFF1D7238);
    case ToastState.error:
      return const Color(0xFF980B0B);
    case ToastState.warning:
      return const Color(0xFFFF7338);
    default:
      return const Color(0xFF6B6A6A);
  }
}
