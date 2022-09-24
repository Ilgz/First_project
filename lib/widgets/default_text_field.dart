import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:second_project/helper.dart';

class DefaultTextField extends StatefulWidget {
  final Function onChange;
  final TextEditingController myController;
  final String hintText;
  final int color;
  final bool isPassword;
  final bool isNumber;
  const DefaultTextField(
      {required this.myController,
      required this.hintText,
      required this.onChange,
      required this.color,
      this.isPassword = true,
      this.isNumber = false});

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  bool isObscured = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(widget.color)),
          borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: _myInputType(),
              obscureText: isObscured,
              controller: widget.myController,
              onChanged: (text) {
                widget.onChange(text);
              },
              style: TextStyle(
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
          Visibility(
            visible: widget.isPassword,
            child: Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isObscured) {
                          isObscured = false;
                        } else {
                          isObscured = true;
                        }
                      });
                    },
                    icon: !isObscured
                        ? Icon(Icons.visibility_outlined)
                        : Icon(Icons.visibility_off_outlined))),
          ),
        ],
      ),
    );
  }

  TextInputType _myInputType() {
    if (widget.isNumber == true) {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }
}
