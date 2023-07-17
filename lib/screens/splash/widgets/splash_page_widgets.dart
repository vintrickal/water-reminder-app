import 'package:flutter/material.dart';
import 'package:water_reminder_app/common/values/colors.dart';

Widget buildButton(String buttonName, void Function()? func) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: 325,
      height: 50,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryFourthElementText),
          boxShadow: [
            BoxShadow(
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
                color: Colors.grey.withOpacity(0.1))
          ]),
      child: Center(
          child: Text(
        buttonName,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.primaryBackground),
      )),
    ),
  );
}

Widget buildImage(String assetName) {
  return SizedBox(
    width: 200,
    height: 200,
    child: Image.asset(assetName),
  );
}
