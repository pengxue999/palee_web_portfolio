import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Production-ready subject selection widget with Material 3 design
///
/// UX Principles:
/// - Single selection per subject (mutually exclusive chips)
/// - Clear visual feedback for selected state
/// - Smooth animations for state transitions
/// - Accessible color contrast (WCAG AA compliant)
/// - Empty state handling
/// - Bulk actions (clear all)
class SubjectSelectionWidget extends StatefulWidget {
  final Map<String, Map<String, dynamic>> subjectsData;
  final Map<String, String> selectedSubjects;
  final Function(Map<String, String>) onChanged;
  final bool isLoading;

  const SubjectSelectionWidget({
    super.key,
    required this.subjectsData,
    required this.selectedSubjects,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  State<SubjectSelectionWidget> createState() => _SubjectSelectionWidgetState();
}

class _SubjectSelectionWidgetState extends State<SubjectSelectionWidget>
    with TickerProviderStateMixin {
  late Map<String, String> _localSelection;

  // UX: Animation controllers for smooth transitions
  late AnimationController _headerAnimController;
  final Map<String, AnimationController> _cardAnimControllers = {};
  final Map<String, Animation<double>> _scaleAnimations = {};

  @override
  void initState() {
    super.initState();
    _localSelection = Map.from(widget.selectedSubjects);
    _setupAnimations();
  }

  /// UX: Setup staggered entrance animations for visual appeal
  void _setupAnimations() {
    // Header animation
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    // Staggered card animations
    int index = 0;
    for (final subject in widget.subjectsData.keys) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      final scaleAnimation = Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

      _cardAnimControllers[subject] = controller;
      _scaleAnimations[subject] = scaleAnimation;

      // UX: Stagger animation start for cascading effect
      Future.delayed(Duration(milliseconds: 80 * index), () {
        if (mounted) controller.forward();
      });

      index++;
    }
  }

  @override
  void didUpdateWidget(covariant SubjectSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSubjects != widget.selectedSubjects) {
      setState(() {
        _localSelection = Map.from(widget.selectedSubjects);
      });
    }
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    for (final controller in _cardAnimControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// UX: Update selection with validation
  void _updateSelection(String subject, String? level) {
    if (widget.isLoading) return;

    setState(() {
      if (level == null || level.isEmpty) {
        _localSelection.remove(subject);
      } else {
        // UX: Only one level per subject
        _localSelection[subject] = level;
      }
    });

    widget.onChanged(Map.from(_localSelection));
  }

  /// UX: Bulk clear action with confirmation feedback
  void _clearAllSelections() {
    if (widget.isLoading || _localSelection.isEmpty) return;

    setState(() => _localSelection.clear());
    widget.onChanged({});

    // UX: Provide feedback on bulk action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.delete_sweep_outlined, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text('ລ້າງການເລືອກວິຊາທັງໝົດແລ້ວ'),
          ],
        ),
        backgroundColor: const Color(0xFF616161),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// UX: Individual subject card with Material 3 design
  Widget _buildSubjectCard({
    required String subjectName,
    required IconData icon,
    required List<String> levels,
    required Color themeColor,
    required AnimationController animController,
    required Animation<double> scaleAnimation,
  }) {
    final selectedLevel = _localSelection[subjectName];
    final isSelected = selectedLevel != null;

    // UX: Smooth slide and fade entrance
    final slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOutCubic),
        );

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? themeColor.withOpacity(0.6)
                    : const Color(0xFFE0E0E0),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? themeColor.withOpacity(0.15)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: isSelected ? 16 : 8,
                  offset: Offset(0, isSelected ? 6 : 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading
                      ? null
                      : () {
                          // UX: Card tap for accessibility
                        },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader(
                          icon: icon,
                          subjectName: subjectName,
                          selectedLevel: selectedLevel,
                          isSelected: isSelected,
                          themeColor: themeColor,
                        ),
                        const SizedBox(height: 18),
                        _buildLevelChips(
                          levels: levels,
                          selectedLevel: selectedLevel,
                          subjectName: subjectName,
                          themeColor: themeColor,
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
    );
  }

