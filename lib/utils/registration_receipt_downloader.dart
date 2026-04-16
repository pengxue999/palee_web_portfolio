import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:palee_web_portfolio/models/fee_model.dart';
import 'package:palee_web_portfolio/services/registration_service.dart';

final RegistrationService _registrationService = RegistrationService();

bool _shouldUseServerReceiptRenderer() {
  return true;
}

class RegistrationReceiptDownloadException implements Exception {
  const RegistrationReceiptDownloadException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<void> downloadRegistrationReceipt({
  required String registrationId,
  required DateTime registrationDate,
  required String studentName,
  required List<FeeModel> selectedFees,
  required int tuitionFee,
  required String? dormitoryLabel,
  required int dormitoryFee,
  required int totalFee,
  required int discountAmount,
  required int netFee,
  FutureOr<void> Function(String title, String message)? onStageChanged,
}) async {
  await _notifyReceiptStage(
    onStageChanged,
    title: 'ກຳລັງສ້າງໃບລົງທະບຽນ',
    message: 'ລະບົບກຳລັງຈັດຮູບແບບໃບລົງທະບຽນຂອງທ່ານ.',
  );

  final pdfBytes = await _buildReceiptPdf(
    registrationId: registrationId,
    registrationDate: registrationDate,
    studentName: studentName,
    selectedFees: selectedFees,
    tuitionFee: tuitionFee,
    dormitoryLabel: dormitoryLabel,
    dormitoryFee: dormitoryFee,
    totalFee: totalFee,
    discountAmount: discountAmount,
    netFee: netFee,
    onStageChanged: onStageChanged,
  );

  final fileName = 'registration_$registrationId.pdf';

  await _notifyReceiptStage(
    onStageChanged,
    title: 'ກຳລັງບັນທຶກ PDF',
    message: 'ລະບົບກຳລັງບັນທຶກໃບລົງທະບຽນເຂົ້າເຄື່ອງຂອງທ່ານ.',
  );

  if (kIsWeb) {
    await XFile.fromData(
      pdfBytes,
      mimeType: 'application/pdf',
      name: fileName,
    ).saveTo(fileName);
    return;
  }

  final location = await getSaveLocation(
    suggestedName: fileName,
    acceptedTypeGroups: const [
      XTypeGroup(label: 'PDF', extensions: ['pdf']),
    ],
  );

  if (location == null) {
    throw const RegistrationReceiptDownloadException(
      'ຍົກເລີກການບັນທຶກໃບລົງທະບຽນ',
    );
  }

  await XFile.fromData(
    pdfBytes,
    mimeType: 'application/pdf',
    name: fileName,
  ).saveTo(location.path);
}

Future<Uint8List> _buildReceiptPdf({
  required String registrationId,
  required DateTime registrationDate,
  required String studentName,
  required List<FeeModel> selectedFees,
  required int tuitionFee,
  required String? dormitoryLabel,
  required int dormitoryFee,
  required int totalFee,
  required int discountAmount,
  required int netFee,
  FutureOr<void> Function(String title, String message)? onStageChanged,
}) async {
  if (_shouldUseServerReceiptRenderer()) {
    try {
      await _notifyReceiptStage(
        onStageChanged,
        title: 'ກຳລັງປະກອບ PDF',
        message: 'ລະບົບກຳລັງສົ່ງຂໍ້ມູນໄປສ້າງ PDF ທີ່ server.',
      );

      return await _registrationService.createRegistrationReceiptPdf(
        registrationId: registrationId,
        registrationDate: registrationDate,
        studentName: studentName,
        selectedFees: selectedFees
            .map(
              (fee) => {
                'subject_name': fee.subjectName,
                'level_name': fee.levelName,
                'fee': fee.fee.toInt(),
              },
            )
            .toList(growable: false),
        tuitionFee: tuitionFee,
        dormitoryLabel: dormitoryLabel,
        dormitoryFee: dormitoryFee,
        totalFee: totalFee,
        discountAmount: discountAmount,
        netFee: netFee,
      );
    } catch (_) {
      // Fall back to local PDF generation if the API endpoint is unavailable.
    }
  }

  await _notifyReceiptStage(
    onStageChanged,
    title: 'ກຳລັງສ້າງຮູບໃບລົງທະບຽນ',
    message: 'ລະບົບກຳລັງວາດຮູບໃບລົງທະບຽນເພື່ອໃຫ້ຕົວອັກສອນລາວສະແດງຜົນຖືກຕ້ອງ.',
  );

  final receiptImageBytes = await _buildReceiptImage(
    registrationId: registrationId,
    registrationDate: registrationDate,
    studentName: studentName,
    selectedFees: selectedFees,
    tuitionFee: tuitionFee,
    dormitoryLabel: dormitoryLabel,
    dormitoryFee: dormitoryFee,
    totalFee: totalFee,
    discountAmount: discountAmount,
    netFee: netFee,
  );

  await _notifyReceiptStage(
    onStageChanged,
    title: 'ກຳລັງປະກອບ PDF',
    message: 'ລະບົບກຳລັງນຳຮູບໃບລົງທະບຽນໄປປະກອບເປັນໄຟລ໌ PDF.',
  );

  await Future<void>.delayed(const Duration(milliseconds: 16));

  if (kIsWeb) {
    return _composeReceiptPdf(receiptImageBytes);
  }

  return compute(_composeReceiptPdf, receiptImageBytes);
}

Future<Uint8List> _composeReceiptPdf(Uint8List receiptImageBytes) {
  final document = pw.Document();
  final receiptImage = pw.MemoryImage(receiptImageBytes);

  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) {
        return pw.SizedBox.expand(
          child: pw.Image(receiptImage, fit: pw.BoxFit.fill),
        );
      },
    ),
  );

  return document.save();
}

