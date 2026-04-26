import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit90_gym_main/Features/offers/domain/entities/offers_entity.dart';
import 'package:fit90_gym_main/Features/offers/presentation/views/widgets/custom_offer_rateing.dart';
import 'package:fit90_gym_main/core/utils/image_utils.dart';

class AllOffersListItem extends StatelessWidget {
  const AllOffersListItem({
    super.key,
    required this.offersList,
    required this.itemIndex,
    this.home = false,
  });
  final OffersEntity offersList;
  final int itemIndex;
  final bool home;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة بالحجم الكامل
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            child: CachedNetworkImage(
              imageUrl: buildImageUrl(offersList.imagePath ?? offersList.image),
              height: home ? 180.h : 250.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: home ? 180.h : 250.h,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: home ? 180.h : 250.h,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          // المحتوى
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomOfferRating(
                  title: offersList.offerName ?? "",
                  price: offersList.offerValue ?? "",
                  rate: offersList.rate?.toString() ?? "0",
                  checkFav: offersList.checkFav ?? "",
                ),
                // عرض الخلاصة/الوصف إذا كان موجوداً
                if ((offersList.offerDetails != null &&
                        offersList.offerDetails!.isNotEmpty) ||
                    (offersList.subTitle != null &&
                        offersList.subTitle!.isNotEmpty)) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                    ),
                    child: Text(
                      offersList.offerDetails ?? offersList.subTitle ?? "",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                      maxLines: home ? 2 : 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
