import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/filter/components_filter/price_field.dart';
import 'package:xlo_mobx/screens/filter/components_filter/section_title.dart';
import 'package:xlo_mobx/stores/filter_store.dart';

class PriceRangeField extends StatelessWidget {
  const PriceRangeField({super.key, required this.filter});

  final FilterStore filter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Preço'),
        Row(
          children: <Widget>[
            PriceField(
              label: 'Min',
              initialValue: filter.minPrice,
              onChanged: filter.setMinPrice,
            ),
            const SizedBox(width: 12),
            PriceField(
              label: 'Max',
              onChanged: filter.setMaxPrice,
              initialValue: filter.maxPrice,
            ),
          ],
        ),
        Observer(
          builder: (_) {
            if (filter.priceError != null) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  filter.priceError!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