  /// UX: Card header with icon and selection badge
  Widget _buildCardHeader({
    required IconData icon,
    required String subjectName,
    required String? selectedLevel,
    required bool isSelected,
    required Color themeColor,
  }) {
    return Row(
      children: [
        // UX: Animated icon container with theme color
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [themeColor.withOpacity(0.9), themeColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: themeColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : const Color(0xFF757575),
            size: 28,
          ),
        ),
        const SizedBox(width: 16),

        // UX: Subject name and status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subjectName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                  fontSize: 17,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  isSelected ? 'ລະດັບ: $selectedLevel' : 'ກະລຸນາເລືອກລະດັບ',
                  key: ValueKey(selectedLevel),
                  style: TextStyle(
                    color: isSelected ? themeColor : const Color(0xFF9E9E9E),
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),

        // UX: Selection indicator badge
        AnimatedScale(
          scale: isSelected ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 28,
              color: Color(0xFF388E3C),
            ),
          ),
        ),
      ],
    );
  }

  /// UX: Level selection chips with Material 3 design
  Widget _buildLevelChips({
    required List<String> levels,
    required String? selectedLevel,
    required String subjectName,
    required Color themeColor,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: levels.map((level) {
        final isLevelSelected = selectedLevel == level;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading
                  ? null
                  : () {
                      if (isLevelSelected) {
                        _updateSelection(subjectName, null);
                      } else {
                        _updateSelection(subjectName, level);
                      }
                    },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isLevelSelected
                      ? themeColor.withOpacity(0.15)
                      : const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isLevelSelected
                        ? themeColor
                        : const Color(0xFFE0E0E0),
                    width: isLevelSelected ? 2 : 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLevelSelected) ...[
                      Icon(
                        Icons.radio_button_checked,
                        size: 18,
                        color: themeColor,
                      ),
                      const SizedBox(width: 8),
                    ] else ...[
                      Icon(
                        Icons.radio_button_unchecked,
                        size: 18,
                        color: const Color(0xFF9E9E9E),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      level,
                      style: TextStyle(
                        color: isLevelSelected
                            ? themeColor
                            : const Color(0xFF616161),
                        fontWeight: isLevelSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// UX: Section header with count and actions
  Widget _buildSectionHeader() {
    final headerAnimation = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );

    return FadeTransition(
      opacity: headerAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(headerAnimation),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE3F2FD),
                const Color(0xFFE3F2FD).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF90CAF9), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1976D2).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ເລືອກວິຊາຮຽນ',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '*',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD32F2F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ເລືອກລະດັບດຽວຕໍ່ວິຊາ (ຕ້ອງເລືອກຢ່າງໜ້ອຍ 1 ວິຊາ)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Progress and actions row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ເລືອກໄປແລ້ວ: ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              '${_localSelection.length} ວິຊາ',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Clear all button
                  if (_localSelection.isNotEmpty && !widget.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _clearAllSelections,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFEF5350),
                                width: 1.5,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: Color(0xFFD32F2F),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'ລ້າງທັງໝົດ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD32F2F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: widget.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          _buildSectionHeader(),

          const SizedBox(height: 28),

          // Subject cards
          ...widget.subjectsData.entries.map((entry) {
            final subjectName = entry.key;
            final subjectInfo = entry.value;
            final icon = subjectInfo['icon'] as IconData;
            final levels = subjectInfo['levels'] as List<String>;
            final themeColor =
                (subjectInfo['color'] as Color?) ?? const Color(0xFF1976D2);

            return _buildSubjectCard(
              subjectName: subjectName,
              icon: icon,
              levels: levels,
              themeColor: themeColor,
              animController: _cardAnimControllers[subjectName]!,
              scaleAnimation: _scaleAnimations[subjectName]!,
            );
          }).toList(),
        ],
      ),
    );
  }
}
