# API Documentation - توثيق الواجهات البرمجية

## نماذج البيانات (Data Models)

### User Model
نموذج المستخدم (مدير أو مندوب)

```dart
class User {
  String id;              // معرف فريد
  String username;        // اسم المستخدم
  String password;        // كلمة المرور
  String displayName;     // اسم العرض
  String role;           // admin أو delegate
  DateTime? subscriptionEnd;  // تاريخ انتهاء الاشتراك (للمندوبين)
  DateTime createdAt;    // تاريخ الإنشاء
  bool isActive;         // حالة النشاط
}
```

**الأدوار المتاحة:**
- `admin`: مدير النظام (صلاحيات كاملة)
- `delegate`: مندوب (صلاحيات محدودة)

### Delivery Model
نموذج التوصيل

```dart
class Delivery {
  String id;              // معرف فريد
  String userId;          // معرف المستخدم
  String type;           // نوع التوصيل
  String? timeRange;     // الفترة الزمنية
  int? simCount;         // عدد الشرائح (للمتعدد)
  double commission;     // العمولة بالريال
  DateTime dateTime;     // تاريخ ووقت التوصيل
  String? notes;         // ملاحظات
}
```

**أنواع التوصيل:**
- `jawy`: جوي
- `sawa`: سوا
- `multiple`: متعدد
- `incomplete`: لم يكتمل
- `device`: جهاز

**الفترات الزمنية:**
- `less_than_2`: أقل من ساعتين
- `2_to_3`: 2-3 ساعات
- `more_than_3`: أكثر من 3 ساعات

### InventoryTransaction Model
نموذج معاملة المخزون

```dart
class InventoryTransaction {
  String id;                  // معرف فريد
  String userId;              // معرف المستخدم
  String type;               // نوع الشريحة
  int quantity;              // الكمية
  String transactionType;    // نوع المعاملة
  DateTime dateTime;         // التاريخ
  String? notes;             // ملاحظات
  String? linkedDeliveryId;  // معرف التوصيل المرتبط
}
```

**أنواع المعاملات:**
- `received`: استلام
- `used`: مستخدم (عند التوصيل)
- `faulty`: معطل
- `returned`: مرتجع

### FaultySim Model
نموذج الشريحة المعطلة

```dart
class FaultySim {
  String id;              // معرف فريد
  String userId;          // معرف المستخدم
  String type;           // نوع الشريحة
  int quantity;          // الكمية
  DateTime dateTime;     // التاريخ
  String status;         // الحالة
  String? notes;         // ملاحظات
}
```

**الحالات:**
- `pending`: قيد الانتظار
- `returned_to_company`: مرتجع للشركة
- `returned_to_inventory`: مرتجع للمخزون

### FuelEntry Model
نموذج تعبئة الوقود

```dart
class FuelEntry {
  String id;              // معرف فريد
  String userId;          // معرف المستخدم
  String fuelType;       // نوع الوقود
  double liters;         // عدد اللترات
  double cost;           // التكلفة بالريال
  double? distance;      // المسافة المقطوعة (اختياري)
  DateTime dateTime;     // التاريخ
  String? notes;         // ملاحظات
}
```

**أنواع الوقود:**
- `fuel_91`: أخضر 91 (2.18 ريال/لتر)
- `fuel_95`: أحمر 95 (2.33 ريال/لتر)

**معدل الاستهلاك:**
```dart
double? consumptionRate = distance / liters;  // كم/لتر
```

### AppSettings Model
نموذج إعدادات التطبيق

```dart
class AppSettings {
  String userId;                                    // معرف المستخدم
  double weeklyGoal;                               // الهدف الأسبوعي
  String preferredFuelType;                        // نوع الوقود المفضل
  Map<String, Map<String, double>> commissionRates; // أسعار العمولات
  String displayName;                              // اسم العرض
}
```

## الموفرين (Providers)

### AuthProvider
موفر المصادقة والتحكم بالمستخدمين

**الخصائص:**
```dart
User? currentUser;        // المستخدم الحالي
bool isLoading;          // حالة التحميل
String? errorMessage;    // رسالة الخطأ
bool isAuthenticated;    // حالة المصادقة
bool isAdmin;           // هل المستخدم مدير
```

