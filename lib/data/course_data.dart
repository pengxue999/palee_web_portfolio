import 'package:flutter/material.dart';

final List<Map<String, dynamic>> courses = [
  {
    'title': 'ຄະນິດສາດ',
    'level': 'ມ3-ມ7',
    'description': 'ສອນຕາມຫຼັກສູດຂອງກະຊວງສຶກສາທິການ ແລະ ກິລາ, ຫຼັກສູດຂອງໄທ',
    'icon': Icons.calculate,
    'gradient': [
      Color(0xFF2196F3), // Blue 500
      Color(0xFF1976D2), // Blue 700
    ], // ສີຟ້າ: ຄວາມມີເຫດຜົນ, ຕົວເລກ
  },
  {
    'title': 'ຟີຊິກສາດ',
    'level': 'ມ3-ມ7',
    'description': 'ສອນຕາມຫຼັກສູດຂອງກະຊວງສຶກສາທິການ ແລະ ກິລາ, ຫຼັກສູດຂອງໄທ',
    'icon': Icons.flash_on,
    'gradient': [
      Color(0xFFFF9800), // Orange 500
      Color(0xFFF57C00), // Orange 700
    ], // ສີສົ້ມ: ພະລັງງານ, ໄຟຟ້າ, ການເຄື່ອນທີ່ (ເໝາະກັບຟີຊິກທີ່ສຸດ)
  },
  {
    'title': 'ເຄມີສາດ',
    'level': 'ມ3-ມ7',
    'description': 'ສອນຕາມຫຼັກສູດຂອງກະຊວງສຶກສາທິການ ແລະ ກິລາ, ຫຼັກສູດຂອງໄທ',
    'icon': Icons.science,
    'gradient': [
      Color(0xFF4CAF50), // Green 500
      Color(0xFF388E3C), // Green 700
    ], // ສີຂຽວ: ທຳມະຊາດ, ສານເຄມີ
  },
  {
    'title': 'ພາສາອັງກິດ',
    'level': 'ເລີ່ມຕົ້ນ-ສູງ',
    'description': 'ສອນຕາມຫຼັກສູດຂອງອັງກິດ (Cambridge/Oxford)',
    'icon': Icons.language, // ປ່ຽນ icon ເປັນໜ່ວຍໂລກໃຫ້ເບິ່ງ inter ຂຶ້ນ (ຫຼືໃຊ້ menu_book ຄືເກົ່າກໍໄດ້)
    'gradient': [
      Color(0xFF9C27B0), // Purple 500
      Color(0xFF7B1FA2), // Purple 700
    ], // ສີມ່ວງ: ພາສາ, ວັດທະນະທຳ, ຈິນຕະນາການ
  },
  {
    'title': 'ພາສາຈີນ',
    'level': 'HSK1-HSK4',
    'description': 'ສອນຕາມຫຼັກສູດຂອງລັດຖະບານຈີນ',
    'icon': Icons.translate,
    'gradient': [
      Color(0xFFD32F2F), // Red 700
      Color(0xFFB71C1C), // Red 900
    ], // ສີແດງ: ສີປະຈຳຊາດຈີນ (ໃຊ້ໂທນເຂັ້ມຂຶ້ນໜ້ອຍໜຶ່ງໃຫ້ຕັດກັບຕົວໜັງສືສີຂາວ)
  },
  {
    'title': 'ສຳມະນາ',
    'level': 'ທົ່ວໄປ',
    'description': 'ແລກປ່ຽນຄວາມຮູ້, ປະສົບການ, ທຶນການສຶກສາ ແລະ ການວາງແຜນຮຽນ.',
    'icon': Icons.groups, // ຫຼືໃຊ້ Icons.school
    'gradient': [
      Color(0xFF009688), // Teal 500
      Color(0xFF00796B), // Teal 700
    ], // ສີຂຽວອົມຟ້າ (Teal): ຄວາມເປັນມືອາຊີບ, ຄວາມສະຫງົບ, ການປຶກສາຫາລື
  },
];