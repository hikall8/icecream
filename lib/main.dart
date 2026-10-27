
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: IcecreamApp()));

class IcecreamApp extends StatefulWidget {
  const IcecreamApp({super.key});
  @override
  State<IcecreamApp> createState() => _IcecreamAppState();
}

class _IcecreamAppState extends State<IcecreamApp> {
  final foods = {
    '🍩 チョコドーナツ': 450,
    '🍩 シュガードーナツ': 400,
    '🧁 カップケーキ（期間限定）': 300,
  };
  late String food = foods.keys.first;
  final fruits = <String>{};
  bool spoon = false, napkin = false;
  int order = 0;
  String receipt = '';

  Widget choices(Iterable<String> items, String value,
      void Function(String) change) => Wrap(spacing: 6, children: [
        for (final s in items)
          ChoiceChip(label: Text(s), selected: value == s,
              onSelected: (_) => setState(() => change(s))),
      ]);

  @override
  Widget build(BuildContext context) {
    final subtotal = foods[food]! + fruits.length * 100;
    final tax = subtotal ~/ 10;
    final total = subtotal + tax;
    final photo = Text('$food ${foods[food]}円');
    final products = choices(foods.keys.map((s) => '$s  ${foods[s]}円'),
        '$food ${foods[food]}円',
        (s) => food = s.substring(0, s.lastIndexOf('  ')));
    final toppings = Wrap(spacing: 6, children: [
      for (final s in ['🍫', '🍓', '🍯', '🥜', '🍬'])
        FilterChip(label: Text(s), selected: fruits.contains(s),
            onSelected: (v) => setState(() {
              if (v) { fruits.add(s); } else { fruits.remove(s); }
            })),
    ]);
    Widget supply(String label, bool value, void Function(bool) change) =>
        Row(mainAxisSize: MainAxisSize.min, children: [
          Checkbox(value: value,
              onChanged: (v) => setState(() => change(v ?? false))),
          Text(label),
        ]);
    final supplies = Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          supply('🍴 フォーク（無料）', spoon, (v) => spoon = v),
          supply('🛍️ 持ち帰り袋（無料）', napkin, (v) => napkin = v),
        ]);
    final bill = Column(children: [
      Text('税抜 $subtotal 円 / 消費税 $tax 円'),
      Text('合計 $total 円', style: const TextStyle(fontSize: 28)),
    ]);
    final submit = Center(child: FilledButton(onPressed: () => setState(() {
      order = Random().nextInt(999) + 1;
      receipt = '$food ${foods[food]}円\n'
          'トッピング: ${fruits.isEmpty ? 'なし' : fruits.join('  ')}\n'
          '🍴 フォーク: ${spoon ? 'あり' : 'なし'}\n'
          '🛍️ 持ち帰り袋: ${napkin ? 'あり' : 'なし'}\n'
          '税抜: subtotal 円 / 消費税(10%) : $tax 円\n'
          '合計: $total 円';
    }), child: const Text('注文する')));
    final ticket = order == 0 ? const SizedBox.shrink() : Card(child: Padding(
      padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('注文番号 #$order', style: const TextStyle(fontSize: 26)),
          Text(receipt),
        ],
      ),
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('🍩 ドーナツ屋さん注文アプリ')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: photo),
        const Text('ドーナツ・スイーツを選ぶ'), products,
        const Text('トッピング（1種類100円) '), toppings,
        const Text('無料サービス'), supplies,
        const Divider(),
        bill,
        submit, ticket,
      ]),
    );
  }
}
