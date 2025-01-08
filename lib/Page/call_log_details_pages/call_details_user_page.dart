import 'dart:async';

import 'package:flipcodeattendence/featuers/User/staff_provider.dart';
import 'package:flipcodeattendence/helper/api_helper.dart';
import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../models/parts_model.dart';
import '../../provider/call_log_provider.dart';
import '../../widget/custom_elevated_button.dart';
import '../../widget/custom_outlined_button.dart';
import '../../widget/text_form_field_custom.dart';

class CallDetailsUserPage extends StatefulWidget {
  final String id;

  const CallDetailsUserPage({super.key, required this.id});

  @override
  State<CallDetailsUserPage> createState() => _CallDetailsUserPageState();
}

class _CallDetailsUserPageState extends State<CallDetailsUserPage> {
  final _formKey = GlobalKey<FormState>();
  final extraChargeController = TextEditingController();
  final partsController = TextEditingController();
  final paymentMethodController = TextEditingController();
  List<Parts> selectedParts = [];
  String? qrId = null;
  late final CallLogProvider provider;
  late double totalCharge;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CallLogProvider>(context, listen: false);
    provider.getAllocatedCallLogDetails(context: context, id: widget.id);
    totalCharge = countTotal();
    Future.delayed(Duration.zero, () => setState(() {}));
  }

  @override
  void dispose() {
    extraChargeController.dispose();
    partsController.dispose();
    paymentMethodController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  resetValues() {
    setState(() {
      selectedParts.clear();
      partsController.clear();
      selectedParts.clear();
      extraChargeController.clear();
      paymentMethodController.clear();
      qrId = null;
    });
  }

  double countTotal() {
    double initialCharge = 0.0;
    double extraCharge = 0.0;
    double totalCharge = 0.0;
    final callCharge = provider.staffCallLogData?.charge;
    if (callCharge != null) initialCharge = double.parse(callCharge);
    if (extraChargeController.text.trim().isNotEmpty)
      extraCharge = double.parse(extraChargeController.text.trim());
    totalCharge = (initialCharge + extraCharge).toPrecision(2);
    return totalCharge;
  }

  void fetchQRCodeList() {
    Provider.of<StaffProvider>(context, listen: false).getQRCodeList(context);
  }

  bool isQrSelected(String id) {
    return id == qrId;
  }

  Color getForegroundColor(String id) {
    return isQrSelected(id)
        ? AppColors.onPrimaryLight
        : AppColors.backgroundBlack;
  }

  Color getBackgroundColor(String id) {
    return isQrSelected(id)
        ? AppColors.aPrimary
        : AppColors.backgroundLight;
  }

  Color getBorderColor(String id) {
    return isQrSelected(id)
        ? Colors.transparent
        : AppColors.grey;
  }

  void showSnackBar(BuildContext context, String message) {
    CommonWidgets.customSnackBar(context: context, title: message);
  }

  bool isQr() {
    return paymentMethodController.text.trim().toLowerCase() ==
        PaymentMethod.QR.name.toString().toLowerCase();
  }

  Future<void> completeCallLog() async {
    var partsList;
    if(selectedParts.isEmpty) {
      partsList = null;
    } else {
      for (final part in selectedParts) {
        partsList.add(part.name.toString());
      }
    }
    Provider.of<CallLogProvider>(context, listen: false)
        .completeCall(context,
            callId: widget.id,
            partsList: partsList,
            paymentMethod: paymentMethodController.text.trim().toLowerCase(),
            totalCharge: totalCharge.toString(),
            qrId: qrId)
        .then((value) {
      if (value) {
        resetValues();
        Navigator.pop(context, true);
      } else {
        showSnackBar(context, 'Something went Wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.clear)),
      ),
      body: SingleChildScrollView(
        child: Consumer<CallLogProvider>(builder: (context, provider, _) {
          return Form(
            key: _formKey,
            child: (provider.isLoading)
                ? const LinearProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            provider.staffCallLogData?.call?.user?.name
                                    ?.capitalizeFirst ??
                                '',
                            style: textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12.0),
                        Row(
                          children: [
                            Icon(Icons.call),
                            const SizedBox(width: 6.0),
                            Text(
                                '${provider.staffCallLogData?.call?.user?.phone}',
                                style: textTheme.bodyLarge),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined),
                            const SizedBox(width: 6.0),
                            Expanded(
                                child: Text(
                                    provider.staffCallLogData?.call?.address
                                            ?.capitalizeFirst ??
                                        'N/A',
                                    style: textTheme.bodyLarge)),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.message_outlined),
                            const SizedBox(width: 6.0),
                            Expanded(
                                child: Text(
                                    provider.staffCallLogData?.call?.description
                                            ?.capitalizeFirst ??
                                        '',
                                    style: textTheme.bodyLarge)),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.date_range),
                            const SizedBox(width: 6.0),
                            Expanded(
                                child: Text(
                                    provider.staffCallLogData?.date ?? '',
                                    style: textTheme.bodyLarge)),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.watch_later_outlined),
                            const SizedBox(width: 6.0),
                            Expanded(
                                child: Text(
                                    provider.staffCallLogData?.slot
                                            ?.capitalizeFirst ??
                                        '',
                                    style: textTheme.bodyLarge)),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.currency_rupee),
                            const SizedBox(width: 6.0),
                            Expanded(
                                child: Text(
                                    provider.staffCallLogData?.charge ?? '',
                                    style: textTheme.bodyLarge)),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        TextFormFieldWidget(
                          labelText: 'Select parts',
                          controller: partsController,
                          readOnly: true,
                          suffixIcon: (partsController.text.trim().isEmpty)
                              ? const Icon(
                                  Icons.arrow_drop_down_circle_outlined)
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => setState(() {
                                        partsController.clear();
                                        this.selectedParts.clear();
                                      })),
                          onTap: () async {
                            await showModalBottomSheet(
                                    context: context,
                                    builder: (context) => PartsBottomSheet())
                                .then((value) {
                              if (value != null) {
                                this.selectedParts = value;
                                if (selectedParts.length == 1) {
                                  partsController.text =
                                      "${selectedParts[0].name}";
                                } else {
                                  final buffer = StringBuffer();
                                  for (final part in selectedParts) {
                                    buffer.write("${part.name}, ");
                                  }
                                  partsController.text = buffer.toString();
                                }
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormFieldWidget(
                          labelText: 'Select payment method',
                          controller: paymentMethodController,
                          readOnly: true,
                          suffixIcon:
                              (paymentMethodController.text.trim().isEmpty)
                                  ? Icon(Icons.arrow_drop_down_circle_outlined)
                                  : IconButton(
                                      onPressed: () => setState(() {
                                            paymentMethodController.clear();
                                            extraChargeController.clear();
                                            totalCharge = countTotal();
                                            qrId = null;
                                          }),
                                      icon: Icon(Icons.close)),
                          validator: (value) {
                            return (value == null || value.trim().isEmpty)
                                ? 'Please select payment method'
                                : null;
                          },
                          onTap: () async {
                            final PaymentMethod? selectedPaymentMethod =
                                await showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        PaymentMethodBottomSheet());
                            if (selectedPaymentMethod != null) {
                              paymentMethodController.text =
                                  selectedPaymentMethod.name.capitalizeFirst!;
                              extraChargeController.clear();
                              totalCharge = countTotal();
                              setState(() {});
                              if (selectedPaymentMethod == PaymentMethod.QR)
                                fetchQRCodeList();
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormFieldWidget(
                          labelText: 'Enter extra charge',
                          controller: extraChargeController,
                          suffixIcon: Icon(Icons.currency_rupee),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) async {
                            if (debounce?.isActive ?? false) debounce?.cancel();
                            Timer(
                                Duration(milliseconds: 1000),
                                () =>
                                    setState(() => totalCharge = countTotal()));
                          },
                        ),
                        const SizedBox(height: 16.0),
                        if (paymentMethodController.text.trim().toLowerCase() ==
                            PaymentMethod.QR.name.toLowerCase()) ...[
                          Consumer<StaffProvider>(
                              builder: (context, provider, _) {
                            return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12.0,
                                        crossAxisSpacing: 12.0,
                                        childAspectRatio: 2.5),
                                itemCount: provider.qrCodes.length,
                                itemBuilder: (context, index) {
                                  return OutlinedButton.icon(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 300,
                                                      width: 300,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  "${ApiHelper.imageBaseUrl + provider.qrCodes[index]?['image']}"))),
                                                    ),
                                                    const SizedBox(
                                                        height: 12.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            provider.qrCodes[
                                                                index]?['name'],
                                                            style: textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 12.0),
                                                    OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context,
                                                              provider.qrCodes[
                                                                      index]
                                                                      ?['id']
                                                                  .toString());
                                                        },
                                                        child: const Text('Ok'))
                                                  ],
                                                ),
                                              )).then((value) {
                                        if (value != null) {
                                          qrId = value;
                                          setState(() {});
                                        }
                                      });
                                    },
                                    label: Text(
                                        provider.qrCodes[index]?['name'],
                                        style: TextStyle(
                                            color: getForegroundColor(provider
                                                .qrCodes[index]['id']
                                                .toString()))),
                                    icon: Icon(Icons.qr_code_2_outlined,
                                        color: getForegroundColor(provider
                                            .qrCodes[index]['id']
                                            .toString())),
                                    style: OutlinedButton.styleFrom(
                                        fixedSize: const Size.fromHeight(56.0),
                                        backgroundColor: getBackgroundColor(
                                            provider.qrCodes[index]['id']
                                                    .toString() ??
                                                ''),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0))),
                                  );
                                });
                          }),
                          const SizedBox(height: 16.0),
                        ],
                      ],
                    ),
                  ),
          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Row(
          children: [
            Expanded(
                child: Text('Total : ₹$totalCharge',
                    style: textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold))),
            const SizedBox(width: 12.0),
            Expanded(
                child: CustomElevatedButton(
                    buttonText: 'Complete call',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (isQr()) {
                          if (qrId == null)
                            showSnackBar(context, 'Please select QR code');
                          else
                            completeCallLog();
                        } else {
                          completeCallLog();
                        }
                      }
                    }))
          ],
        ),
      ),
    );
  }
}

