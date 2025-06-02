import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mega_flutter_base/utils/text_field_utils.dart';
import 'package:mega_flutter_network/database/network_database.dart';
import 'package:mega_flutter_network/environment.dart';

import '../models/bank_account.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../models/state.dart';

class ModalItem {
  final int value;
  final String valueString;
  final String name;

  ModalItem(this.name, {this.value = -1, this.valueString = ''});
}

class MegaModals {
  late double width;
  final BuildContext context;

  MegaModals(this.context) {
    width = MediaQuery.of(context).size.width;
  }

  showSelectableSheet({
    required String title,
    required List<ModalItem> items,
    required Function(ModalItem) onTap,
    double minSize = 0.3,
    String? selected,
  }) {
    if (items.isEmpty) {
      return;
    }

    if (minSize <= 0 && minSize >= 1) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              maxChildSize: 0.9,
              initialChildSize: minSize,
              minChildSize: minSize,
              expand: false,
              builder: (_, controller) {
                return ListView.builder(
                  controller: controller,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return _buildSelectableHeader(title);
                    }
                    return _buildSelectableItem(
                      items[index - 1],
                      onTap,
                      selected: selected ?? '',
                    );
                  },
                  itemCount: items.length + 1,
                );
              },
            );
          },
        );
      },
    );
  }

  _buildSelectableHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        )
      ],
    );
  }

  _buildSelectableItem(
    ModalItem value,
    Function(ModalItem)? onTap, {
    String? selected,
  }) {
    return GestureDetector(
      onTap: onTap != null
          ? () async {
              await onTap(value);
              Navigator.pop(context);
            }
          : () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 9,
                    child: Text(
                      value.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Visibility(
                    visible: selected == value.valueString ||
                        selected == value.value.toString(),
                    child: Flexible(
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  showModalStates(
    List<StateModel> states, {
    required Function(ModalItem) onTap,
    required String title,
    required String hint,
  }) {
    final items = states
        .map((state) => ModalItem(
              state.name!,
              valueString: state.id!,
            ))
        .toList();

    showSearchableSheet(
      title: title,
      hint: hint,
      items: items,
      onTap: onTap,
    );
  }

  showModalBanks(
    List<BankAccount> banks, {
    required Function(ModalItem) onTap,
    required String title,
    required String hint,
  }) {
    final items = banks
        .map((bank) => ModalItem(
              '${bank.bankCode} - ${bank.bank}',
              valueString: bank.id!,
            ))
        .toList();

    showSearchableSheet(
      title: title,
      hint: hint,
      items: items,
      onTap: onTap,
    );
  }

  showModalCountries(
    List<Country> countries, {
    required Function(ModalItem) onTap,
    required String title,
    required String hint,
  }) {
    final items = countries
        .map((country) => ModalItem(
              country.name!,
              valueString: country.id!,
            ))
        .toList();

    showSearchableSheet(
      title: title,
      hint: hint,
      items: items,
      onTap: onTap,
    );
  }

  showModalCities(
    List<City> cities, {
    required Function(ModalItem) onTap,
    required String title,
    required String hint,
  }) {
    final items = cities
        .map((cities) => ModalItem(
              cities.name!,
              valueString: cities.id!,
            ))
        .toList();

    showSearchableSheet(
      title: title,
      hint: hint,
      items: items,
      onTap: onTap,
    );
  }

  showModalGeneric(
    List<dynamic> list, {
    required Function(ModalItem) onTap,
    required String title,
    required String hint,
  }) {
    final items = list
        .map((list) => ModalItem(
              list.name,
              valueString: list.id,
            ))
        .toList();

    showSearchableSheet(
      title: title,
      hint: hint,
      items: items,
      onTap: onTap,
    );
  }

  showSearchableSheet({
    required String title,
    required String hint,
    required List<ModalItem> items,
    required Function(ModalItem) onTap,
  }) {
    List<ModalItem> mItems = items;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              maxChildSize: 0.9,
              initialChildSize: 0.7,
              minChildSize: 0.6,
              expand: false,
              builder: (_, controller) {
                return ListView.builder(
                  controller: controller,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return _buildSearchableHeader(
                        title: title,
                        hint: hint,
                        items: items,
                        onFilter: (values) => setState(() => mItems = values),
                      );
                    }
                    return _buildSelectableItem(
                      mItems[index - 1],
                      onTap,
                    );
                  },
                  itemCount: mItems.length + 1,
                );
              },
            );
          },
        );
      },
    );
  }

  _buildSearchableHeader({
    required String title,
    required String hint,
    required List<ModalItem> items,
    required Function(List<ModalItem>) onFilter,
  }) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextFieldUtils.buildField(
                context,
                decoration: InputDecoration(
                  hintText: hint,
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                  suffixIcon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
                onChanged: (value) {
                  final nItems = items
                      .where((country) => country.name
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();

                  onFilter(nItems);
                },
              )
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey[500],
        )
      ],
    );
  }

  showModalEnvironment(Function(Environment) onTap) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title:
            const Text('Escolha o ambiente em que deseja utilizar a aplicação'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(Environment.prod.name),
            onPressed: () async {
              await NetworkDatabase.saveEnvironment(Environment.prod);
              onTap(Environment.prod);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(Environment.hom.name),
            onPressed: () async {
              await NetworkDatabase.saveEnvironment(Environment.hom);
              onTap(Environment.hom);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(Environment.dev.name),
            onPressed: () async {
              await NetworkDatabase.saveEnvironment(Environment.dev);
              onTap(Environment.dev);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(Environment.custom.name),
            onPressed: () async {
              await onTap(Environment.custom);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  showCustomEnvironmentDialog(Function(Environment) onTap) {
    showDialog(
        context: context,
        builder: (context) {
          final urlController = TextEditingController();
          final _form = GlobalKey<FormState>();

          return Material(
            color: Colors.transparent,
            child: CupertinoAlertDialog(
              title: const Text('DIGITE A URL CUSTOM DA API'),
              content: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFieldUtils.buildField(
                      context,
                      label: 'Url',
                      controller: urlController,
                      filled: true,
                      validator: (value) {
                        if (!Uri.parse(value!).isAbsolute) {
                          return 'Url Inválida.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('CANCELAR'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text('SALVAR'),
                  onPressed: () async {
                    if (_form.currentState!.validate()) {
                      await NetworkDatabase.saveEnvironment(
                        Environment.custom,
                        url: urlController.text,
                      );
                      await onTap(Environment.custom);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
