// import 'package:flutter/cupertino.dart';
//
// import '../../components/custom_labeltext.dart';
// import '../../components/custom_textField.dart';
//
// class TotalParticipantsInput extends StatelessWidget {
//   final ValueChanged<String> onChanged;
//   const TotalParticipantsInput({required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         LabelText(label: "Activity No. of Participants"),
//         const SizedBox(height: 10),
//         CustomTextFormField(
//           hintText: 'Total Participants',
//           onChanged: onChanged,
//           textInputType: TextInputType.number,
//           validator: (v) => v!.isEmpty ? 'Please enter the number of participants' : null,
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../components/custom_labeltext.dart';

// Data model for the table rows
class GradeParticipant {
  final String grade;
  int boys;
  int girls;

  GradeParticipant({required this.grade, this.boys = 0, this.girls = 0});

  int get total => boys + girls;
}

class TotalParticipantsInput extends StatelessWidget {
  final List<GradeParticipant> participants;
  final VoidCallback onUpdate;

  const TotalParticipantsInput({
    super.key,
    required this.participants,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(label: "Activity Participants Breakdown"),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
          columnWidths: const {
            0: FlexColumnWidth(2), // Grade
            1: FlexColumnWidth(1.5), // Boys
            2: FlexColumnWidth(1.5), // Girls
            3: FlexColumnWidth(1.5), // Total
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildHeader(),
            ...participants.map((p) => _buildRow(p)).toList(),
            // _buildTotalFooter(),
          ],
        ),
      ],
    );
  }

  TableRow _buildHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[200]),
      children: const [
        _CellText("Grade", isHeader: true),
        _CellText("Boys", isHeader: true),
        _CellText("Girls", isHeader: true),
        //_CellText("Total", isHeader: true),
      ],
    );
  }

  TableRow _buildRow(GradeParticipant p) {
    return TableRow(
      children: [
        _CellText(p.grade),
        _CellInput(
          initialValue: p.boys == 0 ? '' : p.boys.toString(),
          onChanged: (val) {
            p.boys = int.tryParse(val) ?? 0;
            onUpdate();
          },
        ),
        _CellInput(
          initialValue: p.girls == 0 ? '' : p.girls.toString(),
          onChanged: (val) {
            p.girls = int.tryParse(val) ?? 0;
            onUpdate();
          },
        ),
        //_CellText(p.total.toString()),
      ],
    );
  }

  TableRow _buildTotalFooter() {
    int grandTotal = participants.fold(0, (sum, item) => sum + item.total);
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[100]),
      children: [
        const _CellText("Grand Total", isHeader: true),
        const SizedBox(),
        const SizedBox(),
        _CellText(grandTotal.toString(), isHeader: true),
      ],
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;
  final bool isHeader;
  const _CellText(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal, fontSize: 12),
      ),
    );
  }
}

class _CellInput extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  const _CellInput({required this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(border: InputBorder.none, hintText: '0'),
        onChanged: onChanged,
      ),
    );
  }
}