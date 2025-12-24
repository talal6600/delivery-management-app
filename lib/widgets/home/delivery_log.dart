import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/delivery_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/date_utils.dart';

class DeliveryLog extends StatelessWidget {
  const DeliveryLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, deliveryProvider, _) {
        final deliveries = deliveryProvider.getDeliveriesForDate(
          deliveryProvider.selectedDate,
        );

        if (deliveries.isEmpty) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد عمليات توصيل لهذا اليوم',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'سجل التوصيلات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'المجموع: ${deliveries.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: deliveries.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final delivery = deliveries[index];
                  return ListTile(
                    leading: Icon(
                      Helpers.getDeliveryIcon(delivery.type),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      Helpers.getDeliveryTypeName(delivery.type),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      delivery.timeRange != null
                          ? Helpers.getTimeRangeName(delivery.timeRange!)
                          : DateTimeUtils.formatTime(delivery.dateTime),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${delivery.commission.toStringAsFixed(2)} ريال',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            final confirmed = await Helpers.showConfirmDialog(
                              context,
                              'حذف توصيل',
                              'هل أنت متأكد من حذف هذا التوصيل؟',
                            );
                            if (confirmed) {
                              deliveryProvider.deleteDelivery(delivery.id);
                              if (context.mounted) {
                                Helpers.showSnackBar(
                                  context,
                                  'تم حذف التوصيل بنجاح',
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
