import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../helper.dart';
import '../model/item_product.dart';
import '../screens/profile.dart';
import '../user_product/user_product_bloc.dart';

Widget buildProfile(dynamic user, context, bool isClickable) {
  String idData;
  if (user.phoneNumber != null) {
    idData = "+" +
        user.phoneNumber
            .replaceAllMapped(RegExp(r".{3}"), (match) => "${match.group(0)} ");
  } else {
    idData = user.email;
  }
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    //color: Color(0xfff5f5f5),
    color: Colors.white,
    child: InkWell(
      onTap: () {
        if (isClickable) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GuestProfile(occasion: 1, user: user)));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width-100,
            padding: exceptBottom(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    user.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  idData,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 32,
                )
                // Padding(
                //   padding: EdgeInsets.all(16),
                //   child: Text(
                //     "Местоположение: г.Бишкек",
                //     style: TextStyle(fontSize: 16),
                //   ),
                // )
              ],
            ),
          ),
          Spacer(),

          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 30.0,
              child: user.picture == null
                  ? SvgPicture.asset(
                      "assets/images/user.svg",
                      height: 20,
                      width: 20,
                    )
                  : null,
              backgroundImage: user.picture != null
                  ? Image(
                          image: CachedNetworkImageProvider(
                              user.picture.toString()))
                      .image
                  : null,
              backgroundColor: Colors.grey[300],
            ),
          )
        ],
      ),
    ),
  );
}
