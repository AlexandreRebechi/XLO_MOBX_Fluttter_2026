import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/screens/filter/components_filter/oder_by_field.dart';
import 'package:xlo_mobx/screens/filter/components_filter/price_range_field.dart';
import 'package:xlo_mobx/screens/filter/components_filter/vendor_type_field.dart';
import 'package:xlo_mobx/stores/filter_store.dart';
import 'package:xlo_mobx/stores/home_store.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({super.key});

  final FilterStore filter = GetIt.I<HomeStore>().clonedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtrar Busca', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //LocationField(filter),
                OderByField(filter: filter),
                PriceRangeField(filter: filter),
                VendorTypeField(filter: filter),
                Observer(
                  builder: (_) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: filter.isFormValid
                            ? () {
                                filter.save();
                                Navigator.of(context).pop();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          disabledBackgroundColor: Colors.orange.withAlpha(120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Filtrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
