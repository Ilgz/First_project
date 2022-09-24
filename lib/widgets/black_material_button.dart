import 'package:flutter/material.dart';

class BlackMaterialButton extends StatefulWidget {
  final Function onClick;
  final String buttonName;
  final bool enabled;
  final bool loading;
  const BlackMaterialButton(
      {required this.buttonName,
      required this.onClick,
      required this.enabled,
      required this.loading});
  @override
  State<BlackMaterialButton> createState() => BlackMaterialButtonState();
}

class BlackMaterialButtonState extends State<BlackMaterialButton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87.withOpacity(opacityForSubmitButton()),
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashFactory: _enabledSplash(),
          onTap: () {
            if (widget.enabled) {
              widget.onClick();
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: Container(
              width: double.infinity,
              height: 50,
              child: Center(child: loadButtonText()))),
    );
  }

  InteractiveInkFeatureFactory _enabledSplash() {
    if (!widget.enabled) {
      return NoSplash.splashFactory;
    } else {
      return InkSplash.splashFactory;
    }
  }

  double opacityForSubmitButton() {
    if (!widget.enabled) {
      return 0.7;
    } else {
      return 1;
    }
  }

  Widget loadButtonText() {
    if (widget.loading) {
      return SizedBox(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
        height: 20.0,
        width: 20.0,
      );
    } else {
      return Text(
        widget.buttonName,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      );
    }
  }
}
