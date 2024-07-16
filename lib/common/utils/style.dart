import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var colorPrimaryRed = const Color(0xFFEB5353);

var colorDisabledGray = HexColor("#BDBDBD");
var colorDisabledGrayText = HexColor("#8A8A8A");

final lexend13regular = GoogleFonts.lexend(
  fontSize: 13,
  fontWeight: FontWeight.w300,
);

final lexendDeca14regularW600 = GoogleFonts.lexendDeca(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

final lexend13regularw300 = GoogleFonts.lexend(
  fontSize: 13,
  fontWeight: FontWeight.w300,
  color: const Color(0xFFADADAD),
);

final lexend13regularw600 = GoogleFonts.lexend(
  fontSize: 13,
  fontWeight: FontWeight.w600,
);

final lexend13w600 = GoogleFonts.lexend(
  fontSize: 13,
  fontWeight: FontWeight.w600,
);

final lexendDeca23w500 = GoogleFonts.lexendDeca(
  fontWeight: FontWeight.w500,
  fontSize: 23.0,
  color: Colors.black,
);

final lexendDeca17w500 = GoogleFonts.lexendDeca(
  fontWeight: FontWeight.w500,
  fontSize: 17.0,
  color: Colors.black,
);

final lexendDeca17w500White = GoogleFonts.lexendDeca(
  fontWeight: FontWeight.w500,
  fontSize: 17.0,
  color: Colors.white,
);

final lexendDeca16w300 = GoogleFonts.lexendDeca(
  fontWeight: FontWeight.w300,
  fontSize: 15.0,
  color: Colors.black,
);

final lexendDeca12w700 = GoogleFonts.lexendDeca(
  color: Colors.black,
  fontWeight: FontWeight.w700,
  fontSize: 12.0,
);

final lexendDeca12w700Red = GoogleFonts.lexendDeca(
  color: colorPrimaryRed,
  fontWeight: FontWeight.w700,
  fontSize: 12.0,
);

final lexendDeca12BoldUnderline = GoogleFonts.lexendDeca(
  color: const Color(0xFFA6262E),
  fontWeight: FontWeight.bold,
  fontSize: 12.0,
  decoration: TextDecoration.underline,
);

final lexendDeca10w600 = GoogleFonts.lexendDeca(
  color: const Color(0xFFFE7B82),
  fontSize: 10,
  fontWeight: FontWeight.w600,
);

final lexendDeca10w700White = GoogleFonts.lexendDeca(
  color: Colors.white,
  fontWeight: FontWeight.w700,
  fontSize: 10.0,
);

final lexendDeca20w500White = GoogleFonts.lexendDeca(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 20.0,
);

final ibmplexSerif16w300 = GoogleFonts.ibmPlexSerif(
  color: Colors.black,
  fontWeight: FontWeight.w300,
  fontSize: 16.0,
);

final ibmplexSerif16Bold = GoogleFonts.ibmPlexSerif(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
);

final ibmplexSerif16w600 = GoogleFonts.ibmPlexSerif(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 16.0,
);

final imFellEnglish23w400 = GoogleFonts.imFellEnglish(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 23,
);

const sizedBox0 = SizedBox();
const sizedBox10 = SizedBox(
  height: 10,
);

const sizedBox20 = SizedBox(
  height: 20,
);

const sizedBox50 = SizedBox(
  height: 50,
);

const sizedBox5 = SizedBox(
  height: 5,
);

// Hex code settings
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
