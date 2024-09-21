import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_home_app/utils/AppSpaces.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({
    Key? key,
    required this.image,
    required this.text,
    required this.text1,
    required this.onTap,
    this.fontSize = 19,
    this.unSelectedImageColor,
  }) : super(key: key);
  final String image;
  final String text;
  final String text1;

  final VoidCallback onTap;
  final Color? unSelectedImageColor;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: null,
            color: Color.fromARGB(255, 240, 237, 237),
          ),
          child: Column(children: [
            AppSpaces.vertical30,

            //AppSpaces.vertical15,
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: Get.width / 5,
                      height: Get.height / 10,
                      child: Image.asset(
                        image,
                        color: (unSelectedImageColor ?? Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                      inherit: false,
                    ),
                  ),
                  AppSpaces.vertical15,
                ],
              ),
            ),
            Text(
              text1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 161, 4, 4),
                fontSize: 32,
                inherit: false,
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ]),
        ),
      ),
    );
  }
}