**الدوال:**
```dart
// تسجيل الدخول
Future<bool> login(String username, String password);

// تسجيل الخروج
void logout();

// إضافة مندوب (للمدير فقط)
Future<bool> addDelegate({
  required String username,
  required String password,
  required String displayName,
  required String subscriptionPeriod,
  required int subscriptionDuration,
});

// الحصول على قائمة المندوبين
List<User> getDelegates();

// تحديث مستخدم
Future<void> updateUser(User user);

// حذف مندوب
Future<bool> deleteDelegate(String userId);
```

### DeliveryProvider
موفر التوصيلات

**الخصائص:**
```dart
List<Delivery> deliveries;      // قائمة التوصيلات
DateTime selectedDate;           // التاريخ المحدد
```

**الدوال:**
```dart
// تحميل التوصيلات
void loadDeliveries();

// الحصول على توصيلات يوم معين
List<Delivery> getDeliveriesForDate(DateTime date);

// الحصول على توصيلات الأسبوع
List<Delivery> getDeliveriesForWeek(DateTime date);

// الحصول على توصيلات الشهر
List<Delivery> getDeliveriesForMonth(DateTime date);

// ملخص يومي
Map<String, int> getDailySummary(DateTime date);

// إجمالي عمولات الأسبوع
double getWeeklyCommission(DateTime date);

// إجمالي عمولات اليوم
double getDailyCommission(DateTime date);

// إضافة توصيل
Future<bool> addDelivery({
  required String type,
  String? timeRange,
  int? simCount,
  double? customCommission,
  String? notes,
});

// حذف توصيل
Future<bool> deleteDelivery(String id);

// تحديد تاريخ
void setSelectedDate(DateTime date);

// اليوم السابق
void previousDay();

// اليوم التالي
void nextDay();
```

### InventoryProvider
موفر المخزون

**الخصائص:**
```dart
List<InventoryTransaction> transactions;  // المعاملات
List<FaultySim> faultySims;              // الشرائح المعطلة
```

**الدوال:**
```dart
// تحميل المخزون
void loadInventory();

// إجمالي المخزون
Map<String, int> getTotalInventory();

// إجمالي عدد المخزون
int getTotalInventoryCount();

// عدد مخزون نوع معين
int getInventoryCount(String type);

// استلام مخزون
Future<bool> receiveInventory({
  required String type,
  required int quantity,
  DateTime? date,
  String? notes,
});

// استخدام مخزون (عند التوصيل)
Future<bool> useInventory({
  required String type,
  required int quantity,
  String? deliveryId,
});

// إضافة شريحة معطلة
Future<bool> addFaultySim({
  required String type,
  required int quantity,
  String? notes,
});

// إرجاع معطل للشركة
Future<bool> returnFaultyToCompany(String faultySimId);

// إرجاع معطل للمخزون
Future<bool> returnFaultyToInventory(String faultySimId);

// حذف معاملة
Future<bool> deleteTransaction(String id);

// الشرائح المعطلة قيد الانتظار
List<FaultySim> getPendingFaultySims();
```

### FuelProvider
موفر الوقود

**الخصائص:**
```dart
List<FuelEntry> entries;  // قائمة التعبئات
```

**الدوال:**
```dart
// تحميل التعبئات
void loadFuelEntries();

// تعبئات يوم معين
List<FuelEntry> getEntriesForDate(DateTime date);

// تعبئات الأسبوع
List<FuelEntry> getEntriesForWeek(DateTime date);

// تعبئات الشهر
List<FuelEntry> getEntriesForMonth(DateTime date);

// ملخص أسبوعي
Map<String, dynamic> getWeeklySummary(DateTime date);
// Returns: {totalLiters, totalCost, averageConsumption, entryCount}

// ملخص شهري
Map<String, dynamic> getMonthlySummary(DateTime date);

// معدل استهلاك يومي
double? getDailyConsumptionRate(DateTime date);

// إضافة تعبئة
Future<bool> addFuelEntry({
  required String fuelType,
  required double liters,
  double? distance,
  DateTime? date,
  String? notes,
});

// تحديث تعبئة
Future<bool> updateFuelEntry(FuelEntry entry);

// حذف تعبئة
Future<bool> deleteFuelEntry(String id);

// إجمالي التكلفة لفترة
double getTotalCost(DateTime startDate, DateTime endDate);

// إجمالي اللترات لفترة
double getTotalLiters(DateTime startDate, DateTime endDate);
```

