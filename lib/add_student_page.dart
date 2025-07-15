import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'student_model.dart';

class AddStudentPage extends StatefulWidget {
  final Function(Student) onStudentAdded;
  final Student? initialStudent;
  const AddStudentPage({
    super.key,
    required this.onStudentAdded,
    this.initialStudent,
  });

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  String? _photo;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _gender;
  DateTime? _birthDate;
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _fakultasController = TextEditingController();
  final _jurusanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialStudent != null) {
      final s = widget.initialStudent!;
      _photo = s.photoPath;
      _nameController.text = s.name;
      _gender = s.gender;
      _birthDate = s.birthDate;
      _phoneController.text = s.phone;
      _addressController.text = s.address;
      _nimController.text = s.nim;
      _emailController.text = s.email;
      _fakultasController.text = s.fakultas;
      _jurusanController.text = s.jurusan;
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _photo = picked.path;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() &&
        _gender != null &&
        _birthDate != null) {
      final student = Student(
        photoPath: _photo,
        name: _nameController.text,
        gender: _gender!,
        birthDate: _birthDate!,
        phone: _phoneController.text,
        address: _addressController.text,
        nim: _nimController.text,
        email: _emailController.text,
        fakultas: _fakultasController.text,
        jurusan: _jurusanController.text,
      );
      await widget.onStudentAdded(student);
      Navigator.pop(context, true); // pop with result true
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(
          widget.initialStudent == null ? 'Tambah Mahasiswa' : 'Edit Mahasiswa',
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 40,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 420,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: CircleAvatar(
                                    radius: 48,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage:
                                        _photo != null
                                            ? FileImage(File(_photo!))
                                            : null,
                                    child:
                                        _photo == null
                                            ? const Icon(
                                              Icons.camera_alt,
                                              size: 36,
                                              color: Colors.black26,
                                            )
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nama',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null || v.isEmpty
                                              ? 'Nama wajib diisi'
                                              : null,
                                ),
                                const SizedBox(height: 18),
                                DropdownButtonFormField<String>(
                                  value: _gender,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Laki-laki',
                                      child: Text('Laki-laki'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Perempuan',
                                      child: Text('Perempuan'),
                                    ),
                                  ],
                                  onChanged: (v) => setState(() => _gender = v),
                                  decoration: InputDecoration(
                                    labelText: 'Jenis Kelamin',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null
                                              ? 'Pilih jenis kelamin'
                                              : null,
                                ),
                                const SizedBox(height: 18),
                                InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          _birthDate ?? DateTime(2000, 1, 1),
                                      firstDate: DateTime(1970),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      setState(() => _birthDate = picked);
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Tanggal Lahir',
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: Text(
                                      _birthDate == null
                                          ? 'Pilih tanggal'
                                          : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  controller: _nimController,
                                  decoration: InputDecoration(
                                    labelText: 'NIM',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null || v.isEmpty
                                              ? 'NIM wajib diisi'
                                              : null,
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null || v.isEmpty
                                              ? 'Email wajib diisi'
                                              : null,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  controller: _fakultasController,
                                  decoration: InputDecoration(
                                    labelText: 'Fakultas',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null || v.isEmpty
                                              ? 'Fakultas wajib diisi'
                                              : null,
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  controller: _jurusanController,
                                  decoration: InputDecoration(
                                    labelText: 'Jurusan',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null || v.isEmpty
                                              ? 'Jurusan wajib diisi'
                                              : null,
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Telepon',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator:
                                      (v) =>
                                          v == null || v.isEmpty
                                              ? 'Telepon wajib diisi'
                                              : null,
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Alamat',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null || v.isEmpty
                                              ? 'Alamat wajib diisi'
                                              : null,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  height: 54,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      elevation: 6,
                                    ),
                                    onPressed: _submit,
                                    child: Text(
                                      widget.initialStudent == null
                                          ? 'Simpan'
                                          : 'Update',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
