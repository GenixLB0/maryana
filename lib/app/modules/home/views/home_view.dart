import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:maryana/app/modules/search/views/result_view.dart';
import 'package:maryana/app/modules/search/views/search_view.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart' hide boldTextStyle hide primaryTextStyle;

import 'package:shimmer/shimmer.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    controller.getHomeApi();

    return  Scaffold(

      extendBody: true,
backgroundColor: Colors.white,


      body: Obx(()=> SafeArea(
          bottom: false,
          child:Column(
            children: [
              SizedBox(height: 20,),
              buildUpperBar(context),
              buildSearchAndFilter(context),
              SizedBox(height: 10.h,),
              buildCatScroll(context),

              SizedBox(height: 20.h,),
              Expanded(

                child: SingleChildScrollView(
                  controller: controller.scrollController,

                  scrollDirection: Axis.vertical,
                  child: Container(

                    child: Column(
                      children: [
                        buildBannerScroll(context),
                        SizedBox(height: 15.h,),
                        buildCustomCatScroll(context),
                        SizedBox(height: 15.h,),
                        buildProductsScroll(context),
                        SizedBox(height: 25.h,),
                        buildRecommendedScroll(context),
                        SizedBox(height: 25.h,),
                      ],
                    ),
                  ),
                ),
              )


              // buildBannerScroll(context),
            ],
          )
      ),),
        bottomNavigationBar: CustomNavBar( scrollController: controller.scrollController,),
    );
  }
  
  buildBannerScroll(context){
    return

      controller.isHomeLoading.value ?
      LoadingWidget(
        Container(
          width: MediaQuery.of(context).size.width,
          height: 450.h,
          color: Colors.grey,
        ),
      )

      :

      controller.homeModel.value.banners != null ?

      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 470.h,

        child:
        controller.homeModel.value.banners!.isEmpty ?

        ListView.separated(
            scrollDirection: Axis.horizontal,

            itemBuilder: (ctx , index){


              return  Container(
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.sp),


                  ),
                  child:
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/placeholder.png",

                    ),
                  )

              );
            },
            separatorBuilder: (ctx , index)=> SizedBox(width: 55.w,) ,
            itemCount: 3
        )

            :


        ListView.separated(
            scrollDirection: Axis.horizontal,

            itemBuilder: (ctx , index){


              return  Container(

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.sp),


                  ),
                  child:
                  controller.homeModel.value.banners![index].isNotEmpty ?

                  CachedNetworkImage(
                    imageUrl:

                    controller.homeModel.value.banners![index] ,
                    placeholder: (ctx , v){
                      return Image.asset("assets/images/placeholder.png",

                      );
                    },

                  )
                      :
                  Image.asset("assets/images/placeholder.png",

                  )
              );
            },
            separatorBuilder: (ctx , index)=> SizedBox(width: 1.w,) ,
            itemCount: controller.homeModel.value.banners!.length
        ),
      )
          :
      SizedBox();





  }


  buildcustomBannerScroll(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 450.h,
      color: Colors.green,
    );
  }

  buildCustomCatScroll(context){

    return Padding(
      padding:  EdgeInsets.only(left: 15.w),
      child: Container(

        height: 200.h,
        width: MediaQuery.of(context).size.width,

        child:
        controller.isHomeLoading.value ?
        ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx , index){


              return

                LoadingWidget(
                  SizedBox(
                    width: 150.w,
                    child: Container(

                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.sp),
                          border: Border.all(
                              color: Colors.grey,
                              width: 1)

                      ),



                    ),
                  ),
                );

            },
            separatorBuilder: (ctx , index)=> SizedBox(width: 10.w,) ,
            itemCount: 3
        )
            :

        controller.homeModel.value.categories != null ?

        ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx , index){

print("name is ${controller.homeModel.value.categories![index].name}");
              return


                Container(

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.sp),


                ),
                child:
                controller.homeModel.value.categories![index].image != null ?
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    controller.homeModel.value.categories![index].image!.isEmpty?
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset("assets/images/placeholder.png",
                          width: 50.w,
                          height: 15.h,
                        ),

                        Text(
                            controller.homeModel.value.categories![index].name!.toUpperCase(),
                          style: boldTextStyle(
                            weight: FontWeight.w400,
                            size: 22.sp.round(),
                            color: Colors.red


                          ),
                        ),
                        SizedBox(height: 20.h,)
                      ],
                    )
                        :
                    CachedNetworkImage(
                      imageUrl:

                      controller.homeModel.value.categories![index].image! ,
                      width: 100.w,
                      height: 200.h,
                      placeholder: (ctx , v){
                        return Image.asset("assets/images/placeholder.png",
                          width: 100.w,
                          height: 200.h,
                        );
                      },

                    ),
                    const SizedBox(width: 5,),

                  ],
                )
                    :
                Row(
                  children: [
                    const SizedBox(width: 10,),

                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset("assets/images/placeholder.png",
                          width: 130.w,
                          height: 200.h,
                        ),

                        Text(
                          controller.homeModel.value.categories![index].name!.toUpperCase(),
                          style: boldTextStyle(
                              weight: FontWeight.w400,
                              size: 22.sp.round(),
                              color: Colors.white,
                            textShadows:  [
                              BoxShadow(color: Colors.black, spreadRadius: 5, blurRadius: 25),
                            ],




                          ),
                        ),
                        SizedBox(height: 20.h,)
                      ],
                    ),


                    const SizedBox(width: 5,),

                  ],
                )
              );
            },
            separatorBuilder: (ctx , index)=> SizedBox(width: 10.w,) ,
            itemCount: controller.homeModel.value.categories!.length
        )
            :
        SizedBox()

        ,
      ),
    );

  }

  buildProductsScroll(context){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  SvgPicture.asset("assets/images/home/star.svg" , width: 70.w,),
                  Padding(
                    padding:  EdgeInsets.only(left: 15.w),
                    child: Text("TRENDING COLLECTION",
                      style: boldTextStyle(
                          weight: FontWeight.w400,
                          size: 20.sp.round(),
                          color: Colors.black

                      ),

                    ),
                  )
                ],
              ),
              Spacer(),
              Text("SHOW ALL",

                style: boldTextStyle(
                    weight: FontWeight.w400,
                    size: 20.sp.round(),
                    color: Color(0xff9B9B9B)

                ),
              ),
              SizedBox(width: 15.w,)
            ],
          ),
          SizedBox(height: 5.h,),
          Container(

color: Colors.white,
            padding: EdgeInsets.all( 15.w),
            height: 340.h,
            width: MediaQuery.of(context).size.width ,

            child:
            controller.isHomeLoading.value ?
            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx , index){


                  return

                    LoadingWidget(
                      SizedBox(
                        width: 200.w,
                        child: Container(

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.sp),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 1)

                          ),



                        ),
                      ),
                    );

                },
                separatorBuilder: (ctx , index)=> SizedBox(width: 10.w,) ,
                itemCount: 4
            )
                :

            controller.homeModel.value.product != null ?

            ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx , index){


                  return

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.sp),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
                          ],

                        ),
                        child:
                        controller.homeModel.value.product![index].image != null ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            controller.homeModel.value.product![index].image!.isEmpty?
                            Image.asset("assets/images/placeholder.png",
                              width: 160.w,
                              height: 210.h,
                            )
                                :
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                CachedNetworkImage(
                                  imageUrl:

                                  controller.homeModel.value.product![index].image! ,
                                  width: 175.w,
                                  height: 210.h,
                                  fit: BoxFit.cover,
                                  placeholder: (ctx , v){
                                    return Image.asset("assets/images/placeholder.png",
                                      width: 100.w,
                                      height: 200.h,
                                    );
                                  },

                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    "assets/images/home/add_to_wishlist.svg",
                                    width: 33.w,
                                    height: 33.h,
                                    fit: BoxFit.cover,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 3.h,),
                            Padding(
                              padding:  EdgeInsets.only(left: 5.w),
                              child: Text(
                                controller.homeModel.value.product![index].name!,
                                style: primaryTextStyle(
                                    weight: FontWeight.w700,
                                    size: 16.sp.round(),
                                    color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h,),
                            Container(
                              padding:  EdgeInsets.only(left: 5.w),
                              width: 150.w,
                              child: Text(
                                controller.homeModel.value.product![index].description!,
                                overflow: TextOverflow.ellipsis,
                                style: primaryTextStyle(
                                    weight: FontWeight.w300,
                                    size: 14.sp.round(),
                                    color: Color(0xff9B9B9B)
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h,),
                            Padding(
                              padding:  EdgeInsets.only(left: 5.w),
                              child: Text(
                                "\$ ${controller.homeModel.value.product![index].price!} ",
                                style: primaryTextStyle(
                                    weight: FontWeight.w600,
                                    size: 15.sp.round(),
                                    color: Color(0xff370269)
                                ),
                              ),
                            ),
                          ],
                        )
                            :
                        Image.asset("assets/images/placeholder.png",
                          width: 200.w,
                          height: 200.h,
                        ),
                      ),
                    );
                },
                separatorBuilder: (ctx , index)=> SizedBox(width: 10.w,) ,
                itemCount: controller.homeModel.value.product!.length
            )
                :
            SizedBox()

            ,
          ),

        ],
      ),
    );
  }

  buildRecommendedScroll(context){
    return Container(
      color: Colors.white,
      child: Padding(

        padding:  EdgeInsets.only(left: 15.w),
        child:   Column(
          children: [
            Row(
              children: [
                Text("RECOMMENDED",
                  style: boldTextStyle(
                      weight: FontWeight.w400,
                      size: 20.sp.round(),
                      color: Colors.black

                  ),

                ),
                Spacer(),
                Text("SHOW ALL",

                  style: boldTextStyle(
                      weight: FontWeight.w400,
                      size: 20.sp.round(),
                      color: Color(0xff9B9B9B)

                  ),
                ),
                SizedBox(width: 15.w,)
              ],
            ),
            SizedBox(height: 5.h,),
            Container(
              height: 65.h,
              width: MediaQuery.of(context).size.width,

              child:
              controller.isHomeLoading.value ?
              ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx , index){


                    return

                      LoadingWidget(
                        SizedBox(
                          width: 215.w,
                          height: 65.h,
                          child: Container(

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.sp),
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1)

                            ),



                          ),
                        ),
                      );

                  },
                  separatorBuilder: (ctx , index)=> SizedBox(width: 10.w,) ,
                  itemCount: 4
              )
                  :

              controller.homeModel.value.product != null ?

              ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx , index){


                    return

                      Container(
                        width: 215.w,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.sp),


                        ),
                        child:
                        controller.homeModel.value.product![index].image != null ?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            controller.homeModel.value.product![index].image!.isEmpty?
                            Container(

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.w)
                                ),

                                child: Image.asset("assets/images/placeholder.png",
                                  width: 215.w,
                                  height: 65.h,
                                )
                            )

                                :
                            Expanded(

                              flex: 2,

                              child: Container(

                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),

                                child: CachedNetworkImage(
                                  imageUrl:

                                  controller.homeModel.value.product![index].image! ,
fit: BoxFit.fitWidth,
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 30.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(

                                      image: DecorationImage(
                                          image: imageProvider, fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    
                                  ),

                                  width: 35.w,
                                  placeholder: (ctx , v){
                                    return Image.asset("assets/images/placeholder.png",
                                      width: 85.w,

                                    );
                                  },

                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffF9F5FF),
borderRadius: BorderRadius.circular(10.sp)

                                ),
                                child: Column(

                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    SizedBox(height: 5.h,),
                                    Text(controller.homeModel.value.product![index].name!,
                                      style: primaryTextStyle(
                                          size: 12.sp.round(),
                                          weight: FontWeight.w500,
                                          color: Color(0xff9B9B9B)

                                      ),

                                    ),
                                    SizedBox(height: 5.h,),
                                    Text(
                                      "\$ ${controller.homeModel.value.product![index].price!} ",
                                      style: primaryTextStyle(
                                          size: 16.sp.round(),
                                          weight: FontWeight.w700,
                                          color: Colors.black

                                      ),

                                    ),
                                    SizedBox(height: 5.h,),
                                  ],
                                ),
                              ),
                            ),


                          ],
                        )
                            :
                        Image.asset("assets/images/placeholder.png",
                          width: 200.w,
                          height: 200.h,
                        ),
                      );
                  },
                  separatorBuilder: (ctx , index)=> SizedBox(width: 10.w,) ,
                  itemCount: controller.homeModel.value.product!.length
              )
                  :
              SizedBox()

              ,
            ),
            SizedBox(height: 15.h,),
          ],
        ),
      ),
    );
  }



  buildCatScroll(context){
    List<Categories> myCatList = [];
    Categories allItemCategory = Categories(
        name: "All Items",
        slug: "",
        image: "",
        id: 00
    );
    // List<Categories>? catFromApi = controller.homeModel.value.categories;
    if(controller.homeModel.value.categories != null){

      myCatList.add(allItemCategory);
      for(var cat in controller.homeModel.value.categories!){
        myCatList.add(cat);
      }


    }

    return Padding(
      padding:  EdgeInsets.only(left: 15.w),
      child: Container(
        height: 40.h,

        child:
      controller.isHomeLoading.value ?
      ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx , index){


        return

          LoadingWidget(
            SizedBox(
              width: 100.w,
              child: Container(

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.sp),
                    border: Border.all(
                        color: Colors.grey,
                        width: 1)

                ),



              ),
            ),
          );

      },
      separatorBuilder: (ctx , index)=> SizedBox(width: 10.w,) ,
      itemCount: 4
      )
      :

        controller.homeModel.value.categories != null ?

        ListView.separated(
          scrollDirection: Axis.horizontal,
            itemBuilder: (ctx , index){


             return GestureDetector(
               onTap: (){
CustomSearchController customSearchController = CustomSearchController();
Get.put<CustomSearchController>(CustomSearchController());


                 Get.to(()=> ResultView());
               },
               child: SizedBox(
                  child: Container(

                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.sp),
                        border: Border.all(
                            color: Colors.grey,
                            width: 1)

                    ),
                    child:
                    myCatList[index].image != null ?
                    Row(
                      children: [
                        const SizedBox(width: 10,),
                        myCatList[index].image!.isEmpty?
                        SvgPicture.asset("assets/images/home/cat_icon.svg")
                        :
                        CachedNetworkImage(
                          imageUrl:

                          myCatList[index].image! ,
                          width: 50.w,
                          height: 15.h,
                          placeholder: (ctx , v){
                            return Image.asset("assets/images/placeholder.png",
                              width: 50.w,
                              height: 15.h,
                            );
                          },

                        ),
                        const SizedBox(width: 5,),
                        Text(myCatList[index].name!),
                        const SizedBox(width: 10,),
                      ],
                    )
                        :
                    Row(
                      children: [

                        const SizedBox(width: 10,),


                        SvgPicture.asset("assets/images/home/cat_icon.svg"),

                        const SizedBox(width: 5,),
                        Text(myCatList[index].name!),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
             );
            },
            separatorBuilder: (ctx , index)=> SizedBox(width: 10.w,) ,
            itemCount: myCatList!.length
        )
        :
            SizedBox()

        ,
      ),
    );
  }
  buildUpperBar(context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: 65.h,

      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(

            width: 150.w,
            height: 190.h,

            child: SvgPicture.asset("assets/images/logo.svg",
              width: 150.w,
              height:  65.h,
              fit: BoxFit.fitHeight,

            ),
          ),
          Spacer(),
          Container(
            height: 39.h,
            width: 90.w,

            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.53, -0.85),
                end: Alignment(0.53, 0.85),
                colors: [Color(0xFF7A59A5), Color(0xFFA962FF), Color(0xFFBA80FF)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.85),
              ),
            ),
            child: Row(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/home/medal.svg",
                  height: 25.h,
                  width: 25.w,
                  fit: BoxFit.cover,

                ),
                const SizedBox(width: 4),
                Text(
                    '85pts',
                    textAlign: TextAlign.center,
                    style:
                    primaryTextStyle(
                      color: Colors.white,
                      size: 15.sp.round(),
                      height: 0.08,
                      weight: FontWeight.w700,
                    )

                ),
              ],
            ),
          ),
          SizedBox(width: 15.w,)
        ],
      ),
    );
  }

  buildSearchAndFilter(context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: 65.h,

      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 15.w,),
          Flexible(
            flex: 12,
            child: Container(



              child: TextField(
readOnly: true,
onTap: (){
  Get.toNamed( Routes.SEARCH, arguments: [
    controller.homeModel.value.product,
    controller.homeModel.value.categories
  ]);
  // Get.toNamed(()=> Pages., arguments: controller.homeModel.value.product);
},



                style: primaryTextStyle(
                  color: Colors.black,
                  size: 14.sp.round(),
                  weight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey , width: 2)
                  ),
                  hintStyle: primaryTextStyle(
                    color: Colors.black,
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                    height: 1,
                  ),
                  errorStyle: primaryTextStyle(
                    color: Colors.red,
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                    height: 1,
                  ),
                  labelStyle: primaryTextStyle(
                    color: Colors.grey,
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                    height: 1,
                  ),

                  labelText: "Search Clothes ...",
prefixIcon: IconButton(
  icon: SvgPicture.asset(

    'assets/icons/search.svg'
    ,
    width:  25.w,
    height:  25.h,
  ),
  onPressed: () {

  },
),
                  suffixIcon:  IconButton(
                    icon: SvgPicture.asset(

                      'assets/icons/camera.svg'
                      ,
                      width:  25.w,
                      height:  25.h,
                    ),
                    onPressed: () {

                    },
                  )
                  ,
                ),
              ),
            ),
          ),
          Spacer(),
          Container(



            child: SvgPicture.asset("assets/images/home/Filter.svg",
              height: 50.h,
              width: 50.w,
              fit: BoxFit.cover,

            ),
          ),
          SizedBox(width: 15.w,)
        ],
      ),
    );
  }
}

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key, required this.scrollController});
final ScrollController scrollController;
  @override
  State<CustomNavBar> createState() => _CustomNavBarState();

}


