import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_project/helper.dart';

class OtpEntry extends StatefulWidget {
  final List<TextEditingController> controllers;
  final int defaultErrorColor;
  final Function setErrorColor;
  const OtpEntry(
      {Key? key,
      required this.controllers,
      required this.defaultErrorColor,
      required this.setErrorColor})
      : super(key: key);

  @override
  State<OtpEntry> createState() => OtpEntryState();
}

const zwsp = '\u200b';
const zwspEditingValue = TextEditingValue(
    text: zwsp, selection: TextSelection(baseOffset: 1, extentOffset: 1));

class OtpEntryState extends State<OtpEntry> {
  late List<FocusNode> focusNodes;
  late List<String> code = ['', '', '', '', '', ''];
  bool _reachedEnd = false;
  String otpCode = "";
  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(6, (index) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNodes[0].requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) => otpBoxBuilder(index)));
  }

  Widget otpBoxBuilder(index) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      width: 35,
      child: TextField(
        maxLength: 2,
        onChanged: (value) {
          widget.setErrorColor();
          if (value.length > 1) {
            // this is a new character event
            if (index + 1 == focusNodes.length) {
              _reachedEnd = true;
              for (var i = 0; i < widget.controllers.length; i++) {
                otpCode += widget.controllers[i].text;
              }

              // do something after the last character was inserted
              //FocusScope.of(context).unfocus();
            } else {
              // move to the next field
              focusNodes[index + 1].requestFocus();
            }
          } else {
            // this is backspace event
            // reset the controller
            widget.controllers[index].value = zwspEditingValue;
            if (index == 0) {
              // do something if backspace was pressed at the first field
            } else {
              // go back to previous field
              if (!_reachedEnd == true) {
                widget.controllers[index - 1].value = zwspEditingValue;
                focusNodes[index - 1].requestFocus();
              } else {
                _reachedEnd = false;
              }
            }
          }
          setState(() {});

          // make sure to remove the zwsp character
          code[index] = value.replaceAll(zwsp, '');
        },
        textInputAction: TextInputAction.next,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        keyboardType: TextInputType.number,
        controller: widget.controllers[index],
        focusNode: focusNodes[index],
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: widget.controllers[index].text
                          .replaceAll(zwsp, '')
                          .isEmpty
                      ? Color(widget.defaultErrorColor)
                      : Colors.black87,
                  width: 2))),
    );
  }
}
