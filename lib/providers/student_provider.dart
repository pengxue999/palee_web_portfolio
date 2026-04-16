import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:palee_web_portfolio/utils/http_helper.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';

final studentServiceProvider = Provider<StudentService>(
  (_) => StudentService(),
);

class StudentState {
  final List<StudentModel> students;
  final StudentModel? selectedStudent;
  final bool isLoading;
  final String? error;
  final bool reusedExistingStudent;

  const StudentState({
    this.students = const [],
    this.selectedStudent,
    this.isLoading = false,
    this.error,
    this.reusedExistingStudent = false,
  });

  StudentState copyWith({
    List<StudentModel>? students,
    Object? selectedStudent = _studentStateUnset,
    bool? isLoading,
    Object? error = _studentStateUnset,
    bool? reusedExistingStudent,
  }) {
    return StudentState(
      students: students ?? this.students,
      selectedStudent: identical(selectedStudent, _studentStateUnset)
          ? this.selectedStudent
          : selectedStudent as StudentModel?,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _studentStateUnset)
          ? this.error
          : error as String?,
      reusedExistingStudent:
          reusedExistingStudent ?? this.reusedExistingStudent,
    );
  }
}

const _studentStateUnset = Object();

class StudentNotifier extends StateNotifier<StudentState> {
  final StudentService _service;

  StudentNotifier(this._service) : super(const StudentState());

  List<StudentModel> _upsertStudent(StudentModel student) {
    final students = [...state.students];
    final index = students.indexWhere((s) => s.studentId == student.studentId);
    if (index >= 0) {
      students[index] = student;
    } else {
      students.add(student);
    }
    return students;
  }

  Future<void> getStudents() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      reusedExistingStudent: false,
    );
    try {
      final response = await _service.getStudents();
      state = state.copyWith(students: response.data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> getStudentById(String studentId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      reusedExistingStudent: false,
    );
    try {
      final response = await _service.getStudentById(studentId);
      state = state.copyWith(selectedStudent: response.data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<bool> createStudent(StudentRequest request) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      reusedExistingStudent: false,
    );
    try {
      final response = await _service.createStudent(request);
      state = state.copyWith(
        students: _upsertStudent(response.data),
        selectedStudent: response.data,
        isLoading: false,
        reusedExistingStudent: false,
      );
      return true;
    } on ValidationException catch (e) {
      final errorDetails = e.errors
          ?.map((err) => err['msg'] as String? ?? '')
          .join('\n');
      state = state.copyWith(
        error: errorDetails ?? e.message,
        isLoading: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> createStudentForRegistration(StudentRequest request) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      reusedExistingStudent: false,
    );
    try {
      final response = await _service.createStudent(request);
      state = state.copyWith(
        students: _upsertStudent(response.data),
        selectedStudent: response.data,
        isLoading: false,
        reusedExistingStudent: false,
      );
      return true;
    } on ConflictException catch (e) {
      final payload = e.data;
      if (payload is Map<String, dynamic>) {
        final existingStudent = StudentModel.fromJson(payload);
        state = state.copyWith(
          students: _upsertStudent(existingStudent),
          selectedStudent: existingStudent,
          isLoading: false,
          error: null,
          reusedExistingStudent: true,
        );
        return true;
      }
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    } on ValidationException catch (e) {
      final errorDetails = e.errors
          ?.map((err) => err['msg'] as String? ?? '')
          .join('\n');
      state = state.copyWith(
        error: errorDetails ?? e.message,
        isLoading: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateStudent(String studentId, StudentRequest request) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      reusedExistingStudent: false,
    );
    try {
      final response = await _service.updateStudent(studentId, request);
      state = state.copyWith(
        students: state.students
            .map((s) => s.studentId == studentId ? response.data : s)
            .toList(),
        selectedStudent: response.data,
        isLoading: false,
        reusedExistingStudent: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteStudent(String studentId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      reusedExistingStudent: false,
    );
    try {
      await _service.deleteStudent(studentId);
      state = state.copyWith(
        students: state.students
            .where((s) => s.studentId != studentId)
            .toList(),
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  void clearTransientState() {
    state = state.copyWith(
      selectedStudent: null,
      error: null,
      isLoading: false,
      reusedExistingStudent: false,
    );
  }

  void resetState() {
    state = const StudentState();
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, StudentState>(
  (ref) => StudentNotifier(ref.read(studentServiceProvider)),
);
