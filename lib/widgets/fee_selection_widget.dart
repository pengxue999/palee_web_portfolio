import 'package:flutter/material.dart';

import '../models/fee_model.dart';

class FeeSelectionWidget extends StatefulWidget {
  final List<FeeModel> fees;
  final Set<String> selectedFeeIds;
  final bool isLoading;
  final ValueChanged<Set<String>> onChanged;

  const FeeSelectionWidget({
    super.key,
    required this.fees,
    required this.selectedFeeIds,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  State<FeeSelectionWidget> createState() => _FeeSelectionWidgetState();
}

class _FeeSelectionWidgetState extends State<FeeSelectionWidget> {
  String? _selectedCategory;
  String? _selectedSubject;

  List<String> get _categories {
    final categories =
        widget.fees
            .map((fee) => fee.subjectCategory)
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return ['ທັງໝົດ', ...categories];
  }

  List<FeeModel> get _filteredByCategory {
    if (_selectedCategory == null || _selectedCategory == 'ທັງໝົດ') {
      return widget.fees;
    }
    return widget.fees
        .where((fee) => fee.subjectCategory == _selectedCategory)
        .toList();
  }

  Map<String, List<FeeModel>> get _groupedBySubject {
    final map = <String, List<FeeModel>>{};
    for (final fee in _filteredByCategory) {
      map.putIfAbsent(fee.subjectName, () => []).add(fee);
    }
    for (final list in map.values) {
      list.sort((a, b) => a.levelName.compareTo(b.levelName));
    }
    return map;
  }

  List<String> get _subjects => _groupedBySubject.keys.toList()..sort();

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'ທັງໝົດ';
  }

  @override
  void didUpdateWidget(covariant FeeSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_categories.contains(_selectedCategory)) {
      _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
    }
    if (!_subjects.contains(_selectedSubject)) {
      _selectedSubject = _subjects.isNotEmpty ? _subjects.first : null;
    }
  }

  void _toggleExclusive(FeeModel selectedFee) {
    if (widget.isLoading) {
      return;
    }

    final next = Set<String>.from(widget.selectedFeeIds);
    final sameSubjectFees = _groupedBySubject[selectedFee.subjectName] ?? [];

    if (next.contains(selectedFee.feeId)) {
      next.remove(selectedFee.feeId);
      widget.onChanged(next);
      return;
    }

    for (final fee in sameSubjectFees) {
      next.remove(fee.feeId);
    }
    next.add(selectedFee.feeId);
    widget.onChanged(next);
  }

  String _formatFee(double amount) {
    final digits = amount.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int index = 0; index < digits.length; index++) {
      final reverseIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedBySubject = _groupedBySubject;
    final currentSubject =
        _selectedSubject ?? (_subjects.isNotEmpty ? _subjects.first : null);
    final currentFees = currentSubject == null
        ? <FeeModel>[]
        : groupedBySubject[currentSubject] ?? <FeeModel>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_categories.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              final selected = category == (_selectedCategory ?? 'ທັງໝົດ');
              return ChoiceChip(
                label: Text(category),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _selectedCategory = category;
                    _selectedSubject = _subjects.isNotEmpty
                        ? _subjects.first
                        : null;
                  });
                },
                selectedColor: const Color(0xFFDBEAFE),
                labelStyle: TextStyle(
                  color: selected
                      ? const Color(0xFF1D4ED8)
                      : const Color(0xFF4B5563),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                side: BorderSide(
                  color: selected
                      ? const Color(0xFF93C5FD)
                      : const Color(0xFFE5E7EB),
                ),
                backgroundColor: Colors.white,
              );
            }).toList(),
          ),
        if (_categories.isNotEmpty) const SizedBox(height: 16),
        if (widget.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (widget.fees.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Center(
              child: Text(
                'ບໍ່ພົບຂໍ້ມູນວິຊາຮຽນ',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 15),
              ),
            ),
          )
        else ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _subjects.map((subject) {
                final active = subject == currentSubject;
                final selectedCount =
                    (groupedBySubject[subject] ?? const <FeeModel>[])
                        .where(
                          (fee) => widget.selectedFeeIds.contains(fee.feeId),
                        )
                        .length;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _selectedSubject = subject),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: active
                            ? const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
                              )
                            : null,
                        color: active ? null : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: active
                              ? Colors.transparent
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            subject,
                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : const Color(0xFF374151),
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                          if (selectedCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: active
                                    ? Colors.white24
                                    : const Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$selectedCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 3;
              if (width < 760) {
                crossAxisCount = 2;
              }
              if (width < 420) {
                crossAxisCount = 1;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentFees.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 132,
                ),
                itemBuilder: (context, index) {
                  final fee = currentFees[index];
                  final selected = widget.selectedFeeIds.contains(fee.feeId);

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _toggleExclusive(fee),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFF0FDF4)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFE5E7EB),
                          width: selected ? 1.8 : 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  fee.subjectName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? const Color(0xFF15803D)
                                        : const Color(0xFF111827),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                fee.levelName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              if (selected) ...[
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF22C55E),
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'ຄ່າຮຽນ ${_formatFee(fee.fee)} ກີບ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? const Color(0xFF15803D)
                                  : const Color(0xFF2563EB),
                            ),
                          ),
                          const Spacer(),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _Tag(
                                text: fee.subjectCategory,
                                color: const Color(0xFFE0E7FF),
                                textColor: const Color(0xFF4338CA),
                              ),
                              _Tag(
                                text: fee.academicYear,
                                color: const Color(0xFFECFDF5),
                                textColor: const Color(0xFF047857),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Tag({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
