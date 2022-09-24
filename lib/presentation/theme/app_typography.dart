import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class AppTypography {
  static TextStyle headline = GoogleFonts.nunito(
    fontSize: 20.r,
    color: AppColor.textPrimary,
  );
  static TextStyle title = GoogleFonts.nunito(
    fontSize: 16.r,
    color: AppColor.textPrimary,
  );
  static TextStyle body = GoogleFonts.nunito(
    fontSize: 14.r,
    color: AppColor.textPrimary,
  );
  static TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 12.r,
    color: AppColor.textPrimary,
  );
}
