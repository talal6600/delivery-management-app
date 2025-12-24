import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/delivery_provider.dart';
import '../../utils/date_utils.dart';

class DateNavigationBar extends StatelessWidget {
  const DateNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, deliveryProvider, _) {
        final selectedDate = deliveryProvider.selectedDate;
        final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous day button
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () => deliveryProvider.previousDay(),
              ),
              
              // Date display and picker
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    
                    if (pickedDate != null) {
                      deliveryProvider.setSelectedDate(pickedDate);
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        DateTimeUtils.getDayName(selectedDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateTimeUtils.formatDate(selectedDate),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      if (isToday)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'اليوم',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Next day button
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => deliveryProvider.nextDay(),
              ),
            ],
          ),
        );
      },
    );
  }
}
