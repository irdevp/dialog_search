library dialog_search;

import 'package:flutter/material.dart';

import 'core/custom_dialog.dart';
import 'core/dialog_search_skeleton.dart';
import 'core/utils/constants_colors.dart';

class DialogSearch<T> extends StatelessWidget {
  late final bool isMultiselect;
  late final bool isWeb;
  late final List<int> initialItemIndex;
  late final Map<int, T> mapItems;
  late final String url;
  final List<T> items;
  final dynamic initialValue;

  final void Function(List<T> newValue)? onChange;
  final bool Function()? beforeChange;

  final Widget Function(T item) fieldItemExternal;
  final DialogSearchStyle mainFieldStyle;

  DialogSearch.single(
      {Key? key,
      required this.items,
      this.initialValue,
      this.onChange,
      this.beforeChange,
      required this.fieldItemExternal,
      this.mainFieldStyle = const DialogSearchStyle()})
      : assert(initialValue.runtimeType == T || initialValue == null),
        assert(items.contains(initialValue) == true || initialValue == null),
        super(key: key) {
    isMultiselect = false;
    isWeb = false;
    initialItemIndex = [if (initialValue != null) items.indexOf(initialValue)];
    mapItems = items.asMap();
  }

  DialogSearch.multi(
      {Key? key,
      required this.items,
      this.initialValue,
      this.onChange,
      this.beforeChange,
      this.mainFieldStyle = const DialogSearchStyle(),
      required this.fieldItemExternal})
      : assert((initialValue.runtimeType == List<T>) || initialValue == null),
        super(key: key) {
    isMultiselect = true;
    isWeb = false;

    if (initialValue != null) {
      final List<int> multiIndex = initialValue.map((i) {
        final int index = items.indexOf(i);
        if (index != -1) {
          return index;
        }
      }).toList();
      if (multiIndex.isNotEmpty) {
        initialItemIndex = multiIndex;
      } else {
        initialItemIndex = [];
      }
    } else {
      initialItemIndex = [];
    }
    mapItems = items.asMap();
  }

  DialogSearch.web(
      {Key? key,
      this.items = const [],
      this.initialValue,
      this.onChange,
      this.beforeChange,
      this.mainFieldStyle = const DialogSearchStyle(),
      required this.url,
      required this.fieldItemExternal})
      : assert(initialValue.runtimeType == T || initialValue == null),
        super(key: key) {
    isMultiselect = false;
    isWeb = true;
    mapItems = {};
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('RMK dialog_search');
    final ValueNotifier<List<int>?> selectedValueIndex =
        ValueNotifier<List<int>?>(initialItemIndex);
    return GestureDetector(
      onTap: () async {
        Navigator.of(context, rootNavigator: true)
            .push(DialogSearchSkeleton(
          barrierColor: Colors.transparent,
          builder: (BuildContext dialogContext) {
            return SafeArea(
              child: CustomDialog<T>(
                itemLabel: ((item) {
                  return item.nome;
                }),
                listItem: mapItems,
                selectedValueIndex: selectedValueIndex.value != null &&
                        selectedValueIndex.value!.isNotEmpty
                    ? selectedValueIndex.value!.first
                    : null,
              ),
            );
          },
        ))
            .then((value) {
          if (value != null && value.isNotEmpty) {
            selectedValueIndex.value = value;

            if (onChange != null) {
              onChange!(
                  selectedValueIndex.value!.map((e) => items[e]).toList());
            }
          }
        });
      },
      child: Hero(
        tag: 'field_hero',
        child: Material(
            color: Colors.transparent,
            child: Container(
              padding: mainFieldStyle.fieldStyle?.padding,
              decoration: mainFieldStyle.fieldStyle?.toBoxDecoration(),
              child: ValueListenableBuilder(
                  valueListenable: selectedValueIndex,
                  builder: (_, List<int>? value, child) {
                    return Row(
                      children: [
                        mainFieldStyle.fieldStyle?.preffixWidget ??
                            const SizedBox.shrink(),
                        Expanded(
                          child: isMultiselect && (value ?? []).isNotEmpty
                              ? Wrap(
                                  children: (value ?? [])
                                      .map((e) => Container(
                                            color: Colors.red,
                                            child: Text(e.toString()),
                                          ))
                                      .toList())
                              : value!.isNotEmpty
                                  ? fieldItemExternal(items[value.first])
                                  : const Text(
                                      "Select",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: DefaultTheme.defaultTextColor),
                                    ),
                        ),
                        mainFieldStyle.fieldStyle?.suffixWidget ??
                            const SizedBox.shrink()
                      ],
                    );
                  }),
            )),
      ),
    );
  }
}

class DialogSearchStyle {
  final FieldStyle? fieldStyle;

  const DialogSearchStyle({this.fieldStyle});
}

class FieldStyle {
  final Widget? suffixWidget;
  final Widget? preffixWidget;
  final List<BoxShadow>? shadow;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final BoxBorder? border;

  const FieldStyle(
      {this.suffixWidget,
      this.preffixWidget,
      this.shadow,
      this.radius,
      this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      this.color,
      this.gradient,
      this.border});

  BoxDecoration? toBoxDecoration() {
    return BoxDecoration(
        borderRadius: radius,
        border: border,
        color: color,
        gradient: gradient,
        boxShadow: shadow);
  }
}
