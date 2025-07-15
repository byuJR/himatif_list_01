import 'package:hive/hive.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String? photoPath;
  @HiveField(1)
  String name;
  @HiveField(2)
  String gender;
  @HiveField(3)
  DateTime birthDate;
  @HiveField(4)
  String phone;
  @HiveField(5)
  String address;
  @HiveField(6)
  String nim;
  @HiveField(7)
  String email;
  @HiveField(8)
  String fakultas;
  @HiveField(9)
  String jurusan;

  Student({
    this.photoPath,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.address,
    required this.nim,
    required this.email,
    required this.fakultas,
    required this.jurusan,
  });
}
