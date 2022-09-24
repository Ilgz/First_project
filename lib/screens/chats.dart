import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Container(
          height: AppBar().preferredSize.height,
          color: Colors.transparent,
          width: double.infinity,
          child: IntrinsicHeight(
            child: Stack(children: [
              Align(
                  child: Text(
                'Сообщения',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
            ]),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Нет сообщений",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
                textAlign: TextAlign.center,
                "Договаривайтесь о покупке или продаже товаров в сообщениях"),
          ],
        ),
      ],
    )));
  }
}
