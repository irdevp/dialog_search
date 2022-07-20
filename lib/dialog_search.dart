library dialog_search;

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'core/custom_dialog.dart';
import 'core/dialog_search_skeleton.dart';
import 'core/utils/constants_colors.dart';

// ignore: must_be_immutable
class DialogSearch<T> extends StatelessWidget {
  late final bool isMultiselect;

  late final List<int> initialItemIndex;
  Map<int, T> mapItems = {};

  late List<T> items;
  final dynamic initialValue;

//WEB
  late final String url;
  late final bool isWeb;
  late final List<T> Function(Response json) fromJson;
  late final String Function(String search) urlInSearch;

//ALL

  final void Function(List<T> newValue)? onChange;
  final bool Function()? beforeChange;

  final Widget Function(T item) fieldBuilderExternal;
  final Widget Function(T item, bool selected, RichText searchContrast)
      itemBuilder;
  final String Function(T) attributeToSearch;

  late final DialogSearchStyle? dialogStyle;
  DialogSearch.single(
      {Key? key,
      required this.items,
      this.initialValue,
      this.onChange,
      this.beforeChange,
      required this.attributeToSearch,
      required this.fieldBuilderExternal,
      required this.itemBuilder,
      this.dialogStyle})
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
      required this.attributeToSearch,
      this.initialValue,
      this.onChange,
      this.beforeChange,
      this.dialogStyle,
      required this.itemBuilder,
      required this.fieldBuilderExternal})
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
      this.initialValue,
      this.onChange,
      required this.attributeToSearch,
      this.beforeChange,
      this.dialogStyle,
      required this.itemBuilder,
      required this.url,
      required this.fromJson,
      required this.urlInSearch,
      required this.fieldBuilderExternal})
      : assert(initialValue.runtimeType == T || initialValue == null),
        super(key: key) {
    isMultiselect = false;
    isWeb = true;
    mapItems = {};
    initialItemIndex = [];
  }

  @override
  Widget build(BuildContext context) {
    dialogStyle ??= DialogSearchStyle();
    dialogStyle!.dialogFrameStyle ??=
        DialogFrameStyle(backgroundColor: Colors.white, hasDivider: false);

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
                itemBuild: itemBuilder,
                fromJson: fromJson,
                dialogStyle: dialogStyle!,
                attributeToSearch: attributeToSearch,
                items: mapItems,
                selectedValueIndex: selectedValueIndex.value != null &&
                        selectedValueIndex.value!.isNotEmpty
                    ? selectedValueIndex.value!.first
                    : null,
                isWeb: isWeb,
                url: url,
                urlInSearch: urlInSearch,
              ),
            );
          },
        ))
            .then((value) {
          if (isWeb && value != null && value.isNotEmpty) {
            items = value;
            mapItems = value.asMap();
            selectedValueIndex.value = [0];
          } else if (value != null && value.isNotEmpty) {
            selectedValueIndex.value = value;
          }
          if (onChange != null) {
            onChange!(selectedValueIndex.value!
                .map((e) => mapItems.values.toList()[e])
                .toList());
          }
        });
      },
      child: Hero(
        tag: 'field_hero',
        child: Material(
            color: Colors.transparent,
            child: Container(
              padding: dialogStyle!.mainFieldStyle?.padding,
              decoration: dialogStyle!.mainFieldStyle?.toBoxDecoration(),
              child: ValueListenableBuilder(
                  valueListenable: selectedValueIndex,
                  builder: (_, List<int>? value, child) {
                    // print(value);
                    return Row(
                      children: [
                        dialogStyle!.mainFieldStyle?.preffixWidget ??
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
                                  ? fieldBuilderExternal(items[value.first])
                                  : const Text(
                                      "Select",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: DefaultTheme.defaultTextColor),
                                    ),
                        ),
                        dialogStyle!.mainFieldStyle?.suffixWidget ??
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
  FieldStyle? mainFieldStyle;
  DialogFrameStyle? dialogFrameStyle;
  Color? selectedItemColor;
  Color? unselectedItemColor;
  double radius;
  DialogSearchStyle(
      {this.dialogFrameStyle,
      this.mainFieldStyle,
      this.selectedItemColor,
      this.unselectedItemColor,
      this.radius = 8});
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

class DialogFrameStyle {
  final Color? backgroundColor;
  final double radius;
  final bool hasDivider;
  final double elevation;

  DialogFrameStyle(
      {this.elevation = 1,
      this.hasDivider = false,
      this.backgroundColor,
      this.radius = 8});
}
