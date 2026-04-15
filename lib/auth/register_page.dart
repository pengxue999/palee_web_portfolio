import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/app_text_field.dart';
import 'package:palee_web_portfolio/widgets/subject_selection_widget.dart';
import 'package:palee_web_portfolio/services/province_service.dart';
import 'package:palee_web_portfolio/models/province_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _studentContactController = TextEditingController();
  final _parentsContactController = TextEditingController();
  final _schoolController = TextEditingController();

  String? _selectedGender;
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedDormitory;
  String? _selectedScholarship;
  bool _isLoading = false;
  bool _isLoadingProvinces = false;
  int _currentStep = 0;

  Map<String, String> _selectedSubjects = {};

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ProvinceService _provinceService = ProvinceService();
  List<ProvinceModel> _provinces = [];
  List<String> _districts = [];

  final List<String> _dormitories = ['ຫໍພັກໃນ', 'ຫໍພັກນອກ'];
  final List<String> _scholarships = ['ໄດ້ຮັບທຶນ', 'ບໍ່ໄດ້ຮັບທຶນ'];

  final Map<String, Map<String, dynamic>> _subjectsData = {
    'ຄະນິດສາດ+ເຄມີສາດ+ຟີຊິກສາດ': {
      'icon': Icons.calculate,
      'levels': ['ມ3'],
      'color': Colors.purple,
    },
    'ຄະນິດສາດ': {
      'icon': Icons.functions,
      'levels': ['ມ4', 'ມ5', 'ມ6', 'ມ7'],
      'color': Colors.blue,
    },
    'ເຄມີສາດ': {
      'icon': Icons.science_outlined,
      'levels': ['ມ4', 'ມ5', 'ມ6', 'ມ7'],
      'color': Colors.green,
    },
    'ຟີຊິກສາດ': {
      'icon': Icons.science,
      'levels': ['ມ4', 'ມ5', 'ມ6', 'ມ7'],
      'color': Colors.orange,
    },
    'ພາສາອັງກິດ': {
      'icon': Icons.language,
      'levels': ['ເລີ່ມຕົ້ນ', 'ກາງ', 'ສູງ'],
      'color': Colors.teal,
    },
    'ພາສາຈີນ': {
      'icon': Icons.translate,
      'levels': ['HSK1', 'HSK2', 'HSK3', 'HSK4'],
      'color': Colors.red,
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();

    // ດຶງຂໍ້ມູນແຂວງເມື່ອເລີ່ມຕົ້ນ
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    setState(() => _isLoadingProvinces = true);

    try {
      final provinces = await _provinceService.fetchAllProvince();
      if (mounted) {
        setState(() {
          _provinces = provinces;
          _isLoadingProvinces = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProvinces = false);
        _showError('ບໍ່ສາມາດດຶງຂໍ້ມູນແຂວງໄດ້: ${e.toString()}');
      }
    }
  }

  void _onProvinceChanged(String? provinceId) {
    setState(() {
      _selectedProvince = provinceId;
      _selectedDistrict = null;

      // ຊອກຫາແຂວງທີ່ຖືກເລືອກ ແລະ ດຶງລາຍການເມືອງ
      if (provinceId != null) {
        final selectedProvince = _provinces.firstWhere(
          (p) => p.provinceId.toString() == provinceId,
          orElse: () => _provinces.first,
        );
        //_districts = selectedProvince.districts.map((d) => d.name).toList();
      } else {
        _districts = [];
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _studentContactController.dispose();
    _parentsContactController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'ກະລຸນາປ້ອນ$fieldName';
    }
    return null;
  }

  String? _validatePhone(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'ກະລຸນາປ້ອນ$fieldName';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    if (cleaned.length < 8 || !RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'ເບີໂທບໍ່ຖືກຕ້ອງ';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        _showError('ກະລຸນາເລືອກເພດ');
        return;
      }
      if (_selectedProvince == null) {
        _showError('ກະລຸນາເລືອກແຂວງ');
        return;
      }
      if (_selectedDistrict == null) {
        _showError('ກະລຸນາເລືອກເມືອງ');
        return;
      }
      if (_selectedSubjects.isEmpty) {
        _showError('ກະລຸນາເລືອກຢ່າງໜ້ອຍ 1 ວິຊາຮຽນ');
        return;
      }

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccess();
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pop();
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text('ລົງທະບຽນສຳເລັດ! 🎉')),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  InputDecoration _modernDropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue.shade700, size: 20),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blue.shade600, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade600, width: 2.5),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          _buildStep(0, 'ຂໍ້ມູນສ່ວນຕົວ', Icons.person_outline),
          _buildStepConnector(),
          _buildStep(1, 'ວິຊາຮຽນ', Icons.book_outlined),
        ],
      ),
    );
  }

  Widget _buildStep(int step, String label, IconData icon) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isCompleted || isActive
                  ? Colors.blue.shade600
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.blue.shade300,
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: isCompleted || isActive
                  ? Colors.white
                  : Colors.grey.shade500,
              size: 28,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector() {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.only(bottom: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _currentStep > 0
                ? [Colors.blue.shade600, Colors.blue.shade600]
                : [Colors.grey.shade300, Colors.grey.shade300],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'ລົງທະບຽນ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _currentStep--),
                icon: Icon(Icons.arrow_back),
                label: Text('ກັບຄືນ'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
              ),
            ),
          ),
        if (_currentStep > 0) SizedBox(width: 12),
        Expanded(
          child: _currentStep < 1
              ? SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedGender != null &&
                          _selectedProvince != null &&
                          _selectedDistrict != null) {
                        setState(() => _currentStep++);
                      } else {
                        _showError('ກະລຸນາຕື່ມຂໍ້ມູນໃຫ້ຄົບຖ້ວນ');
                      }
                    },
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text('ຕໍ່ໄປ', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                )
              : _buildSubmitButton(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 750),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(isMobile ? 24.0 : 40.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade600,
                                      Colors.blue.shade700,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.school,
                                        size: 48,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'ລົງທະບຽນນັກຮຽນ',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'ກະລຸນາຕື່ມຂໍ້ມູນເພື່ອລົງທະບຽນຮຽນທີ່ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງ',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 32),

                              // Step Indicator
                              _buildStepIndicator(),
                              SizedBox(height: 32),

                              // Form Content
                              Skeletonizer(
                                enabled: _isLoading,
                                child: AbsorbPointer(
                                  absorbing: _isLoading,
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: Offset(0.1, 0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _currentStep == 0
                                        ? _buildPersonalInfoStep(isMobile)
                                        : _buildSubjectSelectionStep(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              Divider(
                                height: 1,
                                color: Colors.grey.shade300,
                                thickness: 2,
                              ),
                              SizedBox(height: 24),

                              // Navigation Buttons
                              _buildNavigationButtons(),
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
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep(bool isMobile) {
    return Column(
      key: ValueKey('personal_info'),
      children: [
        _buildSectionHeader('ຂໍ້ມູນສ່ວນຕົວ', Icons.person_outline),

        const SizedBox(height: 10),
        AppTextField(
          controller: _firstNameController,
          labelText: 'ຊື່',
          hintText: 'ປ້ອນຊື່',
          prefixIcon: Icons.person_outline,
          validator: (value) => _validateRequired(value, 'ຊື່'),
        ),
        SizedBox(height: 16),
        AppTextField(
          controller: _lastNameController,
          labelText: 'ນາມສະກຸນ',
          hintText: 'ປ້ອນນາມສະກຸນ',
          prefixIcon: Icons.badge_outlined,
          validator: (value) => _validateRequired(value, 'ນາມສະກຸນ'),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: _modernDropdownDecoration('ເພດ', Icons.wc_outlined),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('ຊາຍ')),
            DropdownMenuItem(value: 'female', child: Text('ຍິງ')),
          ],
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        SizedBox(height: 16),
        AppTextField(
          controller: _studentContactController,
          keyboardType: TextInputType.phone,
          labelText: 'ເບີໂທນັກຮຽນ',
          hintText: '20xxxxxxxx',
          prefixIcon: Icons.phone_outlined,
          validator: (value) => _validatePhone(value, 'ເບີໂທນັກຮຽນ'),
        ),
        SizedBox(height: 16),
        AppTextField(
          controller: _parentsContactController,
          keyboardType: TextInputType.phone,
          labelText: 'ເບີໂທພໍ່ແມ່',
          hintText: '20xxxxxxxx',
          prefixIcon: Icons.phone_android_outlined,
          validator: (value) => _validatePhone(value, 'ເບີໂທພໍ່ແມ່'),
        ),
        SizedBox(height: 16),
        AppTextField(
          controller: _schoolController,
          labelText: 'ໂຮງຮຽນ',
          hintText: 'ປ້ອນຊື່ໂຮງຮຽນ',
          prefixIcon: Icons.school_outlined,
          validator: (value) => _validateRequired(value, 'ໂຮງຮຽນ'),
        ),
        SizedBox(height: 26),
        _buildSectionHeader('ຂໍ້ມູນທີ່ຢູ່', Icons.location_on_outlined),
        const SizedBox(height: 10),

        // Province Dropdown with Loading State
        _isLoadingProvinces
            ? Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade600,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'ກຳລັງໂຫລດແຂວງ...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : DropdownButtonFormField<String>(
                value: _selectedProvince,
                decoration: _modernDropdownDecoration(
                  'ແຂວງ',
                  Icons.map_outlined,
                ),
                items: _provinces.map((province) {
                  return DropdownMenuItem(
                    value: province.provinceId.toString(),
                    child: Text(province.provinceName),
                  );
                }).toList(),
                onChanged: _onProvinceChanged,
              ),
        SizedBox(height: 16),

        // District Dropdown
        DropdownButtonFormField<String>(
          value: _selectedDistrict,
          decoration: _modernDropdownDecoration(
            'ເມືອງ',
            Icons.location_city_outlined,
          ),
          items: _districts.map((district) {
            return DropdownMenuItem(value: district, child: Text(district));
          }).toList(),
          onChanged: _selectedProvince == null
              ? null
              : (value) => setState(() => _selectedDistrict = value),
        ),
        SizedBox(height: 26),
        _buildSectionHeader('ຂໍ້ມູນເພີ່ມເຕີມ (ທາງເລືອກ)', Icons.info_outline),

        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedDormitory,
          decoration: _modernDropdownDecoration('ຫໍພັກ', Icons.home_outlined),
          items: _dormitories
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (value) => setState(() => _selectedDormitory = value),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedScholarship,
          decoration: _modernDropdownDecoration(
            'ທຶນ',
            Icons.card_giftcard_outlined,
          ),
          items: _scholarships
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (value) => setState(() => _selectedScholarship = value),
        ),
      ],
    );
  }

  Widget _buildSubjectSelectionStep() {
    return Column(
      key: ValueKey('subject_selection'),
      children: [
        SubjectSelectionWidget(
          subjectsData: _subjectsData,
          selectedSubjects: _selectedSubjects,
          isLoading: _isLoading,
          onChanged: (selection) =>
              setState(() => _selectedSubjects = selection),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF1976D2)),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }
}
