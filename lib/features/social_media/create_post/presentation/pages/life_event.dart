import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LifeEvent extends StatefulWidget {
  const LifeEvent({super.key});

  @override
  State<LifeEvent> createState() => _LifeEventState();
}

class _LifeEventState extends State<LifeEvent> {

  initState() {
    context.read<CreatePostCubit>().getLifeEventCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Life Event",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),),
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context,state) {
          var cubit = context.read<CreatePostCubit>();
          return Column(
            // shrinkWrap: true,
            // padding: const EdgeInsets.all(0),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child:Image.asset(
                  Assets.lifeEvent,
                  width: double.infinity,
                  height: 116,
                  fit: BoxFit.fill,
                )
              ),
              const SizedBox(
                width: 225,
                child:Text("Share and remember important moments from your life.",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 8,),
              const Divider(),
              const SizedBox(height: 16,),
              const Text("SELECT A CATEGORY",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
              const SizedBox(height: 8,),

              Expanded(
                child:cubit.isLoadingMoreLifeEvent?Center(child: CircularProgressIndicator(),):GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: cubit.lifeEventCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1,),
                  itemBuilder: (context, index) {
                    print(cubit.lifeEventCategories[index].image);
                    return ClickableWidget(
                      onTap: (){
                        context.push(Routes.LIFEEVENTSub,extra: cubit.lifeEventCategories[index]);
                      },
                      child: Container(
                        padding:  const EdgeInsetsDirectional.only(end: 10,bottom: 16),
                        child: Column(
                            children: [
                              CachedSvgImage(
                                  imageUrl: cubit.lifeEventCategories[index].image,fallbackImage:Assets.logo,height: 42,width: 42
                              ),
                              // SvgPicture.network(cubit.lifeEventCategories[index].image,height: 42,width: 42,fit: BoxFit.fill,),
                              // ImageFromInternet(image: cubit.lifeEventCategories[index].image,height: 42,width: 42,fit: BoxFit.fill,defaultLogo: true,isSvg: true,),
                              // Image.asset(
                              //   Assets.lifeEvent,
                              //   width: 42,
                              //   height: 42,
                              //   fit: BoxFit.fill,
                              // ),
                              const SizedBox(height: 8,),
                              Text(context.isArabic?cubit.lifeEventCategories[index].titleAr:cubit.lifeEventCategories[index].titleEn,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 2,),
                            ]
                        ),
                      ),
                    );
                  },
                )
              )
            ],
          );
        }
      ),
    );
  }
}





class CachedSvgImage extends StatefulWidget {
  final String imageUrl;
  final String fallbackImage; // Local fallback SVG
  final double width;
  final double height;
  final Color? color;

  const CachedSvgImage({
    required this.imageUrl,
    this.fallbackImage = "assets/fallback.svg", // Default fallback SVG
    this.color, // Default fallback SVG
    this.width = 100,
    this.height = 100,
    Key? key,
  }) : super(key: key);

  @override
  _CachedSvgImageState createState() => _CachedSvgImageState();
}

class _CachedSvgImageState extends State<CachedSvgImage> {
  File? _svgFile;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    try {
      final file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
      if (mounted) {
        setState(() {
          _svgFile = file;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || _svgFile == null) {
      return Image.asset(
        widget.fallbackImage,
        width: widget.width,
        height: widget.height,
      );
    }

      return SvgPicture.file(
        _svgFile!,
        width: widget.width,
        color: widget.color,
        height: widget.height,
        placeholderBuilder: (context) => const CircularProgressIndicator(),
        errorBuilder: (context, error, stackTrace) {
          return SvgPicture.asset(
            widget.fallbackImage,
            width: widget.width,
            height: widget.height,
          );
        },
      );
  }
}
