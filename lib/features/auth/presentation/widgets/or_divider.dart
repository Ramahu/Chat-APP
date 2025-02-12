import 'package:flutter/material.dart';

import '../../../../core/util/colors.dart';

Widget orDivider()=> Container(
    margin: const EdgeInsets.all(20),
    child:  Stack(
      alignment: Alignment.center,
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 500
            ),
            child: const Divider(thickness: 2,color: grey,)),
        Positioned(
          child: Container(
            decoration: BoxDecoration(
                color: white,
                border: Border.all(color: black),
                borderRadius: BorderRadius.circular(15)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 3),
            child: const Text(
              'OR',
              style: TextStyle(color: black),
            ),
          ),
        )
      ],
    )
);