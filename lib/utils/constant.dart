import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//--------------------C O L O R S--------------------

const Color kBgcolor = Color(0xfffffffff);

const Color kLightGreencolor = Color(0xffEFFFF0);

const Color kGreencolor = Color(0xff7be285);

const Color kPurplecolor = Color(0xffDFD3FB);



//--------------------S T Y L E S--------------------

TextStyle kErrorStyle = GoogleFonts.spaceMono(
  color: Colors.white,
  fontSize: 16,
);
TextStyle kCounterStyle = GoogleFonts.spaceMono(
  color: Colors.white,
  fontSize: 40,
);

TextStyle kOnBoardTitleStyle = GoogleFonts.spaceMono(
    color: Colors.white, fontSize: 40, fontWeight: FontWeight.w500);

TextStyle kHintStyle = GoogleFonts.spaceMono(
  color: Colors.grey,
  fontSize: 16,
);

//--------------------G R A D I E N T S--------------------

const Gradient kGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [kLightGreencolor, kGreencolor]);