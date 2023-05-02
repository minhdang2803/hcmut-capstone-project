import 'dart:io';

import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/data_source/local/auth_local_source.dart';
import '../../../../data/models/authentication/user.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final authLocal = GetIt.I.get<AuthLocalSourceImpl>();
  // ignore: prefer_typing_uninitialized_variables
  File? _image;

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = authLocal.getCurrentUser()?.fullName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: "Cập nhật thông tin",
              onBackButtonPress: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    CircleAvatar(
                      backgroundColor: AppColor.appBackground,
                      radius: 50,
                      backgroundImage: NetworkImage(
                          authLocal.getCurrentUser()?.photoUrl ?? ""),
                      child: _image == null &&
                              authLocal.getCurrentUser()?.photoUrl == null
                          ? const Icon(Icons.person, size: 50)
                          // :  _image == null && authLocal.getCurrentUser()?.photoUrl != null?
                          // Image.network(
                          //   authLocal.getCurrentUser()?.photoUrl??"",
                          //   width: 50.r,
                          //   height: 50.r,
                          //   fit: BoxFit.cover,
                          //   errorBuilder: (context, error, stackTrace) {
                          //     return Image.asset(
                          //       'assets/images/peace.png',
                          //       width: 80.r,
                          //       height: 80.r,
                          //       fit: BoxFit.cover,
                          //     );
                          //   },
                          // )
                          : null,
                    ),
                    SizedBox(height: 16.r),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 32.r),
                      child: CustomTextField(
                        hintText: authLocal.getCurrentUser()?.fullName ?? '',
                        controller: _nameController,
                      ),
                    ),
                    SizedBox(height: 16.r),
                    QuizButton(
                      onTap: () {
                        String name = _nameController.text.trim();
                        authLocal.saveCurrentUser(
                            AppUser(
                                fullName: name, photoUrl: _image?.path ?? ''),
                            '');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cập nhật thông tin thành công!"),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      text: "Lưu thông tin",
                      width: 200.w,
                      height: 40.h,
                      backgroundColor: AppColor.secondary,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// _image != null
//                     ? FileImage(_image!)
//                     : FileImage(
//                         File(authLocal.getCurrentUser()?.photoUrl ?? ""))