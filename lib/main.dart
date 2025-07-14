import 'dart:async';
import 'package:flutter/material.dart';
import 'student_model.dart';
import 'add_student_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blur/blur.dart';
import 'student_detail_page.dart';
import 'dart:ui';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        primaryColor: Colors.black,
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: const Color(0xFF232323),
          background: const Color(0xFFF7F7F7),
        ),
        cardColor: Colors.white.withOpacity(0.85),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan gambar/logo nanti
            Icon(Icons.school, size: 80, color: Colors.black),
            const SizedBox(height: 24),
            const Text(
              "Student Management",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Now it’s easy to manage student data",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  void _login() {
    // Username dan password statis
    if (_usernameController.text == 'admin' &&
        _passwordController.text == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        _error = 'Username atau password salah';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login Admin',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Student> _students = [];

  void _addStudent(Student student) {
    setState(() {
      _students.add(student);
    });
  }

  void _editStudent(int index, Student newStudent) {
    setState(() {
      _students[index] = newStudent;
    });
  }

  void _deleteStudent(int index) {
    setState(() {
      _students.removeAt(index);
    });
  }

  void _openDetail(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StudentDetailPage(
              student: _students[index],
              onEdit: () {
                Navigator.pop(context, 'edit');
              },
              onDelete: () {
                Navigator.pop(context, 'delete');
              },
            ),
      ),
    );
    if (result == 'edit') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => AddStudentPage(
                onStudentAdded: (student) {
                  _editStudent(index, student);
                },
                initialStudent: _students[index],
              ),
        ),
      );
    } else if (result == 'delete') {
      _deleteStudent(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          if (_students.isEmpty) {
            return Center(
              child: Text(
                'Belum ada data mahasiswa',
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
            ).frosted(
              blur: 8,
              borderRadius: BorderRadius.circular(24),
              padding: const EdgeInsets.all(32),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 2 : 1,
                childAspectRatio: isTablet ? 2.8 : 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return GestureDetector(
                  onTap: () => _openDetail(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
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
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                    student.photo != null
                                        ? FileImage(student.photo!)
                                        : null,
                                child:
                                    student.photo == null
                                        ? const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.black26,
                                        )
                                        : null,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      student.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xFF232323),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      student.gender,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF6D6D6D),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Lahir: ${student.birthDate.day}/${student.birthDate.month}/${student.birthDate.year}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6D6D6D),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Telp: ${student.phone}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6D6D6D),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      student.address,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6D6D6D),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 28,
                                    ),
                                    onPressed: () => _deleteStudent(index),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: 72,
        width: 72,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AddStudentPage(onStudentAdded: _addStudent),
              ),
            );
          },
          child: const Icon(Icons.add, size: 36, weight: 800),
        ),
      ),
    );
  }
}
