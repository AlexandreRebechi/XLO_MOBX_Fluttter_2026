import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/filter/components_filter/section_title.dart';
import 'package:xlo_mobx/stores/filter_store.dart';

class VendorTypeField extends StatelessWidget {
  const VendorTypeField({super.key, required this.filter});

  final FilterStore filter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionTitle(title: 'tipo de annunciante'),
        Observer(
          builder: (_) {
            return Wrap(
              runSpacing: 4,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (filter.isTypeParticular) {
                      if (filter.isTypeProfessional) {
                        filter.resetVendorType(VENDOR_TYPE_PARTICUAR);
                      } else {
                        filter.selectVendorType(VENDOR_TYPE_PROFESSIONAL);
                      }
                    } else {
                      filter.setVendorType(VENDOR_TYPE_PARTICUAR);
                    }
                  },
                  child: Container(
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: filter.isTypeParticular
                          ? Colors.purple
                          : Colors.transparent,
                      border: Border.all(
                        color: filter.isTypeParticular
                            ? Colors.purple
                            : Colors.grey,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Particular',
                      style: TextStyle(
                        color: filter.isTypeParticular
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    if (filter.isTypeProfessional) {
                      if (filter.isTypeParticular) {
                        filter.resetVendorType(VENDOR_TYPE_PROFESSIONAL);
                      } else {
                        filter.selectVendorType(VENDOR_TYPE_PARTICUAR);
                      }
                    } else {
                      filter.setVendorType(VENDOR_TYPE_PROFESSIONAL);
                    }
                  },
                  child: Container(
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: filter.isTypeProfessional
                          ? Colors.purple
                          : Colors.transparent,
                      border: Border.all(
                        color: filter.isTypeProfessional
                            ? Colors.purple
                            : Colors.grey,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Profissional',
                      style: TextStyle(
                        color: filter.isTypeProfessional
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
