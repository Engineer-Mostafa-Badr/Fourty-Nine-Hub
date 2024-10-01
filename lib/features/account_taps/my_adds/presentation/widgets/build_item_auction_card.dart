import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/badged_label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../account_taps/my_adds/domain/entity/my_ads_auction.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../cubit/my_adds_cubit.dart';

class BuildItemAuctionCard extends StatelessWidget {
  final MyAuctionAdsEntity item;
  //final Function(String) onDelete;

  const BuildItemAuctionCard(
      {super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
                      "${LocaleKeys.createdOn.localize} ${DateFormat(
                          'yyyy-MM-dd').format(item.createdAt) }"),
                  const Sizer(
                    height: 15,
                  ),
                  _buildContactInfo(context),
                  const Sizer(
                    height: 15,
                  ),
                  Row(
                    children: [
                      BadgedLabel(
                        label: item.isApproved == true
                            ? LocaleKeys.active.localize
                            : LocaleKeys.pending.localize,
                        color: AppColors.SECONDARY_COLOR,
                        style: Styles.smallText(color: Colors.white),
                      ),
                      if (item.isApproved == false) ...[
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
                            backColor: AppColors.PRIMARY_COLOR,
                            color: AppColors.AUTH_CONTAINER_COLOR,
                            label: LocaleKeys.edit.localize,
                            onPressed: () {}
                                // showAreYouSure(
                                //     title: LocaleKeys.deleteAd.localize,
                                //     subTitle: LocaleKeys.sureRemoveAd.localize,
                                //     action: () {
                                //       //  onDelete(item.id);
                                //     },
                                //     context: context),
                          )),
                      const Sizer(),
                      Expanded(
                          child: AppButton(
                            color: AppColors.AUTH_CONTAINER_COLOR,
                            label: LocaleKeys.subscriptions.localize,
                            onPressed: () {
                              serviceLocator<SubscriptionController>()
                                  .showSubscriptionPlans(
                                wallets: [
                                  WalletTypes.mainWallet,
                                  WalletTypes.giftWallet,
                                  WalletTypes.balance,
                                ],
                                subCategoryId: item.subCategory.id,
                                title: LocaleKeys.ads.localize,
                              );
                            },
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
      height: 140.h,
      padding: EdgeInsets.all(10.w),
      color: Theme
          .of(context)
          .primaryColor,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: ImageFromInternet(
            image: (item.images.isNotEmpty)
                ? item.images[0].photo // Casting to String
                : '', // Provide a fallback image or handle the empty state
            height: 150.h,
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // SquareImage(radius: 10, source: NetworkImage(item.images.first))),
        const Sizer(
          width: 20,
        ),
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: item.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                ),
                Label(
                  text: '${item.price}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                ),
                // Label(
                //     text: item.description,
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 1,
                //     color: Theme.of(context).scaffoldBackgroundColor),
                Row(
                  children: [
                    Label(
                        text: context.locale == Locales.english
                            ? item.mainCategory.nameEn
                            : item.mainCategory.nameAr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        color: Theme
                            .of(context)
                            .scaffoldBackgroundColor),
                    const Sizer(),
                    Label(
                        text: context.locale == Locales.english
                            ? item.subCategory.nameEn
                            : item.subCategory.nameAr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        color: Theme
                            .of(context)
                            .scaffoldBackgroundColor),
                  ],
                ),
              ],
            )),
        InkWell(
          onTap: () {
            bottomSheet(
                context: context,
                isScrollControlled: true,
                widget: ListView(
                  shrinkWrap: true,
                  children: [
                    if (item.isApproved == true)
                      _buildOptionsWidget(
                        label: LocaleKeys.markSsSold.localize,
                        onTap: () {
                          context
                              .read<MyAddsCubit>()
                              .deleteMyInstallment(id: item.id);
                          Navigator.pop(context);
                        },
                        icon: Icons.hourglass_empty_rounded,
                      ),
                    if (item.isApproved == true)
                      _buildOptionsWidget(
                        label: LocaleKeys.deactivate.localize,
                        onTap: () {
                          context
                              .read<MyAddsCubit>()
                              .deleteMyInstallment(id: item.id);
                          Navigator.pop(context);
                        },
                        icon: Icons.refresh,
                      ),
                    if (item.isApproved == false)
                      _buildOptionsWidget(
                        label: LocaleKeys.deleteAd.localize,
                        onTap: () {
                          context
                              .read<MyAddsCubit>()
                              .deleteMyInstallment(id: item.id);
                          Navigator.pop(context);
                          // showAreYouSure(
                          //   title: LocaleKeys.deleteAd.localize,
                          //   subTitle: LocaleKeys.sureRemoveAd.localize,
                          //   action: (){
                          //
                          //   }, context: context,
                          // );
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
              color: Theme
                  .of(context)
                  .scaffoldBackgroundColor),
        )
      ]),
    );
  }

  Widget _buildContactInfo(context) {
    return Row(
      children: [
        Expanded(
            child: _buildContactItem(
                icon: Icons.visibility_outlined,
                label: LocaleKeys.view.localize,
                value: item.viewCountLength,
                context: context)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.call_outlined,
                label: LocaleKeys.tel.localize,
                value: item.phoneCountLength,
                context: context)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.chat_bubble_outline,
                label: LocaleKeys.chats.localize,
                value: item.chatCountLength,
                context: context)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.favorite_border_outlined,
                label: LocaleKeys.like.localize,
                value: item.loveCountLength,
                context: context)),
      ],
    );
  }

  Widget _buildContactItem({required IconData icon,
    required String label,
    required int value,
    required context}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme
                .of(context)
                .primaryColor,
          ),
          child: Icon(
            icon,
            color: Theme
                .of(context)
                .scaffoldBackgroundColor,
          ),
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