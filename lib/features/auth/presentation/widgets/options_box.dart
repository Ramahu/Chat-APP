import 'package:flutter/material.dart';

import '../../../../core/responsive_ui.dart';

Widget optionsBox({
  required context,
  Color? imgColor ,
  required Color borderColor ,
  required String? imagePath,
  required Function? onPressed
}){
  return InkWell(
    onTap: (){
      onPressed!();
    },
    child: Container(
        height:Responsive.heightMultiplier(context) * 7,
        margin: const EdgeInsets.only(top: 0 , bottom: 20 , left: 10 ,right: 10  ),
        width:  Responsive.width(context) * 0.15,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child:  Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(imagePath!, color: imgColor,))
    ),
  );
}