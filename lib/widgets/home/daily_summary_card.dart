import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/delivery_provider.dart';
import '../../config/constants.dart';
import '../../utils/helpers.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, deliveryProvider, _) {
        final summary = deliveryProvider.getDailySummary(
          deliveryProvider.selectedDate,
        );
        final dailyCommission = deliveryProvider.getDailyCommission(
          deliveryProvider.selectedDate,
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ملخص اليوم',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${dailyCommission.toStringAsFixed(2)} ريال',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Summary grid
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSummaryItem(
                      context,
                      Helpers.getDeliveryTypeName(AppConstants.deliveryJawy),
                      summary[AppConstants.deliveryJawy] ?? 0,
                      Icons.sim_card,
                    ),
                    _buildSummaryItem(
                      context,
                      Helpers.getDeliveryTypeName(AppConstants.deliverySawa),
                      summary[AppConstants.deliverySawa] ?? 0,
                      Icons.sim_card_outlined,
                    ),
                    _buildSummaryItem(
                      context,
                      Helpers.getDeliveryTypeName(AppConstants.deliveryMultiple),
                      summary[AppConstants.deliveryMultiple] ?? 0,
                      Icons.sim_card_download,
                    ),
                    _buildSummaryItem(
                      context,
                      Helpers.getDeliveryTypeName(AppConstants.deliveryIncomplete),
                      summary[AppConstants.deliveryIncomplete] ?? 0,
                      Icons.cancel_outlined,
                    ),
                    _buildSummaryItem(
                      context,
                      Helpers.getDeliveryTypeName(AppConstants.deliveryDevice),
                      summary[AppConstants.deliveryDevice] ?? 0,
                      Icons.phone_android,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    int count,
    IconData icon,
  ) {
    return Container(
      width: (MediaQuery.of(context).size.width - 56) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
