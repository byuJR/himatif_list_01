import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'student_model.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const StudentDetailPage({
    super.key,
    required this.student,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Detail Mahasiswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
            tooltip: 'Hapus',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            student.photo != null
                                ? FileImage(student.photo!)
                                : null,
                        child:
                            student.photo == null
                                ? const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.black26,
                                )
                                : null,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF232323),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wc, size: 20, color: Color(0xFF6D6D6D)),
                          const SizedBox(width: 6),
                          Text(
                            student.gender,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6D6D6D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cake, size: 20, color: Color(0xFF6D6D6D)),
                          const SizedBox(width: 6),
                          Text(
                            'Tanggal Lahir: ${student.birthDate.day}/${student.birthDate.month}/${student.birthDate.year}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6D6D6D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, size: 20, color: Color(0xFF6D6D6D)),
                          const SizedBox(width: 6),
                          Text(
                            'Telepon: ${student.phone}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6D6D6D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: Color(0xFF6D6D6D),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Alamat: ${student.address}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF6D6D6D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 6,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit, size: 20),
                            label: const Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 6,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete, size: 20),
                            label: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
