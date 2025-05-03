import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestionapp/models/reservation_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReservationDetailScreen extends StatefulWidget {
  final Reservation reservation;
  final String roomName;
  const ReservationDetailScreen({
    super.key,
    required this.reservation,
    required this.roomName,
  });

  @override
  State<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  String _calculateNights(String dfrom, String dto) {
    try {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final DateTime startDate = formatter.parse(dfrom);
      final DateTime endDate = formatter.parse(dto);
      final int nights = endDate.difference(startDate).inDays;
      return '$nights nights';
    } catch (e) {
      return 'Invalid dates';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text('Reservation'.tr),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                ReservationDetailRow(
                  label: 'Accommodation Name:'.tr,
                  value: widget.roomName,
                ),
                ReservationDetailRow(
                  label: 'Customer Name:'.tr,
                  value: widget.reservation.customerName,
                ),
                ReservationDetailRow(
                  label: 'Check In:'.tr,
                  value: widget.reservation.rooms.first.dfrom,
                ),
                ReservationDetailRow(
                  label: 'Check Out:'.tr,
                  value: widget.reservation.rooms.first.dto,
                ),
                ReservationDetailRow(
                  label: 'Number of nights:'.tr,
                  value: _calculateNights(
                    widget.reservation.rooms.first.dfrom,
                    widget.reservation.rooms.first.dto,
                  ),
                ),
                ReservationDetailRow(
                  label: 'Occupancy:'.tr,
                  value:
                      '${widget.reservation.rooms.first.occupancy?.adults} adults, '
                      '${widget.reservation.rooms.first.occupancy?.teens} teens, '
                      '${widget.reservation.rooms.first.occupancy?.children} children, '
                      '${widget.reservation.rooms.first.occupancy?.babies} babies',
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.reservation.customerPhone),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Phone number copied to clipboard'.tr),
                      ),
                    );
                  },
                  child: ReservationDetailRow(
                    label: 'Guest Phone:'.tr,
                    value: widget.reservation.customerPhone,
                    isPhone: true,
                  ),
                ),
                ReservationDetailRow(
                  label: 'Remarks:'.tr,
                  value:
                      (widget.reservation.notes.isEmpty)
                          ? 'N/A'.tr
                          : widget.reservation.notes
                              .map((e) => e.remarks)
                              .join(', '),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReservationDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool? isPhone;

  const ReservationDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
          if (isPhone != null && isPhone == true)
            Icon(Icons.copy, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
