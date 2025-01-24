/*
import 'package:flutter/material.dart';
import 'package:eatseasy/models/all_addresses.dart';
import 'package:eatseasy/views/profile/widgets/address_tile.dart';

class AddressList extends StatelessWidget {
  const AddressList({
    super.key,
    required this.addresses,
  });

  final List<AddressesList> addresses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: addresses.length,
        itemBuilder: (context, i) {
          AddressesList address = addresses[i];
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey.shade300),
                    top: BorderSide(
                        width: 0.5,
                        color: Colors.grey.shade300))),
            child: AddressTile(address: address, refetch: () {  },),
          );
        });
  }
}
*/