### SettingsProvider
موفر الإعدادات

**الخصائص:**
```dart
AppSettings? settings;                        // الإعدادات
double weeklyGoal;                           // الهدف الأسبوعي
String preferredFuelType;                    // نوع الوقود المفضل
Map<String, Map<String, double>> commissionRates;  // أسعار العمولات
String displayName;                          // اسم العرض
```

**الدوال:**
```dart
// تحميل الإعدادات
void loadSettings();

// حفظ الإعدادات
Future<void> saveSettings();

// تحديث الهدف الأسبوعي
Future<void> updateWeeklyGoal(double goal);

// تحديث نوع الوقود المفضل
Future<void> updatePreferredFuelType(String fuelType);

// تحديث أسعار العمولات
Future<void> updateCommissionRates(Map<String, Map<String, double>> rates);

// تحديث سعر عمولة محدد
Future<void> updateCommissionRate({
  required String deliveryType,
  required String timeRange,
  required double rate,
});

// تحديث اسم العرض
Future<void> updateDisplayName(String name);

// إعادة تعيين أسعار العمولات للافتراضي
Future<void> resetCommissionRates();

// إعادة تعيين كل الإعدادات
Future<void> resetToDefaults();

// الحصول على سعر عمولة
double getCommissionRate(String deliveryType, String timeRange);
```

## الخدمات (Services)

### LocalStorageService
خدمة التخزين المحلي باستخدام Hive

```dart
// تهيئة
static Future<void> init();

// مستخدمين
static Future<void> saveUser(User user);
static User? getUser(String id);
static List<User> getAllUsers();
static User? getUserByUsername(String username);
static Future<void> deleteUser(String id);

// توصيلات
static Future<void> saveDelivery(Delivery delivery);
static Delivery? getDelivery(String id);
static List<Delivery> getDeliveriesByUser(String userId);
static List<Delivery> getDeliveriesByDate(String userId, DateTime date);
static Future<void> deleteDelivery(String id);

// مخزون
static Future<void> saveInventoryTransaction(InventoryTransaction transaction);
static List<InventoryTransaction> getInventoryByUser(String userId);
static Future<void> deleteInventoryTransaction(String id);

// شرائح معطلة
static Future<void> saveFaultySim(FaultySim faultySim);
static List<FaultySim> getFaultySimsByUser(String userId);
static Future<void> deleteFaultySim(String id);

// وقود
static Future<void> saveFuelEntry(FuelEntry entry);
static FuelEntry? getFuelEntry(String id);
static List<FuelEntry> getFuelEntriesByUser(String userId);
static Future<void> deleteFuelEntry(String id);

// إعدادات
static Future<void> saveSettings(AppSettings settings);
static AppSettings? getSettings(String userId);

// حذف كل البيانات
static Future<void> clearAll();
```

### FirebaseService
خدمة المزامنة السحابية (اختياري)

```dart
// المصادقة
static Future<User?> signInWithEmailPassword(String email, String password);
static Future<void> signOut();
static User? get currentUser;

// مستخدمين
static Future<void> saveUser(User user);
static Future<User?> getUser(String id);
static Stream<List<User>> getAllUsersStream();

// توصيلات
static Future<void> saveDelivery(Delivery delivery);
static Stream<List<Delivery>> getDeliveriesByUserStream(String userId);
static Future<void> deleteDelivery(String id);

// مخزون
static Future<void> saveInventoryTransaction(InventoryTransaction transaction);
static Stream<List<InventoryTransaction>> getInventoryByUserStream(String userId);

// شرائح معطلة
static Future<void> saveFaultySim(FaultySim faultySim);
static Stream<List<FaultySim>> getFaultySimsByUserStream(String userId);

// وقود
static Future<void> saveFuelEntry(FuelEntry entry);
static Stream<List<FuelEntry>> getFuelEntriesByUserStream(String userId);

// إعدادات
static Future<void> saveSettings(AppSettings settings);
static Future<AppSettings?> getSettings(String userId);
static Stream<AppSettings?> getSettingsStream(String userId);
```

## الأدوات المساعدة (Utilities)

### DateTimeUtils
أدوات التعامل مع التواريخ

