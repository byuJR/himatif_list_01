import 'dart:ui';
import 'package:flutter/material.dart';
import 'student_model.dart';
import 'dart:io';
import 'package:hive/hive.dart';

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

  // SnackBar after update data
  static void showUpdateConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data mahasiswa berhasil diupdate!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(title: const Text('Detail Mahasiswa')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // AVATAR
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        student.photoPath != null
                            ? FileImage(File(student.photoPath!))
                            : null,
                    child:
                        student.photoPath == null
                            ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.black26,
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 24),
                // NAMA
                Text(
                  student.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Color(0xFF232323),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // NIM
                Text(
                  student.nim,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6D6D6D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // EMAIL
                Text(
                  student.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6D6D6D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // FAKULTAS & JURUSAN CARD
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Fakultas: ${student.fakultas}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF232323),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Jurusan: ${student.jurusan}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF232323),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // INFO GRID
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(icon: Icons.wc, label: student.gender),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.cake,
                        label:
                            '${student.birthDate.day}/${student.birthDate.month}/${student.birthDate.year}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(icon: Icons.phone, label: student.phone),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.location_on,
                        label: student.address,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          var box = Hive.box<Student>('students');
                          final key = student.key;
                          await box.delete(key);
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        icon: const Icon(Icons.delete, size: 20),
                        label: const Text(
                          'Hapus',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6D6D6D)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Color(0xFF232323)),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
