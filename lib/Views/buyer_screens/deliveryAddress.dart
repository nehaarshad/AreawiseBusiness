import 'package:ecommercefrontend/View_Model/buyerViewModels/OrderViewModel.dart';
import 'package:ecommercefrontend/models/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../View_Model/UserProfile/EditProfileViewModel.dart';
import '../shared/widgets/colors.dart';

class deliveryAddress extends ConsumerStatefulWidget {
  int cartId;
  String userid;
  deliveryAddress({required this.userid,required this.cartId});

  @override
  ConsumerState<deliveryAddress> createState() => _deliveryAddressState();
}

class _deliveryAddressState extends ConsumerState<deliveryAddress> {

  Widget formFields(OrderViewModelProvider model) {
    return Column(
      children: [
        TextFormField(
          controller: model.sector,
          decoration: const InputDecoration(labelText: "Sector"),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter sector';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: model.city,
          decoration: const InputDecoration(labelText: "City"),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter city';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: model.address,
          decoration: const InputDecoration(labelText: "Address"),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget sendAddress(AsyncValue<orderModel?> state, OrderViewModelProvider viewModel, BuildContext context,) {
    return ElevatedButton(
      onPressed: state.isLoading ? null : () => deliveryAddressData(viewModel, widget.cartId,context),
      child: state.isLoading ? const CircularProgressIndicator() : const Text("Place Order"),
    );
  }

  void deliveryAddressData(OrderViewModelProvider viewModel, int cartId,BuildContext context) {
    if (viewModel.key.currentState!.validate()) {
      final data = {
        'cartId':cartId.toString(),
        'sector': viewModel.sector.text,
        'city': viewModel.city.text,
        'address': viewModel.address.text,
      };
      print('Form Data: $data');
      viewModel.placeOrder(data,widget.userid,context);

    }
  }

  @override
  Widget build(BuildContext context) {
    //to send address for order delivery
    final state=ref.watch(orderViewModelProvider);
    final viewModel=ref.read(orderViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: Text('Add Address'),
        actions: [
          TextButton(
            onPressed: () async{
              await viewModel.cancelOrder(widget.cartId.toString());
              Navigator.of(context).pop();
            },
            child: const Text('Back'),
          ),
        ],
      ),
      body: state.when(
        loading:
            () => Center(
          child: CircularProgressIndicator(color: Appcolors.blackColor),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (user) {
          if (user != null) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: viewModel.key,
                child: Column(
                  children: [
                    formFields(viewModel),
                    const SizedBox(height: 20),
                    sendAddress(state,viewModel,context),
                  ],
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
