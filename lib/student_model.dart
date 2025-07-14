import 'dart:io';

class Student {
  File? photo;
  String name;
  String gender;
  DateTime birthDate;
  String phone;
  String address;

  Student({
    this.photo,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.address,
  });
}
