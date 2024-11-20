import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/client_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widget/custom_elevated_button.dart';
import '../../../widget/custom_outlined_button.dart';
import '../../../widget/text_form_field_custom.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  String? clientName;
  int? selectedId;
  Timer? _debounce;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ClientProvider>(context, listen: false)
        .getClients(context: context);
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: const Text('Select client'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormFieldWidget(
              controller: searchController,
              prefixWidget: Icon(CupertinoIcons.search),
              hintText: 'Search client',
              keyboardType: TextInputType.text,
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 800), () {
                  if (value.trim().isNotEmpty) {
                    searchController.text = value;
                    Provider.of<ClientProvider>(context, listen: false)
                        .getClients(context: context, name: value);
                  } else {
                    Provider.of<ClientProvider>(context, listen: false)
                        .getClients(context: context);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<ClientProvider>(builder: (context, provider, _) {
              return provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (provider.clientModel?.data?.isEmpty ?? true)
                      ? Text('No clients found')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.clientModel?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final client = provider.clientModel?.data?[index];
                            return ListTile(
                              title: Text('${client?.name}'),
                              trailing: (selectedId == client?.id)
                                  ? Icon(Icons.check_circle,
                                      color: AppColors.aPrimary)
                                  : const SizedBox.shrink(),
                              onTap: () {
                                setState(() {
                                  selectedId = client?.id;
                                  clientName = '${client?.name}';
                                });
                              },
                            );
                          });
            }),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: CustomOutlinedButton(
                  buttonText: 'Clear',
                  onPressed: (selectedId != null)
                      ? () {
                          setState(() {
                            selectedId = null;
                            clientName = null;
                          });
                        }
                      : null),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: CustomElevatedButton(
                  buttonText: 'Ok',
                  onPressed: (selectedId != null)
                      ? () {
                          final ({String? id, String? name}) clientRecord =
                              (id: selectedId.toString(), name: clientName);
                          Navigator.pop(context, clientRecord);
                        }
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
