import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class SelectDropOffPoints extends StatefulWidget {
  const SelectDropOffPoints({super.key});

  @override
  State<SelectDropOffPoints> createState() => _selectDropOffPointsState();
}

class _selectDropOffPointsState extends State<SelectDropOffPoints> {
  FocusManager fromFocus = FocusManager();
  FocusManager toFocus = FocusManager();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * .7,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Label(
                text: 'Enter Your route',
                style: Styles.mediumText(fontWeight: FontWeight.bold),
              )),
              InkWell(
                onTap: () {
                  context.pop();
                },
                child: CircleAvatar(
                    backgroundColor: Colors.grey[50],
                    child: const Icon(
                      Icons.clear,
                    )),
              )
            ],
          ),
          const Sizer(),
          FormTextField(
              // controller: controller.fromAddressTextController,
              hint: 'From',
              maxLines: 1,
              prefix: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    radius: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 4,
                    ),
                  ),
                ],
              ),
              action: (v) {}),
          const Sizer(),
          FormTextField(
              maxLines: 1,
              // controller: controller.toAddressTextController,
              hint: 'To',
              prefix: const Icon(
                Icons.location_on,
              ),
              action: (v) {
                setState(() {});
              }),
          const Sizer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  child: Label(text: 'Search', style: Styles.mediumText())),
              const SizedBox(),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(
                      Icons.map,
                      color: Colors.blue,
                    ),
                    const Sizer(),
                    Label(
                      text: 'Choose on map',
                      style: Styles.mediumText(color: Colors.blue),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Sizer(),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {

                  return InkWell(
                    onTap: () {

                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                        ),
                        const Sizer(),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Label(text: 'Bn Khalifa St.', style: Styles.mediumText(),),
                            Label(text: '23 km',style:  Styles.mediumText(color: Colors.grey),),
                         
                             ],
                        )),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: 4),
          )
        ],
      ),
    );
  }
}
