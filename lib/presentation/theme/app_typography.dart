import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class AppTypography {
  static TextStyle superHeadline = GoogleFonts.montserrat(
    fontSize: 26.r,
    color: AppColor.textPrimary,
  );
  static TextStyle headline = GoogleFonts.montserrat(
    fontSize: 20.r,
    color: AppColor.textPrimary,
  );
  static TextStyle subHeadline = GoogleFonts.montserrat(
    fontSize: 18.r,
    color: AppColor.textPrimary,
  );
  static TextStyle title = GoogleFonts.montserrat(
    fontSize: 16.r,
    color: AppColor.textPrimary,
  );
  static TextStyle body = GoogleFonts.montserrat(
    fontSize: 14.r,
    color: AppColor.textPrimary,
  );
  static TextStyle bodySmall = GoogleFonts.montserrat(
    fontSize: 12.r,
    color: AppColor.textPrimary,
  );
}
