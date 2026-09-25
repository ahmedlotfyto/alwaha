import 'package:flutter/material.dart';

void main() => runApp(const AlWahaApp());

class Product {
  final String name;
  final String category;
  final int price;
  final String emoji;
  Product(this.name, this.category, this.price, this.emoji);
}

final products = [
  Product('زيت الزيتون', 'زيوت', 250, '🫒'),
  Product('عسل نحل', 'عسل', 300, '🍯'),
  Product('عسل بالمكسرات', 'عسل', 350, '🥜'),
  Product('خل التفاح', 'خل', 120, '🍎'),
  Product('العسل الأسود', 'منتجات غذائية', 100, '🍯'),
  Product('الشوفان', 'حبوب', 90, '🌾'),
  Product('ماء الورد', 'عناية', 80, '🌹'),
];

class AlWahaApp extends StatelessWidget {
  const AlWahaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الواحة',
      theme: ThemeData(
        fontFamily: 'sans',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4E6B3C)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> cart = [];
  String category = 'الكل';

  List<Product> get filtered => category == 'الكل'
      ? products
      : products.where((p) => p.category == category).toList();

  void add(Product p) {
    setState(() => cart.add(p));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت إضافة ${p.name} إلى السلة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['الكل', ...{for (final p in products) p.category}];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الواحة 🌿', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Badge(
                isLabelVisible: cart.isNotEmpty,
                label: Text('${cart.length}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => CartPage(cart: cart),
              )),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF557A42), Color(0xFF9CAF72)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('منتجات الواحة', style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('جودة طبيعية تصل لباب بيتك', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ChoiceChip(
                  label: Text(categories[i]),
                  selected: category == categories[i],
                  onSelected: (_) => setState(() => category = categories[i]),
                ),
              ),
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                childAspectRatio: .76,
              ),
              itemBuilder: (_, i) {
                final p = filtered[i];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(child: Text(p.emoji, style: const TextStyle(fontSize: 70))),
                        ),
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Text('${p.price} جنيه', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => add(p),
                            child: const Text('أضف للسلة'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<Product> cart;
  const CartPage({super.key, required this.cart});
  @override State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get total => widget.cart.fold(0, (s, p) => s + p.price);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('سلة المشتريات')),
        body: widget.cart.isEmpty
          ? const Center(child: Text('السلة فارغة'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (_, i) {
                      final p = widget.cart[i];
                      return ListTile(
                        leading: Text(p.emoji, style: const TextStyle(fontSize: 32)),
                        title: Text(p.name),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('${p.price} جنيه'),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => setState(() => widget.cart.removeAt(i)),
                          )
                        ]),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('الإجمالي: $total جنيه', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => CheckoutPage(total: total),
                          )),
                          child: const Text('إتمام الطلب - الدفع عند الاستلام'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final int total;
  const CheckoutPage({super.key, required this.total});
  @override State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  void submit() {
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty || address.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('من فضلك أكمل بيانات الطلب')));
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تم تأكيد الطلب ✅'),
        content: Text('شكرًا ${name.text}، تم تسجيل طلبك بقيمة ${widget.total} جنيه.\nالدفع عند الاستلام.'),
        actions: [TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('العودة للرئيسية'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('بيانات الطلب')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('بيانات العميل', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: address, maxLines: 3, decoration: const InputDecoration(labelText: 'العنوان بالتفصيل', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: const Text('الدفع عند الاستلام'),
                subtitle: Text('إجمالي الطلب: ${widget.total} جنيه'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton(onPressed: submit, child: const Text('تأكيد الطلب')),
            )
          ],
        ),
      ),
    );
  }
}
