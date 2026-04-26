import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fit90_gym_main/core/utils/gaps.dart';
import 'package:fit90_gym_main/core/widgets/custom_image.dart';
import 'package:fit90_gym_main/features/news/domain/entities/news.dart';
import 'package:fit90_gym_main/core/utils/image_utils.dart';

class AllNewsListItem extends StatelessWidget {
  const AllNewsListItem({
    super.key,
    required this.newsList,
    required this.itemIndex,
  });
  final NewsEntity newsList;
  final int itemIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: buildImageUrl(newsList.mainImage),
          height: 200,
          fit: BoxFit.fill,
          width: 400,
          placeholder: (context, url) => const BlankImageWidget(),
          errorWidget: (context, url, error) => const BlankImageWidget(),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            ),
          ),
        ),
        Text(
          newsList.newsTitleAr ?? "",
          //  overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Gaps.vGap20,
      ],
    );
  }
}
