import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palee_web_portfolio/models/discount_model.dart';
import 'package:palee_web_portfolio/models/fee_model.dart';
import 'package:palee_web_portfolio/models/registration_model.dart';
import 'package:palee_web_portfolio/models/student_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:palee_web_portfolio/models/district_model.dart';
import 'package:palee_web_portfolio/providers/discount_provider.dart';
import 'package:palee_web_portfolio/providers/district_provider.dart';
import 'package:palee_web_portfolio/providers/fee_provider.dart';
import 'package:palee_web_portfolio/providers/province_provider.dart';
import 'package:palee_web_portfolio/providers/registration_provider.dart';
import 'package:palee_web_portfolio/providers/student_provider.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/app_text_field.dart';
import 'package:palee_web_portfolio/widgets/app_dropdown_field.dart';
import 'package:palee_web_portfolio/widgets/fee_selection_widget.dart';
import 'package:palee_web_portfolio/models/province_model.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const _navy = Color(0xFF0F1629);
const _navyMid = Color(0xFF1A2340);
const _navyLight = Color(0xFF243052);
const _accent = Color(0xFF4F7EFF);
const _accentGlow = Color(0x334F7EFF);
const _accentSoft = Color(0xFFEEF3FF);
const _gold = Color(0xFFF5C842);
const _surface = Color(0xFFFAFBFF);
const _border = Color(0xFFE8ECFA);
const _textPrimary = Color(0xFF111827);
const _textSecondary = Color(0xFF6B7497);
const _errorColor = Color(0xFFEF4444);
const _successColor = Color(0xFF22C55E);

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with TickerProviderStateMixin {
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
  bool _isLoading = false;
  int _currentStep = 0;
  String? _savedStudentId;
  String? _lastShownError;
  Map<String, String> _scholarshipStatusByFee = <String, String>{};

  Set<String> _selectedFeeIds = <String>{};

  late final AnimationController _pageController;
  late final AnimationController _stepController;
  late final Animation<double> _pageFade;
  late final Animation<Offset> _pageSlide;
  late final Animation<double> _stepProgress;

  final List<String> _dormitories = ['ຫໍພັກໃນ', 'ຫໍພັກນອກ'];

  // ── Steps metadata ─────────────────────────────────────────────────────────
  final List<_StepMeta> _steps = const [
    _StepMeta(
      title: 'ຂໍ້ມູນສ່ວນຕົວ',
      subtitle: 'Personal info',
      icon: Icons.person_outline_rounded,
    ),
    _StepMeta(
      title: 'ວິຊາຮຽນ',
      subtitle: 'Subjects',
      icon: Icons.auto_stories_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pageFade = CurvedAnimation(parent: _pageController, curve: Curves.easeOut);
    _pageSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
        );
    _stepProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _stepController, curve: Curves.easeInOut),
    );

    _pageController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(provinceProvider.notifier).getProvinces();
      ref.read(districtProvider.notifier).clearDistricts();
      ref.read(feeProvider.notifier).getFees();
      ref.read(discountProvider.notifier).getDiscounts();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stepController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _studentContactController.dispose();
    _parentsContactController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  // ── Validation ─────────────────────────────────────────────────────────────
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return 'ກະລຸນາປ້ອນ$fieldName';
    return null;
  }

  String? _validatePhone(String? value, String fieldName) {
    if (value == null || value.isEmpty) return 'ກະລຸນາປ້ອນ$fieldName';
    final cleaned = _normalizePhone(value);
    if (!RegExp(r'^(020\d{8}|030\d{7})$').hasMatch(cleaned)) {
      return 'ກະລຸນາປ້ອນເບີໂທທີ່ຖືກຕ້ອງ: 020XXXXXXXX ຫຼື 030XXXXXXX';
    }
    return null;
  }

  String _normalizePhone(String value) {
    final c = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (c.startsWith('20') && c.length == 10) return '0$c';
    if (c.startsWith('30') && c.length == 9) return '0$c';
    return c;
  }

  String _errMsg(dynamic e) {
    final raw = e.toString();
    return raw.startsWith('Exception: ') ? raw.substring(11) : raw;
  }

  void _showErrorOnce(String msg) {
    if (_lastShownError == msg) return;
    _lastShownError = msg;
    _showSnack(msg, isError: true);
  }

  Map<String, String> _selectedSubjectSummary(List<FeeModel> fees) {
    final summary = <String, String>{};
    for (final fee in fees) {
      if (_selectedFeeIds.contains(fee.feeId)) {
        summary[fee.subjectName] = fee.levelName;
      }
    }
    return summary;
  }

  int get _totalFee {
    final fees = ref.read(feeProvider).fees;
    return _selectedFeeIds.fold<int>(0, (sum, feeId) {
      final matched = fees.where((fee) => fee.feeId == feeId);
      if (matched.isEmpty) {
        return sum;
      }
      return sum + matched.first.fee.toInt();
    });
  }

  int get _selectedDiscountAmount {
    final discount = _autoAppliedDiscount;
    if (discount == null) {
      return 0;
    }
    final percentage = discount.discountAmount.toInt();
    return ((_totalFee * percentage) / 100).round();
  }

  int get _netFee => _totalFee - _selectedDiscountAmount;

  DiscountModel? get _autoAppliedDiscount {
    final discounts = ref.read(discountProvider).discounts;
    final fees = ref.read(feeProvider).fees;
    final selectedMathTrackCount = fees
        .where(
          (fee) =>
              _selectedFeeIds.contains(fee.feeId) &&
              fee.subjectCategory == 'ສາຍຄິດໄລ່',
        )
        .length;

    if (selectedMathTrackCount < 3) {
      return null;
    }

    final preferred = discounts.where(
      (discount) =>
          discount.discountId == 'D001' ||
          discount.discountDescription == 'ຮຽນ3ວິຊາຂື້ນໄປ',
    );

    if (preferred.isNotEmpty) {
      return preferred.first;
    }

    return null;
  }

  String get _autoDiscountDescription {
    final discount = _autoAppliedDiscount;
    if (discount == null) {
      return '';
    }

    return '${discount.discountDescription} (${discount.discountAmount.toStringAsFixed(0)}%)';
  }

  void _syncSelectionState(Set<String> next) {
    final nextScholarships = <String, String>{};
    for (final feeId in next) {
      nextScholarships[feeId] =
          _scholarshipStatusByFee[feeId] ?? 'ບໍ່ໄດ້ຮັບທຶນ';
    }

    setState(() {
      _selectedFeeIds = next;
      _scholarshipStatusByFee = nextScholarships;
    });
  }

  void _handleFeeSelectionChanged(Set<String> selectedIds) {
    final hadLessOrEqualThree = _selectedFeeIds.length <= 3;
    if (selectedIds.length > 3 && hadLessOrEqualThree) {
      _showSnack('ນັກຮຽນສາມາດລົງທະບຽນໄດ້ສູງສຸດ 3 ວິຊາ', isError: true);
      return;
    }
    _syncSelectionState(selectedIds);
  }

  void _setScholarshipStatus(String feeId, String status) {
    setState(() {
      _scholarshipStatusByFee[feeId] = status;
    });
  }

  // ── Province / District ────────────────────────────────────────────────────
  Future<void> _handleProvinceChanged(String? value) async {
    setState(() {
      _selectedProvince = value;
      _selectedDistrict = null;
    });
    if (value == null) {
      ref.read(districtProvider.notifier).clearDistricts();
      return;
    }
    await ref
        .read(districtProvider.notifier)
        .getDistrictsByProvince(int.parse(value));
    final err = ref.read(districtProvider).error;
    if (mounted && err != null) _showSnack(_errMsg(err), isError: true);
  }

  // ── Business logic ─────────────────────────────────────────────────────────
  StudentRequest _buildRequest() => StudentRequest(
    studentName: _firstNameController.text.trim(),
    studentLastname: _lastNameController.text.trim(),
    gender: _selectedGender!,
    studentContact: _normalizePhone(_studentContactController.text),
    parentsContact: _normalizePhone(_parentsContactController.text),
    school: _schoolController.text.trim(),
    districtId: int.parse(_selectedDistrict!),
    dormitoryType: _selectedDormitory ?? 'ຫໍພັກນອກ',
  );

  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      _showSnack('ກະລຸນາເລືອກເພດ', isError: true);
      return;
    }
    if (_selectedProvince == null) {
      _showSnack('ກະລຸນາເລືອກແຂວງ', isError: true);
      return;
    }
    if (_selectedDistrict == null) {
      _showSnack('ກະລຸນາເລືອກເມືອງ', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final isUpdate = _savedStudentId != null;
      final req = _buildRequest();
      final ok = !isUpdate
          ? await ref.read(studentProvider.notifier).createStudent(req)
          : await ref
                .read(studentProvider.notifier)
                .updateStudent(_savedStudentId!, req);

      if (!mounted) return;
      if (!ok) {
        setState(() => _isLoading = false);
        _showSnack(
          _errMsg(
            ref.read(studentProvider).error ?? 'ເກີດຂໍ້ຜິດພາດໃນການບັນທຶກຂໍ້ມູນ',
          ),
          isError: true,
        );
        return;
      }
      final student = ref.read(studentProvider).selectedStudent;
      setState(() {
        _savedStudentId = student?.studentId ?? _savedStudentId;
        _isLoading = false;
        _currentStep = 1;
      });
      _stepController.forward(from: 0);
      _showSnack(
        !isUpdate ? 'ບັນທຶກສຳເລັດ ✓' : 'ອັບເດດສຳເລັດ ✓',
        isError: false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack(_errMsg(e), isError: true);
    }
  }

  Future<void> _handleRegister() async {
    if (_savedStudentId == null) {
      _showSnack('ກະລຸນາບັນທຶກຂໍ້ມູນນັກຮຽນກ່ອນ', isError: true);
      return;
    }
    if (_selectedFeeIds.isEmpty) {
      _showSnack('ກະລຸນາເລືອກຢ່າງໜ້ອຍ 1 ວິຊາ', isError: true);
      return;
    }
    setState(() => _isLoading = true);

    try {
      final request = RegistrationRequest(
        studentId: _savedStudentId!,
        discountId: _autoAppliedDiscount?.discountId,
        totalAmount: _totalFee.toDouble(),
        finalAmount: _netFee.toDouble(),
        status: 'ຍັງບໍ່ທັນຈ່າຍ',
        registrationDate: DateTime.now(),
      );

      final details = _selectedFeeIds
          .map(
            (feeId) => {
              'fee_id': feeId,
              'scholarship': _scholarshipStatusByFee[feeId] ?? 'ບໍ່ໄດ້ຮັບທຶນ',
            },
          )
          .toList();

      final success = await ref
          .read(registrationProvider.notifier)
          .createRegistrationAndDetails(request, details);

      if (!mounted) {
        return;
      }

      if (!success) {
        setState(() => _isLoading = false);
        _showSnack(
          _errMsg(
            ref.read(registrationProvider).error ??
                'ບັນທຶກການລົງທະບຽນບໍ່ສຳເລັດ',
          ),
          isError: true,
        );
        return;
      }

      final lastRegistration =
          ref.read(registrationProvider).registrations.isNotEmpty
          ? ref.read(registrationProvider).registrations.last
          : null;
      final selectedSummary = _selectedSubjectSummary(
        ref.read(feeProvider).fees,
      );

      setState(() => _isLoading = false);
      _showSnack('ລົງທະບຽນສຳເລັດ ✓', isError: false);
      Navigator.of(context).pop({
        'registration_id': lastRegistration?.registrationId,
        'student_id': _savedStudentId,
        'selected_fee_ids': _selectedFeeIds.toList(),
        'selected_subjects': selectedSummary,
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _isLoading = false);
      _showSnack(_errMsg(e), isError: true);
    }
  }

  // ── Snackbar ───────────────────────────────────────────────────────────────
  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? _errorColor : _successColor,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 900;
    final isMedium = size.width >= 600;

    final provinceState = ref.watch(provinceProvider);
    final districtState = ref.watch(districtProvider);
    final studentState = ref.watch(studentProvider);
    final feeState = ref.watch(feeProvider);
    final discountState = ref.watch(discountProvider);
    final registrationState = ref.watch(registrationProvider);

    final provinces = provinceState.provinces;
    final districts = districtState.filteredDistricts;
    final fees = feeState.fees;
    final isProvinceLoading = provinceState.isLoading && provinces.isEmpty;
    final isDistrictLoading = districtState.isLoading;
    final isBusy =
        _isLoading || studentState.isLoading || registrationState.isCreating;

    if (provinceState.error != null && !isProvinceLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showErrorOnce(_errMsg(provinceState.error!));
      });
    }

    if (feeState.error != null && !feeState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showErrorOnce(_errMsg(feeState.error!));
      });
    }

    if (discountState.error != null && !discountState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showErrorOnce(_errMsg(discountState.error!));
      });
    }

    return Scaffold(
      backgroundColor: _surface,
      body: FadeTransition(
        opacity: _pageFade,
        child: SlideTransition(
          position: _pageSlide,
          child: isWide
              ? _buildWideLayout(
                  isBusy,
                  provinces,
                  districts,
                  fees,
                  isProvinceLoading,
                  isDistrictLoading,
                  feeState.isLoading,
                )
              : _buildNarrowLayout(
                  isBusy,
                  provinces,
                  districts,
                  fees,
                  isProvinceLoading,
                  isDistrictLoading,
                  feeState.isLoading,
                  isMedium,
                ),
        ),
      ),
    );
  }

  // ── Wide layout: left panel + right form ───────────────────────────────────
  Widget _buildWideLayout(
    bool isBusy,
    List<ProvinceModel> provinces,
    List<DistrictModel> districts,
    List<FeeModel> fees,
    bool isProvinceLoading,
    bool isDistrictLoading,
    bool isFeeLoading,
  ) {
    return Row(
      children: [
        // Left decorative panel
        SizedBox(width: 350, child: _buildLeftPanel()),
        // Right form panel
        Expanded(
          child: _buildFormPanel(
            isBusy: isBusy,
            provinces: provinces,
            districts: districts,
            fees: fees,
            isProvinceLoading: isProvinceLoading,
            isDistrictLoading: isDistrictLoading,
            isFeeLoading: isFeeLoading,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
          ),
        ),
      ],
    );
  }

  // ── Narrow layout: stacked ─────────────────────────────────────────────────
  Widget _buildNarrowLayout(
    bool isBusy,
    List<ProvinceModel> provinces,
    List<DistrictModel> districts,
    List<FeeModel> fees,
    bool isProvinceLoading,
    bool isDistrictLoading,
    bool isFeeLoading,
    bool isMedium,
  ) {
    return Column(
      children: [
        _buildTopBanner(),
        Expanded(
          child: _buildFormPanel(
            isBusy: isBusy,
            provinces: provinces,
            districts: districts,
            fees: fees,
            isProvinceLoading: isProvinceLoading,
            isDistrictLoading: isDistrictLoading,
            isFeeLoading: isFeeLoading,
            padding: EdgeInsets.symmetric(
              horizontal: isMedium ? 32 : 20,
              vertical: 24,
            ),
          ),
        ),
      ],
    );
  }

  // ── Left decorative panel (desktop) ───────────────────────────────────────
  Widget _buildLeftPanel() {
    return Container(
      color: _navy,
      child: Stack(
        children: [
          // Geometric decorations
          Positioned(
            top: -60,
            left: -60,
            child: _geoCircle(220, _navyLight.withOpacity(0.5)),
          ),
          Positioned(
            bottom: 80,
            right: -80,
            child: _geoCircle(200, _navyLight.withOpacity(0.35)),
          ),
          Positioned(
            top: 200,
            left: -30,
            child: _geoCircle(120, _accent.withOpacity(0.08)),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo / brand
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _accent.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: _gold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'ລົງທະບຽນເພື່ອເຂົ້າຮຽນຫຼັກສູດໄລຍະສັ້ນຂອງພວກເຮົາ ສ້າງໂອກາດໃນການເກັ່ງ ແລະ ເຂົ້າຮຽນຢ່າງມີຄຸນນະພາບ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.6,
                    ),
                  ),
                  const Spacer(),

                  // Step tracker on left panel
                  _buildVerticalStepTracker(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _geoCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
    );
  }

  // ── Top banner (mobile) ────────────────────────────────────────────────────
  Widget _buildTopBanner() {
    return Container(
      color: _navy,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'ສູນປາລີ — ລົງທະບຽນນັກຮຽນ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildHorizontalStepTracker(),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // ── Vertical step tracker (desktop left panel) ─────────────────────────────
  Widget _buildVerticalStepTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_steps.length, (i) {
        final isActive = _currentStep == i;
        final isDone = _currentStep > i;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // Icon circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDone
                      ? _successColor.withOpacity(0.15)
                      : isActive
                      ? _accent.withOpacity(0.2)
                      : _navyLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone
                        ? _successColor
                        : isActive
                        ? _accent
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isDone ? Icons.check_rounded : _steps[i].icon,
                  color: isDone
                      ? _successColor
                      : isActive
                      ? _accent
                      : Colors.white.withOpacity(0.3),
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _steps[i].title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.45),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    _steps[i].subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive
                          ? Colors.white.withOpacity(0.55)
                          : Colors.white.withOpacity(0.25),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── Horizontal step tracker (mobile top banner) ────────────────────────────
  Widget _buildHorizontalStepTracker() {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // connector line
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _currentStep > i ~/ 2
                    ? _accent
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final isActive = _currentStep == stepIdx;
        final isDone = _currentStep > stepIdx;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDone
                ? _successColor
                : isActive
                ? _accent
                : Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDone ? Icons.check_rounded : _steps[stepIdx].icon,
            color: Colors.white,
            size: 16,
          ),
        );
      }),
    );
  }

  // ── Right / main form panel ────────────────────────────────────────────────
  Widget _buildFormPanel({
    required bool isBusy,
    required List<ProvinceModel> provinces,
    required List<DistrictModel> districts,
    required List<FeeModel> fees,
    required bool isProvinceLoading,
    required bool isDistrictLoading,
    required bool isFeeLoading,
    required EdgeInsets padding,
  }) {
    return Container(
      color: _surface,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: _border, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Page heading
                      _buildFormHeader(),
                      const SizedBox(height: 32),

                      // Form body
                      Skeletonizer(
                        enabled: isBusy,
                        child: AbsorbPointer(
                          absorbing: isBusy,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 320),
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.04, 0),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: _currentStep == 0
                                ? _buildPersonalStep(
                                    provinces,
                                    districts,
                                    isProvinceLoading,
                                    isDistrictLoading,
                                  )
                                : _buildSubjectStep(fees, isFeeLoading),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      _buildNavButtons(isBusy),
                      const SizedBox(height: 24),
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

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ຟອມລົງທະບຽນນັກຮຽນ',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _textPrimary,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _currentStep == 0
              ? 'ກະລຸນາຕື່ມຂໍ້ມູນໃຫ້ຄົບຖ້ວນ'
              : 'ເລືອກວິຊາ ແລະ ຊັ້ນຮຽນ/ລະດັບທີ່ທ່ານສົນໃຈ',
          style: const TextStyle(
            fontSize: 14,
            color: _textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _steps.length,
            backgroundColor: _border,
            color: _accent,
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  // ── Personal info step ─────────────────────────────────────────────────────
  Widget _buildPersonalStep(
    List<ProvinceModel> provinces,
    List<DistrictModel> districts,
    bool isProvinceLoading,
    bool isDistrictLoading,
  ) {
    return Column(
      key: const ValueKey('personal'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionLabel('ຂໍ້ມູນສ່ວນຕົວ', Icons.person_outline_rounded),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _firstNameController,
                labelText: 'ຊື່',
                hintText: 'ກະລຸນາປ້ອນຊື່',
                validator: (v) => _validateRequired(v, 'ກະລຸນາປ້ອນຊື່'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: _lastNameController,
                labelText: 'ນາມສະກຸນ',
                hintText: 'ກະລຸນາປ້ອນນາມສະກຸນ',
                validator: (v) => _validateRequired(v, 'ກະລຸນາປ້ອນນາມສະກຸນ'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _GenderSelector(
          selected: _selectedGender,
          onChanged: (v) => setState(() => _selectedGender = v),
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _studentContactController,
          keyboardType: TextInputType.phone,
          labelText: 'ເບີໂທນັກຮຽນ',
          hintText: 'ກະລຸນາປ້ອນເບີໂທນັກຮຽນ',
          validator: (v) => _validatePhone(v, 'ກະລຸນາປ້ອນເບີໂທນັກຮຽນ'),
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _parentsContactController,
          keyboardType: TextInputType.phone,
          labelText: 'ເບີໂທພໍ່ແມ່',
          hintText: 'ກະລຸນາປ້ອນເບີໂທພໍ່ແມ່',
          validator: (v) => _validatePhone(v, 'ກະລຸນາປ້ອນເບີໂທພໍ່ແມ່'),
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _schoolController,
          labelText: 'ໂຮງຮຽນ',
          hintText: 'ກະລຸນາປ້ອນຊື່ໂຮງຮຽນ',
          validator: (v) => _validateRequired(v, 'ກະລຸນາປ້ອນຊື່ໂຮງຮຽນ'),
        ),
        const SizedBox(height: 28),

        _sectionLabel('ທີ່ຢູ່', Icons.location_on_outlined),
        const SizedBox(height: 14),
        AppDropdownField<String>(
          labelText: 'ແຂວງ',
          hintText: 'ກະລຸນາເລືອກແຂວງ',
          value: _selectedProvince,
          isLoading: isProvinceLoading,
          items: provinces
              .map(
                (p) => DropdownMenuItem(
                  value: p.provinceId.toString(),
                  child: Text(p.provinceName),
                ),
              )
              .toList(),
          onChanged: _isLoading ? null : _handleProvinceChanged,
        ),
        const SizedBox(height: 14),
        AppDropdownField<String>(
          labelText: 'ເມືອງ',
          hintText: 'ເລືອກເມືອງ',
          value: _selectedDistrict,
          isLoading: isDistrictLoading,
          enabled: _selectedProvince != null && !_isLoading,
          items: districts
              .map(
                (d) => DropdownMenuItem(
                  value: d.districtId.toString(),
                  child: Text(d.districtName),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectedDistrict = v),
        ),
        const SizedBox(height: 28),

        _sectionLabel('ຂໍ້ມູນເພີ່ມເຕີມ', Icons.tune_rounded),
        const SizedBox(height: 14),
        AppDropdownField<String>(
          labelText: 'ຫໍພັກ',
          hintText: 'ກະລຸນາເລືອກປະເພດຫໍພັກ',
          value: _selectedDormitory,
          items: _dormitories
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (v) => setState(() => _selectedDormitory = v),
        ),
      ],
    );
  }

  // ── Subject step ───────────────────────────────────────────────────────────
  Widget _buildSubjectStep(List<FeeModel> fees, bool isFeeLoading) {
    final selectedFees = fees
        .where((fee) => _selectedFeeIds.contains(fee.feeId))
        .toList();

    return Column(
      key: const ValueKey('subjects'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FeeSelectionWidget(
          fees: fees,
          selectedFeeIds: _selectedFeeIds,
          isLoading: isFeeLoading,
          onChanged: _handleFeeSelectionChanged,
        ),
        const SizedBox(height: 20),
        if (selectedFees.isNotEmpty) ...[
          _sectionLabel('ສະຖານະທຶນ', Icons.workspace_premium_outlined),
          const SizedBox(height: 12),
          ...selectedFees.map((fee) {
            final status = _scholarshipStatusByFee[fee.feeId] ?? 'ບໍ່ໄດ້ຮັບທຶນ';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _border, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fee.subjectName} ${fee.levelName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['ບໍ່ໄດ້ຮັບທຶນ', 'ໄດ້ຮັບທຶນ'].map((option) {
                      final selected = status == option;
                      return ChoiceChip(
                        label: Text(option),
                        selected: selected,
                        onSelected: (_) =>
                            _setScholarshipStatus(fee.feeId, option),
                        selectedColor: const Color(0xFFDCFCE7),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: selected
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFFE5E7EB),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? const Color(0xFF166534)
                              : const Color(0xFF4B5563),
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          _sectionLabel('ສະຫຼຸບຄ່າຮຽນ', Icons.receipt_long_outlined),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'ຈຳນວນວິຊາ',
                  value: '${selectedFees.length} ວິຊາ',
                ),
                _SummaryRow(
                  label: 'ຄ່າຮຽນລວມ',
                  value: '${_formatCurrency(_totalFee)} ກີບ',
                ),
                _SummaryRow(
                  label: 'ສ່ວນຫຼຸດ($_autoDiscountDescription)',
                  value: '${_formatCurrency(_selectedDiscountAmount)} ກີບ',
                ),
                const Divider(height: 24),
                _SummaryRow(
                  label: 'ຍອດສຸດທ້າຍ',
                  value: '${_formatCurrency(_netFee)} ກີບ',
                  isEmphasis: true,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatCurrency(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }

  // ── Navigation buttons ─────────────────────────────────────────────────────
  Widget _buildNavButtons(bool isBusy) {
    return Row(
      children: [
        if (_currentStep > 0) ...[
          _NavButton.outlined(
            label: 'ກັບຄືນ',
            icon: Icons.arrow_back_rounded,
            onPressed: () => setState(() {
              _currentStep--;
              _stepController.reverse();
            }),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: _currentStep < _steps.length - 1
              ? _NavButton.filled(
                  label: 'ຕໍ່ໄປ',
                  icon: Icons.arrow_forward_rounded,
                  isLoading: isBusy,
                  onPressed: isBusy ? null : _handleNext,
                )
              : _NavButton.filled(
                  label: 'ລົງທະບຽນ',
                  icon: Icons.check_circle_outline_rounded,
                  isLoading: isBusy,
                  onPressed: isBusy ? null : _handleRegister,
                ),
        ),
      ],
    );
  }

  // ── Section label ──────────────────────────────────────────────────────────
  Widget _sectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _accentSoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: _accent),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: _border)),
      ],
    );
  }
}

// ─── Gender selector widget ───────────────────────────────────────────────────
class _GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _GenderSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _tile('ຊາຍ', Icons.male_rounded, const Color(0xFF3B82F6)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _tile('ຍິງ', Icons.female_rounded, const Color(0xFFEC4899)),
        ),
      ],
    );
  }

  Widget _tile(String value, IconData icon, Color color) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : _border,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : _textSecondary, size: 22),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? color : _textSecondary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Nav button ───────────────────────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool _outlined;

  const _NavButton.filled({
    required this.label,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
  }) : _outlined = false;

  const _NavButton.outlined({
    required this.label,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
  }) : _outlined = true;

  @override
  Widget build(BuildContext context) {
    if (_outlined) {
      return SizedBox(
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: _textPrimary,
            side: const BorderSide(color: _border, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: _textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _accent.withOpacity(0.5),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, size: 18),
                ],
              ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmphasis;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = isEmphasis ? _accent : _textPrimary;
    final valueWeight = isEmphasis ? FontWeight.w800 : FontWeight.w600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: _textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isEmphasis ? 16 : 14,
              color: valueColor,
              fontWeight: valueWeight,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step metadata ────────────────────────────────────────────────────────────
class _StepMeta {
  final String title;
  final String subtitle;
  final IconData icon;
  const _StepMeta({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