class PartsBottomSheet extends StatefulWidget {
  const PartsBottomSheet({super.key});

  @override
  State<PartsBottomSheet> createState() => _PartsBottomSheetState();
}

class _PartsBottomSheetState extends State<PartsBottomSheet> {
  List<Parts> parts = [];

  @override
  void initState() {
    Provider.of<CallLogProvider>(context, listen: false).getParts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<CallLogProvider>(builder: (context, provider, _) {
      return provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (provider.parts.isEmpty)
              ? const Center(child: Text('No parts found'))
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Select parts',
                              style: textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: List.generate(parts.length, (index) {
                            return InputChip(
                                shape: StadiumBorder(),
                                side: BorderSide(color: Colors.transparent),
                                backgroundColor: AppColors.aPrimary,
                                deleteIconColor: AppColors.onPrimaryLight,
                                visualDensity: VisualDensity.compact,
                                label: Text(parts[index].name ?? '',
                                    style: TextStyle(
                                        color: AppColors.onPrimaryLight)),
                                onPressed: () {},
                                onDeleted: () =>
                                    setState(() => parts.removeAt(index)));
                          }),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.parts.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final partItem = provider.parts[index];
                              return CheckboxListTile(
                                value: parts.any((element) =>
                                        element.id.toString() ==
                                        partItem.id.toString())
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (parts.any((element) =>
                                        element.id.toString() ==
                                        partItem.id.toString())) {
                                      parts.remove(partItem);
                                    } else {
                                      parts.add(partItem);
                                    }
                                  });
                                },
                                title: Text(partItem.name ?? ''),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomOutlinedButton(
                                buttonText: 'Clear all',
                                onPressed: (parts.isNotEmpty)
                                    ? () => setState(() => parts.clear())
                                    : null),
                            const SizedBox(width: 16.0),
                            CustomElevatedButton(
                                buttonText: 'Ok',
                                onPressed: (parts.isNotEmpty)
                                    ? () {
                                        Navigator.pop(context, parts);
                                      }
                                    : null),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
    });
  }
}

