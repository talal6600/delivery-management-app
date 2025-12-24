import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/delivery_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/settings_provider.dart';
import '../../config/routes.dart';
import '../../widgets/home/date_navigation_bar.dart';
import '../../widgets/home/weekly_goal_slider.dart';
import '../../widgets/home/daily_summary_card.dart';
import '../../widgets/home/delivery_buttons.dart';
import '../../widgets/home/delivery_log.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DeliveryProvider(userId: user.id),
        ),
        ChangeNotifierProvider(
          create: (_) => InventoryProvider(userId: user.id),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(userId: user.id),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('مرحباً، ${user.displayName}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authProvider.logout();
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              },
            ),
          ],
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              // Date navigation bar
              DateNavigationBar(),
              
              // Weekly goal slider
              WeeklyGoalSlider(),
              
              // Daily summary
              DailySummaryCard(),
              
              // Delivery registration buttons
              DeliveryButtons(),
              
              // Delivery log
              DeliveryLog(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'المخزون',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_gas_station),
              label: 'الوقود',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'التقارير',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                // Already on home
                break;
              case 1:
                Navigator.of(context).pushNamed(AppRoutes.inventory);
                break;
              case 2:
                Navigator.of(context).pushNamed(AppRoutes.fuel);
                break;
              case 3:
                Navigator.of(context).pushNamed(AppRoutes.reports);
                break;
            }
          },
        ),
      ),
    );
  }
}