class _CustomNavBarState extends State<CustomNavBar> {


  int index  = 0;
  @override
  Widget build(BuildContext context) {
    return
      widget.scrollController.hasClients ?
      AnimatedBuilder(

      animation: widget.scrollController,

      builder: (BuildContext context, Widget? child) {
        return AnimatedContainer(


          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),


          ),

          duration: const Duration(milliseconds: 400),
          height: widget.scrollController.position.userScrollDirection ==
              ScrollDirection.reverse
              ? 0
              : 95.h,
          child: child,
        );
      },
      child: Container(

        height: 95.h,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
          color: Colors.transparent
        ),
        child:ClipRRect(

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: Color(0xFFB9B9B9),
            selectedItemColor: Color(0xFF53178C),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (i){
              index = i;
              setState(() {

              });

            },
            currentIndex: index,

            unselectedLabelStyle: primaryTextStyle(
              color: index==0 ? Colors.purple : Color(0xFFB9B9B9),
              size: 10.sp.round(),
              weight: FontWeight.w700,
              height: 0,

            ),
            selectedLabelStyle:
            primaryTextStyle(
              color: Color(0xFF53178C),
              size: 10.sp.round(),
              weight: FontWeight.w700,
              height: 0,

            ),

            elevation: 5,
            items: [
              //Home
              BottomNavigationBarItem(
                  icon:  index == 0 ?


                  Container(

                      height: 70.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffE8DEF8),
                        borderRadius: BorderRadius.circular(30.sp),

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(

                            "assets/icons/home_active.svg",

                            height: 30.h,




                          ),
                          SizedBox(height: 3.h,),
                          Text("Home" ,
                              style:
                              primaryTextStyle(
                                weight: FontWeight.w700,
                                size: 8.sp.round(),

                              )
                          )

                        ],
                      )
                  )
                      :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(

                        "assets/icons/home.svg",
                        height: 30.h,




                      ),
                      SizedBox(height: 3.h,),
                      Text("Home" ,
                          style:
                          primaryTextStyle(
                              weight: FontWeight.w700,
                              size: 8.sp.round(),
                              color: Colors.grey

                          )
                      )

                    ],
                  )
                  ,
                  label:'Home'




              ),
              //Shop
              BottomNavigationBarItem(
                  icon: index ==1 ?

                  Container(

                      height: 70.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffE8DEF8),
                        borderRadius: BorderRadius.circular(30.sp),

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(

                            "assets/icons/shop_active.svg"
                            ,

                            height: 30.h,




                          ),
                          SizedBox(height: 3.h,),
                          Text("Shop" ,
                              style:
                              primaryTextStyle(
                                weight: FontWeight.w700,
                                size: 8.sp.round(),

                              )
                          )

                        ],
                      )
                  )
                      :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(

                        "assets/icons/shop.svg",
                        height: 30.h,




                      ),
                      SizedBox(height: 3.h,),
                      Text("Shop" ,
                          style:
                          primaryTextStyle(
                              weight: FontWeight.w700,
                              size: 8.sp.round(),
                              color: Colors.grey

                          )
                      )

                    ],
                  )
                  ,
                  label:'Shop'




              ),
              //Bag
              BottomNavigationBarItem(
                  icon: index ==2 ?

                  Container(

                      height: 70.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffE8DEF8),
                        borderRadius: BorderRadius.circular(30.sp),

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(

                            "assets/icons/bag_active.svg",
                            height: 30.h,




                          ),
                          SizedBox(height: 3.h,),
                          Text("Bag" ,
                              style:
                              primaryTextStyle(
                                weight: FontWeight.w700,
                                size: 8.sp.round(),

                              )
                          )

                        ],
                      )
                  )
                      :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(

                        "assets/icons/bag.svg",
                        height: 30.h,




                      ),
                      SizedBox(height: 3.h,),
                      Text("Bag" ,
                          style:
                          primaryTextStyle(
                              weight: FontWeight.w700,
                              size: 8.sp.round(),
                              color: Colors.grey

                          )
                      )

                    ],
                  )
                  ,
                  label:'Bag'




              ),
              //Wishlist
              BottomNavigationBarItem(
                  icon: index ==3 ?

                  Container(

                      height: 70.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffE8DEF8),
                        borderRadius: BorderRadius.circular(30.sp),

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(

                            "assets/icons/wishlist_active.svg",
                            height: 30.h,




                          ),
                          SizedBox(height: 3.h,),
                          Text("Wishlist" ,
                              style:
                              primaryTextStyle(
                                  weight: FontWeight.w700,
                                  size: 8.sp.round(),
                                  color: Color(0xff5C2493)

                              )
                          )

                        ],
                      )
                  )
                      :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(

                        "assets/icons/wishlist.svg",
                        height: 30.h,




                      ),
                      SizedBox(height: 3.h,),
                      Text("Wishlist" ,
                          style:
                          primaryTextStyle(
                              weight: FontWeight.w700,
                              size: 8.sp.round(),
                              color: Colors.grey

                          )
                      )

                    ],
                  )
                  ,
                  label:'Wishlist'




              ),
              //Profile
              BottomNavigationBarItem(
                  icon: index ==4 ?

                  Container(

                      height: 70.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffE8DEF8),
                        borderRadius: BorderRadius.circular(30.sp),

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(

                            "assets/icons/profile_active.svg",
                            height: 30.h,




                          ),
                          SizedBox(height: 3.h,),
                          Text("Profile" ,
                              style:
                              primaryTextStyle(
                                weight: FontWeight.w700,
                                size: 8.sp.round(),

                              )
                          )

                        ],
                      )
                  )
                      :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(

                        "assets/icons/profile.svg",
                        height: 30.h,




                      ),
                      SizedBox(height: 3.h,),
                      Text("Profile" ,
                          style:
                          primaryTextStyle(
                              weight: FontWeight.w700,
                              size: 8.sp.round(),
                              color: Colors.grey

                          )
                      )

                    ],
                  )
                  ,
                  label:'Profile'




              ),
            ],
          ),
        ),
      ),
    )
          :
          SizedBox();
  }
}

