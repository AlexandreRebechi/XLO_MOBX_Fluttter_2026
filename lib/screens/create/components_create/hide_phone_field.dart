import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/stores/create_store.dart';

class HidePhoneField extends StatelessWidget {
  const HidePhoneField({super.key, required this.createStore});

  final CreateStore createStore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Observer(
            builder: (_) {
              return Checkbox(
                value: createStore.hidePhone,
                onChanged: (value) {
                  value ??= false;
                  createStore.setHidePhone(value);
                },
                activeColor: Colors.purple,
              );
            },
          ),

          Expanded(child: Text('Ocultar o meu telefone neste anûncio')),
        ],
      ),
    );
  }
}