```dart
// بداية الأسبوع (الأحد)
static DateTime getWeekStart(DateTime date);

// نهاية الأسبوع (السبت)
static DateTime getWeekEnd(DateTime date);

// نفس الأسبوع؟
static bool isSameWeek(DateTime date1, DateTime date2);

// بداية الشهر
static DateTime getMonthStart(DateTime date);

// نهاية الشهر
static DateTime getMonthEnd(DateTime date);

// نفس الشهر؟
static bool isSameMonth(DateTime date1, DateTime date2);

// نفس اليوم؟
static bool isSameDay(DateTime date1, DateTime date2);

// تنسيق التاريخ
static String formatDate(DateTime date);

// تنسيق مع اسم اليوم
static String formatDateWithDay(DateTime date);

// اسم اليوم بالعربي
static String getDayName(DateTime date);

// اسم الشهر بالعربي
static String getMonthName(DateTime date);

// تنسيق الوقت
static String formatTime(DateTime date);

// تنسيق المبلغ
static String formatCurrency(double amount);
```

### Calculations
الحسابات

```dart
// حساب عمولة توصيل
static double calculateDeliveryCommission({
  required String deliveryType,
  required String timeRange,
  Map<String, Map<String, double>>? customRates,
});

// حساب تكلفة الوقود
static double calculateFuelCost({
  required String fuelType,
  required double liters,
});

// حساب معدل الاستهلاك
static double calculateConsumptionRate({
  required double distance,
  required double liters,
});

// نسبة تقدم الهدف الأسبوعي
static double calculateWeeklyProgress({
  required double totalEarned,
  required double weeklyGoal,
});

// متوسط الاستهلاك
static double calculateAverageConsumption(List<double> consumptionRates);

// عدد التوصيلات حسب النوع
static Map<String, int> calculateDeliveriesByType(List<Map<String, dynamic>> deliveries);

// إجمالي العمولات
static double calculateTotalCommissions(List<Map<String, dynamic>> deliveries);

// المخزون المتبقي
static Map<String, int> calculateRemainingInventory({
  required Map<String, int> totalInventory,
  required Map<String, int> usedInventory,
});
```

### Helpers
دوال مساعدة

```dart
// عرض رسالة
static void showSnackBar(BuildContext context, String message, {bool isError = false});

// حوار تأكيد
static Future<bool> showConfirmDialog(BuildContext context, String title, String message);

// اسم نوع التوصيل بالعربي
static String getDeliveryTypeName(String type);

// اسم الفترة الزمنية بالعربي
static String getTimeRangeName(String timeRange);

// اسم نوع الوقود بالعربي
static String getFuelTypeName(String type);

// تحويل إلى double
static double? parseDouble(String value);

// تحويل إلى int
static int? parseInt(String value);

// أيقونة التوصيل
static IconData getDeliveryIcon(String type);
```

## أمثلة الاستخدام

### مثال: تسجيل توصيل جديد
```dart
final deliveryProvider = Provider.of<DeliveryProvider>(context, listen: false);
final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);

// التحقق من المخزون
if (inventoryProvider.getInventoryCount(AppConstants.deliveryJawy) > 0) {
  // تسجيل التوصيل
  await deliveryProvider.addDelivery(
    type: AppConstants.deliveryJawy,
    timeRange: AppConstants.timeRangeLessThan2,
  );
  
  // خصم من المخزون
  await inventoryProvider.useInventory(
    type: AppConstants.deliveryJawy,
    quantity: 1,
  );
}
```

### مثال: عرض التقارير الأسبوعية
```dart
final deliveryProvider = Provider.of<DeliveryProvider>(context);
final selectedDate = DateTime.now();

final weeklyDeliveries = deliveryProvider.getDeliveriesForWeek(selectedDate);
final weeklyCommission = deliveryProvider.getWeeklyCommission(selectedDate);
final weekStart = DateTimeUtils.getWeekStart(selectedDate);
final weekEnd = DateTimeUtils.getWeekEnd(selectedDate);

print('الأسبوع: ${DateTimeUtils.formatDate(weekStart)} - ${DateTimeUtils.formatDate(weekEnd)}');
print('عدد التوصيلات: ${weeklyDeliveries.length}');
print('إجمالي العمولات: ${DateTimeUtils.formatCurrency(weeklyCommission)}');
```

---

تم التحديث: ديسمبر 2024