Future<void> _notifyReceiptStage(
  FutureOr<void> Function(String title, String message)? onStageChanged, {
  required String title,
  required String message,
}) async {
  if (onStageChanged == null) {
    return;
  }

  await onStageChanged(title, message);
  await Future<void>.delayed(const Duration(milliseconds: 16));
}

Future<Uint8List> _buildReceiptImage({
  required String registrationId,
  required DateTime registrationDate,
  required String studentName,
  required List<FeeModel> selectedFees,
  required int tuitionFee,
  required String? dormitoryLabel,
  required int dormitoryFee,
  required int totalFee,
  required int discountAmount,
  required int netFee,
}) async {
  final renderScale = kIsWeb ? 0.62 : 0.9;
  final pageWidth = 1240.0 * renderScale;
  final pageHeight = 1754.0 * renderScale;
  final fontScale = 1.4 * renderScale;
  final horizontalPadding = 72.0 * renderScale;
  final topPadding = 74.0 * renderScale;
  final blockGap = 24.0 * renderScale;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, pageWidth, pageHeight));

  canvas.drawRect(
    Rect.fromLTWH(0, 0, pageWidth, pageHeight),
    Paint()..color = Colors.white,
  );

  final textColor = const Color(0xFF252525);
  final mutedColor = const Color(0xFF8A8A8A);
  final borderColor = const Color(0xFFE4E4E4);
  final strongBorderColor = const Color(0xFFBDBDBD);
  final successColor = const Color(0xFF15803D);

  void drawRule({
    required Offset start,
    required Offset end,
    required Color color,
    double strokeWidth = 1,
  }) {
    canvas.drawLine(
      start,
      end,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth,
    );
  }

  String fmt(int n) => NumberFormat('#,###').format(n);

  String fmtDate(DateTime value) {
    final hasTime = value.hour != 0 || value.minute != 0 || value.second != 0;
    return hasTime
        ? DateFormat('dd-MM-yyyy HH:mm:ss').format(value)
        : DateFormat('dd/MM/yyyy').format(value);
  }

  TextStyle style({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
    double height = 1.3,
  }) {
    return TextStyle(
      fontFamily: 'NotoSansLao',
      fontSize: fontSize * fontScale,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  TextPainter layoutText(
    String text,
    TextStyle textStyle, {
    double? maxWidth,
    TextAlign textAlign = TextAlign.left,
    int? maxLines,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textAlign: textAlign,
      textDirection: ui.TextDirection.ltr,
      maxLines: maxLines,
      ellipsis: maxLines == null ? null : '...',
    );
    painter.layout(maxWidth: maxWidth ?? pageWidth);
    return painter;
  }

  Size paintText(
    String text,
    TextStyle textStyle,
    Offset offset, {
    double? maxWidth,
    TextAlign textAlign = TextAlign.left,
    int? maxLines,
  }) {
    final painter = layoutText(
      text,
      textStyle,
      maxWidth: maxWidth,
      textAlign: textAlign,
      maxLines: maxLines,
    );

    final dx = switch (textAlign) {
      TextAlign.right || TextAlign.end => offset.dx - painter.width,
      TextAlign.center => offset.dx - (painter.width / 2),
      _ => offset.dx,
    };

    painter.paint(canvas, Offset(dx, offset.dy));
    return painter.size;
  }

  void drawDashedLine({
    required Offset start,
    required double width,
    required Color color,
    double dashWidth = 10,
    double gapWidth = 7,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    var currentX = start.dx;
    final endX = start.dx + width;
    while (currentX < endX) {
      final nextX = math.min(currentX + dashWidth, endX);
      canvas.drawLine(
        Offset(currentX, start.dy),
        Offset(nextX, start.dy),
        paint,
      );
      currentX = nextX + gapWidth;
    }
  }

  final orgLaoStyle = style(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textColor,
    height: 1.15,
  );
  final orgEnStyle = style(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: mutedColor,
    height: 1.1,
  );
  final smallLabelStyle = style(fontSize: 12, color: mutedColor);
  final dateStyle = style(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: textColor,
    height: 1.2,
  );
  final titleStyle = style(
    fontSize: 38,
    fontWeight: FontWeight.w800,
    color: textColor,
  );
  final infoLabelStyle = style(fontSize: 13, color: mutedColor, height: 1.2);
  final infoValueStyle = style(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: textColor,
    height: 1.2,
  );
  final tableHeaderStyle = style(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: mutedColor,
  );
  final tableCellStyle = style(fontSize: 15, color: textColor, height: 1.25);
  final summaryLabelStyle = style(fontSize: 15, color: mutedColor, height: 1.2);
  final summaryValueStyle = style(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  final amountDueLabelStyle = style(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: textColor,
  );
  final amountDueValueStyle = style(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: textColor,
  );
  final footerLaoStyle = style(fontSize: 14, color: mutedColor, height: 1.15);
  final footerEnStyle = style(fontSize: 12, color: mutedColor, height: 1.1);

  var y = topPadding;

  paintText(
    'ສູນປາລີ ບຳລຸງນັກຮຽນເກັ່ງ',
    orgLaoStyle,
    Offset(horizontalPadding, y),
  );
  y += 46;
  paintText(
    'Palee Elite Training Center',
    orgEnStyle,
    Offset(horizontalPadding, y),
  );

  final headerRuleY = topPadding + 92;
  drawRule(
    start: Offset(0, headerRuleY),
    end: Offset(pageWidth, headerRuleY),
    color: borderColor,
    strokeWidth: 1.5,
  );

  paintText(
    'ວັນທີ',
    smallLabelStyle,
    Offset(pageWidth - horizontalPadding, topPadding),
    textAlign: TextAlign.right,
  );
  paintText(
    fmtDate(registrationDate),
    dateStyle,
    Offset(pageWidth - horizontalPadding, topPadding + 24),
    textAlign: TextAlign.right,
  );

  paintText(
    'ໃບລົງທະບຽນ',
    titleStyle,
    Offset(pageWidth / 2, headerRuleY + 92),
    textAlign: TextAlign.center,
  );

  var infoY = headerRuleY + 182;
  final registrationLabelPainter = layoutText(
    'ລະຫັດໃບລົງທະບຽນ:',
    infoLabelStyle,
    maxLines: 1,
  );
  final studentLabelPainter = layoutText(
    'ຊື່ ແລະ ນາມສະກຸນ:',
    infoLabelStyle,
    maxLines: 1,
  );
  final infoColumnGap = 6.0 * renderScale;
  final registrationValueX =
      horizontalPadding + registrationLabelPainter.width + infoColumnGap;
  final registrationValueWidth =
      pageWidth - registrationValueX - horizontalPadding;
  final studentValueX =
      horizontalPadding + studentLabelPainter.width + infoColumnGap;
  final studentValueWidth = pageWidth - studentValueX - horizontalPadding;

  final registrationValuePainter = layoutText(
    registrationId,
    infoValueStyle,
    maxWidth: registrationValueWidth,
    maxLines: 1,
  );
  registrationLabelPainter.paint(canvas, Offset(horizontalPadding, infoY));
  registrationValuePainter.paint(canvas, Offset(registrationValueX, infoY));

  infoY +=
      math.max(
        registrationLabelPainter.height,
        registrationValuePainter.height,
      ) +
      14;

  final studentValuePainter = layoutText(
    studentName,
    infoValueStyle,
    maxWidth: studentValueWidth,
    maxLines: 2,
  );
  studentLabelPainter.paint(canvas, Offset(horizontalPadding, infoY));
  studentValuePainter.paint(canvas, Offset(studentValueX, infoY));

  var tableY =
      infoY +
      math.max(studentLabelPainter.height, studentValuePainter.height) +
      44;

  drawRule(
    start: Offset(0, tableY - 34),
    end: Offset(pageWidth, tableY - 34),
    color: borderColor,
    strokeWidth: 1.3,
  );

  final tableLeft = horizontalPadding;
  final tableRight = pageWidth - horizontalPadding;
  final tableWidth = tableRight - tableLeft;
  final subjectWidth = tableWidth * 0.46;
  final levelWidth = tableWidth * 0.18;
  final amountWidth = tableWidth - subjectWidth - levelWidth;

  paintText('ລາຍວິຊາ', tableHeaderStyle, Offset(tableLeft, tableY));
  paintText(
    'ຊັ້ນຮຽນ/ລະດັບ',
    tableHeaderStyle,
    Offset(tableLeft + subjectWidth + (levelWidth / 2), tableY),
    textAlign: TextAlign.center,
    maxWidth: levelWidth,
  );
  paintText(
    'ຄ່າຮຽນ',
    tableHeaderStyle,
    Offset(tableRight, tableY),
    textAlign: TextAlign.right,
    maxWidth: amountWidth,
  );

  tableY += 34;
  drawRule(
    start: Offset(tableLeft, tableY),
    end: Offset(tableRight, tableY),
    color: borderColor,
    strokeWidth: 1.5,
  );

  tableY += blockGap;
  for (final fee in selectedFees) {
    final subjectPainter = layoutText(
      fee.subjectName,
      tableCellStyle,
      maxWidth: subjectWidth - 12,
    );
    final levelPainter = layoutText(
      fee.levelName,
      tableCellStyle,
      maxWidth: levelWidth - 12,
      textAlign: TextAlign.center,
    );
    final amountPainter = layoutText(
      '${fmt(fee.fee.toInt())} ກີບ',
      tableCellStyle,
      maxWidth: amountWidth - 12,
      textAlign: TextAlign.right,
    );

    final rowHeight = math.max(
      36.0,
      math.max(
            subjectPainter.height,
            math.max(levelPainter.height, amountPainter.height),
          ) +
          22,
    );

    subjectPainter.paint(canvas, Offset(tableLeft, tableY));
    levelPainter.paint(
      canvas,
      Offset(
        tableLeft + subjectWidth + ((levelWidth - levelPainter.width) / 2),
        tableY,
      ),
    );
    amountPainter.paint(
      canvas,
      Offset(tableRight - amountPainter.width, tableY),
    );

    tableY += rowHeight;
    drawRule(
      start: Offset(tableLeft, tableY),
      end: Offset(tableRight, tableY),
      color: borderColor,
      strokeWidth: 1.2,
    );
    tableY += 18;
  }

  var summaryY = tableY + 28;
  final summaryRight = tableRight;
  final summaryValueWidth = 220.0;
  final summaryGap = 26.0;
  final summaryLabelRight = summaryRight - summaryValueWidth - summaryGap;

  paintText(
    'ລວມທັງໝົດ:',
    summaryLabelStyle,
    Offset(summaryLabelRight, summaryY),
    textAlign: TextAlign.right,
    maxWidth: 240,
  );
  paintText(
    '${fmt(totalFee)} ກີບ',
    summaryValueStyle,
    Offset(summaryRight, summaryY),
    textAlign: TextAlign.right,
    maxWidth: summaryValueWidth,
  );

  summaryY += 30;
  if (discountAmount > 0) {
    paintText(
      'ສ່ວນຫຼຸດ:',
      style(fontSize: 15, color: successColor),
      Offset(summaryLabelRight, summaryY),
      textAlign: TextAlign.right,
      maxWidth: 240,
    );
    paintText(
      '- ${fmt(discountAmount)} ກີບ',
      style(fontSize: 15, color: successColor, fontWeight: FontWeight.w600),
      Offset(summaryRight, summaryY),
      textAlign: TextAlign.right,
      maxWidth: summaryValueWidth,
    );
    summaryY += 28;
  } else {
    summaryY += 4;
  }

  drawDashedLine(
    start: Offset(summaryRight - 320, summaryY),
    width: 320,
    color: strongBorderColor,
    dashWidth: 9,
    gapWidth: 5,
  );

  summaryY += 14;
  paintText(
    'ຕ້ອງຈ່າຍ:',
    amountDueLabelStyle,
    Offset(summaryLabelRight, summaryY),
    textAlign: TextAlign.right,
    maxWidth: 260,
  );
  paintText(
    '${fmt(netFee)} ກີບ',
    amountDueValueStyle,
    Offset(summaryRight, summaryY - 6),
    textAlign: TextAlign.right,
    maxWidth: summaryValueWidth,
  );

  final footerLineY = math.min(summaryY + 88, pageHeight - 170);
  drawDashedLine(
    start: Offset(horizontalPadding, footerLineY),
    width: pageWidth - (horizontalPadding * 2),
    color: borderColor,
    dashWidth: 7,
    gapWidth: 4,
  );
  canvas.drawCircle(
    Offset(horizontalPadding, footerLineY),
    14,
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill,
  );
  canvas.drawCircle(
    Offset(horizontalPadding, footerLineY),
    14,
    Paint()
      ..color = strongBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2,
  );
  canvas.drawCircle(
    Offset(pageWidth - horizontalPadding, footerLineY),
    14,
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill,
  );
  canvas.drawCircle(
    Offset(pageWidth - horizontalPadding, footerLineY),
    14,
    Paint()
      ..color = strongBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2,
  );
  paintText(
    'ຂໍໃຫ້ທ່ານ ຈົ່ງໂຊກດີ',
    footerLaoStyle,
    Offset(horizontalPadding, footerLineY + 48),
    maxWidth: 380,
  );
  paintText(
    'Good luck with your studies!',
    footerEnStyle,
    Offset(horizontalPadding, footerLineY + 78),
    maxWidth: 420,
  );
  paintText(
    '#$registrationId',
    footerEnStyle,
    Offset(pageWidth - horizontalPadding, footerLineY + 62),
    textAlign: TextAlign.right,
    maxWidth: 180,
  );

  final picture = recorder.endRecording();
  final image = await picture.toImage(pageWidth.toInt(), pageHeight.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) {
    throw StateError('Unable to encode receipt image.');
  }

  return byteData.buffer.asUint8List();
}
