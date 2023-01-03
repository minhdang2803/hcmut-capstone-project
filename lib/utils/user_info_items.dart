import 'package:flutter/material.dart';

class UserInfoItems {
  static final List<DropdownMenuItem<String>> gender = [
    const DropdownMenuItem<String>(
      value: '1',
      alignment: Alignment.center,
      child: Text('Nam'),
    ),
    const DropdownMenuItem<String>(
      value: '2',
      alignment: Alignment.center,
      child: Text('Nữ'),
    ),
    const DropdownMenuItem<String>(
      value: '3',
      alignment: Alignment.center,
      child: Text('Khác'),
    ),
  ];

  static final List<DropdownMenuItem<String>> maritalStatus = [
    const DropdownMenuItem<String>(
      value: '1',
      alignment: Alignment.center,
      child: Text('Đã kết hôn'),
    ),
    const DropdownMenuItem<String>(
      value: '2',
      alignment: Alignment.center,
      child: Text('Chưa kết hôn'),
    ),
  ];

  static final List<DropdownMenuItem<String>> academicRankList = [
    const DropdownMenuItem<String>(
      value: '1',
      alignment: Alignment.center,
      child: Text('Giáo sư'),
    ),
    const DropdownMenuItem<String>(
      value: '2',
      alignment: Alignment.center,
      child: Text('Phó giáo sư'),
    ),
  ];

  static final List<DropdownMenuItem<String>> degree = [
    const DropdownMenuItem<String>(
      value: '1',
      alignment: Alignment.center,
      child: Text('Thạc sĩ'),
    ),
    const DropdownMenuItem<String>(
      value: '2',
      alignment: Alignment.center,
      child: Text('Tiến sĩ'),
    ),
    const DropdownMenuItem<String>(
      value: '3',
      alignment: Alignment.center,
      child: Text('Bác sĩ'),
    ),
    const DropdownMenuItem<String>(
      value: '4',
      alignment: Alignment.center,
      child: Text('Thạc sĩ bác sĩ'),
    ),
    const DropdownMenuItem<String>(
      value: '5',
      alignment: Alignment.center,
      child: Text('Tiến sĩ bác sĩ'),
    ),
  ];
}
