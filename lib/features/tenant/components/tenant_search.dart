import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/tenant/components/tenant.dart';
import 'package:residenza/services/tenant_api_service.dart';
import 'package:residenza/view_models/room_view_model.dart';

class TenantSearch extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantSearch({required this.label, required this.hint, super.key});

  final String? label;
  final String? hint;

  @override
  State<TenantSearch> createState() => _TenantSearchState();
}

class _TenantSearchState extends State<TenantSearch> with GetItStateMixin {
  final TenantApiService _apiService = TenantApiService();
  final TextEditingController _textEditingController = TextEditingController();

  // This function will be called by the Autocomplete widget
  // whenever the text field's value changes.
  Future<Iterable<Tenant>> _optionsBuilder(
    TextEditingValue textEditingValue,
  ) async {
    if (textEditingValue.text.isEmpty) {
      return const Iterable<Tenant>.empty();
    }

    try {
      // Call your API service to get suggestions
      final response = await _apiService.searchTenant(
        query: textEditingValue.text,
      );

      List<dynamic> tenantJsonList = response['data'];

      return tenantJsonList.map((json) => Tenant.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching suggestions: $e');
      // You might want to show a SnackBar or some error message here
      return const Iterable<Tenant>.empty(); // Return empty on error
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Autocomplete<Tenant>(
          optionsBuilder: _optionsBuilder,
          displayStringForOption:
              (Tenant option) =>
                  option.name, // Display tenant's name in the text field
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Use the provided textEditingController for the TextField
            _textEditingController.text =
                textEditingController.text; // Keep local controller in sync
            get<RoomViewModel>().tenantName = textEditingController.text;
            return TextField(
              controller:
                  textEditingController, // This is the controller Autocomplete manages
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: widget.label ?? 'Search Tenants (Name, Phone, NIK)',
                hintText: widget.hint ?? 'e.g., John, 0812, 12345',
                // prefixIcon: Icon(Icons.search),
                // border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (String value) {
                onFieldSubmitted(); // Call this to trigger option selection if applicable
                // You might want to do something specific when user presses Enter
                print('Search submitted: $value');
              },
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<Tenant> onSelected,
            Iterable<Tenant> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  height: 200.0, // Limit the height of the suggestions list
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Tenant option = options.elementAt(index);
                      return ListTile(
                        enabled: option.tenancyStatus != "Active",
                        dense: true,
                        title: Text(option.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phone: ${option.phone}'),
                            Text('NIK: ${option.nikNumber}'),
                            Text('Status: ${option.tenancyStatus}'),
                          ],
                        ),
                        onTap: () {
                          onSelected(
                            option,
                          ); // This will put the selected option's displayString into the TextField
                          // You can also perform additional actions here after selection
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${option.name}')),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
          onSelected: (Tenant selection) {
            // This is called when a user selects an option from the suggestions.
            debugPrint('You just selected ${selection.name}');
            get<RoomViewModel>().tenantName = selection.name;
            // You can perform actions here, e.g., navigate to a detail page
          },
        ),
        // You can add other widgets below the Autocomplete if needed
        // const SizedBox(height: 20),
        // Text('Current search text: ${_textEditingController.text}'),
      ],
    );
  }
}
