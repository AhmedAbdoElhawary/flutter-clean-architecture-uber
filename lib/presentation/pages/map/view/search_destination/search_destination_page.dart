import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uber/config/routes/route_app.dart';
import 'package:uber/core/resources/color_manager.dart';
import 'package:uber/core/resources/styles_manager.dart';
import 'package:uber/presentation/common/widgets/custom_circulars_progress.dart';
import 'package:uber/presentation/common/widgets/custom_elevated_button.dart';
import 'package:uber/presentation/common/widgets/custom_google_map.dart';
import 'package:uber/presentation/pages/map/logic/map_logic.dart';
import 'package:uber/presentation/pages/map/logic/search_destination/appearance_of_search_list_logic.dart';
import 'package:uber/presentation/pages/map/logic/search_destination/search_destination_logic.dart';
import 'package:uber/presentation/pages/map/widgets/map_widgets/location_icon.dart';
import 'package:uber/presentation/pages/map/widgets/search_text_field.dart';

class SearchDestinationPage extends StatelessWidget {
  const SearchDestinationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapLogic mapControl = Get.put(MapLogic(), tag: "3");
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => mapControl.getCurrentPosition != null
              ? MapDisplay(mapControl: mapControl)
              : const Center(
                  child: ThineCircularProgress(color: ColorManager.black)),
        ),
      ),
    );
  }
}

class MapDisplay extends StatelessWidget {
  const MapDisplay({Key? key, required this.mapControl}) : super(key: key);

  final MapLogic mapControl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomGoogleMap(mapControl: mapControl),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: REdgeInsets.symmetric(vertical: 35, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Align(
                    alignment: Alignment.centerRight,
                    child: MyLocationIcon(tag: "3")),
                const RSizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: () {},
                  backgroundColor: ColorManager.black,
                  withoutPadding: true,
                  circularRadius: 0,
                  child: Text(
                    "Done",
                    style:
                        getNormalStyle(color: ColorManager.white, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
        const Align(
            alignment: Alignment.topCenter, child: _ResultsOfSearchText()),
      ],
    );
  }
}

class _ResultsOfSearchText extends StatelessWidget {
  const _ResultsOfSearchText();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppearanceOfSearchListLogic>(
      id: "pointer",
      initState: (state) {
        Get.put(AppearanceOfSearchListLogic(), tag: "1");
      },
      tag: "1",
      builder: (controller) {
        return Stack(
          children: [
            AnimatedPositioned(
                top: controller.getPositionInTop,
                bottom: 0,
                left: 0,
                right: 0,
                duration: controller.disAppearTheResult
                    ? const Duration(milliseconds: 200)
                    : const Duration(milliseconds: 1),
                child: Listener(
                    onPointerDown: controller.onListPointerDown,
                    onPointerUp: controller.onListPointerUp,
                    onPointerMove: (d) =>
                        controller.onListPointerMove(d, context),
                    child: const _SavedResultsList())),
            const Align(alignment: Alignment.topCenter, child: SearchBars()),
          ],
        );
      },
    );
  }
}

class _SavedResultsList extends StatelessWidget {
  const _SavedResultsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> map = [];

    return Container(
        color: ColorManager.white,
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                    onTap: () {},
                    child: const _CustomListTitle(
                        text: "Saved Places", icon: Icons.star));
              } else if (index == map.length + 2 - 1) {
                return GestureDetector(
                    onTap: () {},
                    child: const _CustomListTitle(
                        text: "Set location on map", icon: Icons.location_on));
              } else {
                return GestureDetector(
                    onTap: () {},
                    child: _CustomListTitle(
                        text: map[index - 1]["title"] ?? "",
                        subText: map[index - 1]["subTitle"] ?? "",
                        icon: map[index - 1]["icon"] == "star"
                            ? Icons.star
                            : Icons.location_on));
              }
            },
            separatorBuilder: (context, index) {
              if (map.length > 2 && index == 0) {
                return Divider(
                    color: ColorManager.veryLightGrey,
                    thickness: 5.h,
                    height: 5.h);
              } else {
                return Divider(color: ColorManager.veryLightGrey, height: 1.h);
              }
            },
            itemCount: map.length + 2));
  }
}

class SearchBars extends StatelessWidget {
  const SearchBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      shadowColor: ColorManager.grey.withOpacity(0.3),
      color: ColorManager.white,
      child: SizedBox(
        height: 130.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SwitchRiderWidgets(),
            Row(
              children: [
                const _PointSquareWidget(),
                _SearchTextFields(),
                const _AddIcon()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PointSquareWidget extends StatelessWidget {
  const _PointSquareWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.circle, color: ColorManager.grey, size: 9.r),
          Container(height: 30.h, width: 1.w, color: ColorManager.black),
          Icon(Icons.square, size: 9.r),
        ],
      ),
    );
  }
}

class _SearchTextFields extends StatelessWidget {
  _SearchTextFields({Key? key}) : super(key: key);

  final AppearanceOfSearchListLogic appearanceController = Get.find(tag: "1");

  @override
  Widget build(BuildContext context) {
    final textFieldsController = Get.put(SearchDestinationLogic(), tag: "1");

    return Flexible(
      child: Padding(
        padding: REdgeInsetsDirectional.only(end: 15),
        child: Column(
          children: [
            Listener(
              onPointerDown: (d) {
                appearanceController.changeTheAppearing(false);
              },
              child: SearchTextField(
                  controller: textFieldsController.fromController,
                  hint: "Where from?"),
            ),
            const RSizedBox(height: 10),
            Listener(
              onPointerDown: (d) {
                appearanceController.changeTheAppearing(false);
              },
              child: SearchTextField(
                  controller: textFieldsController.toController,
                  hint: "Where to?"),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddIcon extends StatelessWidget {
  const _AddIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: REdgeInsetsDirectional.only(end: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            RSizedBox(height: 40),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}

class _SwitchRiderWidgets extends StatelessWidget {
  const _SwitchRiderWidgets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: REdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  Go.back();
                },
                child: Icon(Icons.arrow_back, size: 30.r)),
            const Spacer(),
            const Text("Switch rider"),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _CustomListTitle extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subText;

  const _CustomListTitle({
    Key? key,
    required this.icon,
    required this.text,
    this.subText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorManager.lightGrey,
            radius: 18.r,
            child: Center(
                child: Icon(icon, color: ColorManager.white, size: 20.r)),
          ),
          const RSizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(text, style: getNormalStyle(fontSize: 14)),
              if (subText.isNotEmpty) ...[
                const RSizedBox(height: 5),
                Text(subText,
                    style:
                        getNormalStyle(fontSize: 13, color: ColorManager.grey)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
