import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/controller/live_streaming_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../../../res/style/app_colors.dart';
import '../../../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_state.dart';
import '../../../../../../../reels/presentation/widgets/comments.dart';
import '../../../../../../../tinder/data/models/gift_model.dart';
import '../../../../../../../tinder/data/shared/shared.dart';
import '../../../../../../../tinder/presentation/cubit/gift_cubit.dart';

class SelectLiveGoalsScreen extends StatefulWidget {
  const SelectLiveGoalsScreen({super.key});

  @override
  State<SelectLiveGoalsScreen> createState() => _SelectLiveGoalsScreenState();
}

class _SelectLiveGoalsScreenState extends State<SelectLiveGoalsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  //dispose
  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Label(
          text: LocaleKeys.editYourLiveGoal.localize,
          style: Styles.headerText(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Label(
                text: LocaleKeys.goalExpirationIn4Hours.localize,
                style: Styles.smallText(
                  color: AppColors.SECONDARY_COLOR,
                ),
              ),
              const Sizer(),
              // Align(
              //     alignment: AlignmentDirectional.centerStart,
              //     child: Label(
              //       text: 'Describe Your LIVE goal',
              //       style: Styles.mediumText(
              //           color: AppColors.PRIMARY_COLOR,
              //           fontWeight: FontWeight.normal),
              //     )),
              const Sizer(),
              // const Sizer(),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 100.h,
                ),
                child: TextField(
                  controller: _descriptionController,
                  // textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: LocaleKeys.describeYourGoal.localize,
                      isCollapsed: false,
                      filled: false,
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        onPressed: () {
                          _descriptionController.clear();
                        },
                      )),
                  maxLines: null,
                ),
              ),
              const Sizer(),
              const Sizer(),
              const Divider(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(15),
                // margin: EdgeInsets.all(10.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<StreamCubit, StreamState>(
                          builder: (context, state) {
                            return Label(
                          text:
                              '${LocaleKeys.progress.localize} ${context.read<StreamCubit>().state.selectedGifts.length}/${context.read<GiftsCubit>().state.gifts.length} ${LocaleKeys.gift.localize}',
                          style: Styles.mediumText(color: Colors.white),
                        );
                          },
                        ), 
                        InkWell(
                          onTap: () {
                            showGiftBottomSheet(context,
                                receiverId:
                                    context.read<UserCubit>().state.data!.id,
                                forSelect: true, selectGift: (gift) {
                              context.read<StreamCubit>().selectGift(gift);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: AppColors.SECONDARY_COLOR,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                const Sizer(),
                                Label(
                                  text: LocaleKeys.gift.localize,
                                  style: Styles.mediumText(color: Colors.white),
                                ),
                                const Sizer(),
                                const Sizer(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    BlocListener<StreamCubit, StreamState>(
                      listener: (context, state) {
                        if (state.isSuccess) {
                          // showSuccessMessage(
                          //     context, 'Success ${state.toString()}');
                        }
                      },
                      child: BlocBuilder<StreamCubit, StreamState>(
                          builder: (context, state) {
                        return SizedBox(
                          height: context.screenHeight / 2,
                          child: GridView.builder(
                            // shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.selectedGifts.isEmpty
                                ? 0
                                : state.selectedGifts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / 1.2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              return GiftItemWidget(
                                  gift: state.selectedGifts[index]);
                            },
                          ),
                        );
                      }),
                    ),
                    const Sizer(),
                  ],
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10)),
                  width: context.screenWidth * 0.8,
                  height: 100.h,
                  padding: const EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 20.h),
                  child: Center(
                    child: Label(
                      text: LocaleKeys.confirm.localize,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GiftItemWidget extends StatelessWidget {
  final GiftData gift;
  final TextEditingController _quantityController = TextEditingController();

  GiftItemWidget({super.key, required this.gift});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  context.read<StreamCubit>().unselectGift(gift);
                },
                child: const Icon(Icons.close),
              ),
            ),
            SvgPicture.network(
              gift.picture!,
              width: 100.w,
              height: 100.h,
            ), // Gift icon
            Label(
                text: context.isArabic ? gift.nameAr! : gift.nameEn!,
                style: Styles.smallText(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on,
                    color: isDarkTheme(context)
                        ? AppColors.ACCENT_COLOR
                        : AppColors.PRIMARY_COLOR),
                Label(text: '${gift.value}', style: TextStyle(fontSize: 25.sp)),
              ],
            ),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                hintText: '0/100',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int? quantity = int.tryParse(value);
                if (quantity == null || quantity < 0 || quantity > 100) {
                  _quantityController.text = '';
                  _quantityController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _quantityController.text.length),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
