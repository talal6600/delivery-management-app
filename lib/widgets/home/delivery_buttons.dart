import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/delivery_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../config/constants.dart';
import '../../utils/helpers.dart';

class DeliveryButtons extends StatelessWidget {
  const DeliveryButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تسجيل توصيل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Delivery type buttons
            Consumer<InventoryProvider>(
              builder: (context, inventoryProvider, _) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDeliveryButton(
                            context,
                            AppConstants.deliveryJawy,
                            inventoryProvider.getInventoryCount(AppConstants.deliveryJawy),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDeliveryButton(
                            context,
                            AppConstants.deliverySawa,
                            inventoryProvider.getInventoryCount(AppConstants.deliverySawa),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDeliveryButton(
                            context,
                            AppConstants.deliveryMultiple,
                            inventoryProvider.getInventoryCount(AppConstants.deliveryMultiple),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDeliveryButton(
                            context,
                            AppConstants.deliveryIncomplete,
                            null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: _buildDeliveryButton(
                        context,
                        AppConstants.deliveryDevice,
                        null,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryButton(
    BuildContext context,
    String deliveryType,
    int? inventoryCount,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        _showDeliveryDialog(context, deliveryType);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Icon(Helpers.getDeliveryIcon(deliveryType)),
              const SizedBox(height: 4),
              Text(
                Helpers.getDeliveryTypeName(deliveryType),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (inventoryCount != null)
            Positioned(
              top: -8,
              left: -8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: inventoryCount > 0 ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$inventoryCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeliveryDialog(BuildContext context, String deliveryType) {
    // This will show a dialog to select time range and register delivery
    // Simplified version for now
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل ${Helpers.getDeliveryTypeName(deliveryType)}'),
        content: const Text('سيتم تطوير نموذج التسجيل قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // Quick registration with default values
              final deliveryProvider = Provider.of<DeliveryProvider>(
                context,
                listen: false,
              );
              deliveryProvider.addDelivery(
                type: deliveryType,
                timeRange: AppConstants.timeRangeLessThan2,
              );
              Navigator.pop(context);
              Helpers.showSnackBar(context, 'تم تسجيل التوصيل بنجاح');
            },
            child: const Text('تسجيل سريع'),
          ),
        ],
      ),
    );
  }
}
