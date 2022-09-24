import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../helper.dart';

class Prototype extends StatefulWidget {
  const Prototype({super.key});

  @override
  State<Prototype> createState() => _PrototypeState();
}

class _PrototypeState extends State<Prototype> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.call), text: "Call"),
                    Tab(icon: Icon(Icons.message), text: "Message"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Text("Ilgiz"),
              Text("Genghis"),
            ],
          ),
        ),
      ),
    );
  }
}