class PaymentMethodBottomSheet extends StatefulWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  State<PaymentMethodBottomSheet> createState() => _PaymentMethodBottomSheet();
}

class _PaymentMethodBottomSheet extends State<PaymentMethodBottomSheet> {
  PaymentMethod? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select payment method',
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12.0),
          GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 2.5),
              itemCount: PaymentMethod.values.length,
              itemBuilder: (context, index) => InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = PaymentMethod.values[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: selectedPaymentMethod ==
                              PaymentMethod.values[index] ? Colors.transparent : AppColors.grey),
                          color: selectedPaymentMethod ==
                                  PaymentMethod.values[index]
                              ? AppColors.aPrimary
                              : AppColors.onPrimaryLight),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaymentMethod.values[index] == PaymentMethod.cash
                              ? Icon(Icons.currency_rupee,
                                  color: (selectedPaymentMethod ==
                                          PaymentMethod.cash)
                                      ? AppColors.onPrimaryLight
                                      : AppColors.onPrimaryBlack)
                              : PaymentMethod.values[index] ==
                                      PaymentMethod.Debit
                                  ? Icon(Icons.currency_rupee,
                                      color: (selectedPaymentMethod ==
                                              PaymentMethod.Debit)
                                          ? AppColors.onPrimaryLight
                                          : AppColors.onPrimaryBlack)
                                  : Icon(Icons.qr_code,
                                      color: (selectedPaymentMethod ==
                                              PaymentMethod.QR)
                                          ? AppColors.onPrimaryLight
                                          : AppColors.onPrimaryBlack),
                          const SizedBox(width: 12.0),
                          Text(
                              PaymentMethod.values[index].name.capitalizeFirst!,
                              style: TextStyle(
                                  color: selectedPaymentMethod ==
                                          PaymentMethod.values[index]
                                      ? AppColors.onPrimaryLight
                                      : AppColors.onPrimaryBlack)),
                        ],
                      ),
                    ),
                  )),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomOutlinedButton(
                  buttonText: 'Clear',
                  onPressed: (selectedPaymentMethod != null)
                      ? () {
                          setState(() {
                            selectedPaymentMethod = null;
                          });
                        }
                      : null),
              const SizedBox(width: 16.0),
              CustomElevatedButton(
                  buttonText: 'Ok',
                  onPressed: (selectedPaymentMethod != null)
                      ? () {
                          Navigator.pop(context, selectedPaymentMethod);
                        }
                      : null),
            ],
          ),
        ],
      ),
    );
  }
}
