import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 
'../../../../../routes/routes.dart';

class MyAdCard extends StatelessWidget {
  final AdEntity item;
  final Function(String) onDelete;

  const MyAdCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        context.push(Routes.ADdetails, extra: item.id);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.LIGHT_GRAY_COLOR,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdInfo(context),
            Sizer(
              height: 10.h,
            ),
            Container(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                      text:
                          "${LocaleKeys.createdOn.localize} ${item.formatedDate}"),
                  const Sizer(
                    height: 15,
                  ),
                  _buildContactInfo(),
                  const Sizer(
                    height: 15,
                  ),
                  Row(
                    children: [
                      BadgedLabel(
                        label: item.approved == true
                            ? LocaleKeys.active.localize
                            : LocaleKeys.pending.localize,
                        color: AppColors.SECONDARY_COLOR,
                        style: Styles.smallText(color: Colors.white),
                      ),
                      if (item.approved == false) ...[
                        const Sizer(
                          width: 15,
                        ),
                        Expanded(
                            child: Text(
                          LocaleKeys.adReviewSoon.localize,
                        )),
                      ]
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                          child: AppButton(
                        label: LocaleKeys.edit.localize,
                        onPressed: () => showAreYouSure(
                            title: LocaleKeys.deleteAd.localize,
                            subTitle: LocaleKeys.sureRemoveAd.localize,
                            action: () {
                              //  onDelete(item.id);
                            },
                            context: context),
                      )),
                      const Sizer(),
                      Expanded(
                          child: AppButton(
                        label: LocaleKeys.subscriptions.localize,
                        onPressed: () => showAreYouSure(
                            title: LocaleKeys.deleteAd.localize,
                            subTitle: LocaleKeys.sureRemoveAd.localize,
                            action: () {
                              // onDelete(item.id);
                            },
                            context: context),
                      )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsWidget({
    required String label,
    required Function onTap,
    required IconData icon,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Label(
            text: label,
          ),
          onTap: () => onTap(),
        ),
      ],
    );
  }

  Widget _buildAdInfo(BuildContext context) {
    return Container(
      height: 160.h,
      padding: EdgeInsets.all(10.w),
      color: AppColors.GRAY_LIGHT_COLOR3,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: ImageFromInternet(
          image: item.images.first,
          height: 160.h,
        )),
        // SquareImage(radius: 10, source: NetworkImage(item.images.first))),
        const Sizer(
          width: 20,
        ),
        Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: item.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                Label(
                    text: '${LocaleKeys.currency.localize} ${item.price}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    color: Theme.of(context).scaffoldBackgroundColor),
                Label(
                    text: item.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    color: Theme.of(context).scaffoldBackgroundColor),
              ],
            )),
        InkWell(
          onTap: () {
      ManageVibration.vibrate();
            bottomSheet(
                context: context,
                isScrollControlled: true,
                widget: ListView(
                  shrinkWrap: true,
                  children: [
                    if (item.approved == true)
                      _buildOptionsWidget(
                        label: LocaleKeys.markSsSold.localize,
                        onTap: () {
      ManageVibration.vibrate();
                          context.pop();
                          showAreYouSure(
                              title: LocaleKeys.alert.localize,
                              subTitle: LocaleKeys.adSoldout.localize,
                              action: () => context.pop(),
                              context: context);
                        },
                        icon: Icons.hourglass_empty_rounded,
                      ),
                    if (item.approved == true)
                      _buildOptionsWidget(
                        label: LocaleKeys.deactivate.localize,
                        onTap: () {
      ManageVibration.vibrate();
                          showAreYouSure(
                              title: LocaleKeys.alert.localize,
                              subTitle: LocaleKeys.adSoldout.localize,
                              action: () {},
                              context: context);
                        },
                        icon: Icons.refresh,
                      ),
                    if (item.approved == false)
                      _buildOptionsWidget(
                        label: LocaleKeys.deleteAd.localize,
                        onTap: () {
      ManageVibration.vibrate();
                          showAreYouSure(
                              title: LocaleKeys.deleteAd.localize,
                              subTitle: LocaleKeys.sureRemoveAd.localize,
                              action: () {
                                onDelete(item.id);
                              },
                              context: context);
                        },
                        icon: Icons.delete,
                      ),
                    _buildOptionsWidget(
                      label: LocaleKeys.cancel.localize,
                      onTap: () => context.pop(),
                      icon: Icons.close,
                    ),
                  ],
                ));
          },
          child: Icon(Icons.more_vert,
              color: Theme.of(context).scaffoldBackgroundColor),
        )
      ]),
    );
  }

  Widget _buildContactInfo() {
    return Row(
      children: [
        Expanded(
            child: _buildContactItem(
                icon: Icons.visibility_outlined,
                label: LocaleKeys.view.localize,
                value: item.statistics?.views ?? 0)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.call_outlined,
                label: LocaleKeys.tel.localize,
                value: item.statistics?.calls ?? 0)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.chat_bubble_outline,
                label: LocaleKeys.chats.localize,
                value: item.statistics?.chats ?? 0)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.favorite_border_outlined,
                label: LocaleKeys.like.localize,
                value: item.statistics?.requests ?? 0)),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required int value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.LIGHT_GRAY_COLOR,
          ),
          child: Icon(icon),
        ),
        const Sizer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: '$value',
                style: Styles.mediumText(fontSize: 22),
              ),
              Label(
                text: label,
                style: Styles.mediumText(fontSize: 26),
              ),
            ],
          ),
        )
      ],
    );
  }
}
