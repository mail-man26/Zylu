import 'dart:async';

import 'package:fb/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadListview extends StatefulWidget {
  const ReadListview({super.key});

  @override
  State<ReadListview> createState() => _ReadListviewState();
}

class _ReadListviewState extends State<ReadListview> {
  late final PageController pageController;
  int pageNo = 0;

  late final Timer carasouelTimer;

  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageNo == 3) {
        pageNo = 0;
      }
      pageController.animateToPage(pageNo,
          duration: const Duration(seconds: 1), curve: Curves.easeInOutCirc);
      pageNo++;
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.80);
    carasouelTimer = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  elevation: 5,
                  color: Colors.blueAccent,
                  child: SizedBox(
                    width: 400,
                    height: 100,
                    child: Center(
                        child: Text(
                      'My Assignment for Zylu Business Solutions',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400),
                    )),
                  )),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    pageNo = index;
                    setState(() {});
                  },
                  itemBuilder: (_, index) {
                    if (pageNo == 0) {
                      primary = Styles.bgColor3;
                      elementary = Styles.text1;
                    } else if (pageNo == 1) {
                      primary = Styles.bgColor2;
                      elementary = Styles.text2;
                    } else {
                      primary = Styles.bgColor1;
                      elementary = Styles.text3;
                    }

                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (ctx, child) {
                        return child!;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            right: 8, left: 8, top: 36, bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: primary,
                        ),
                        child: Center(
                            child: TextButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.nature_rounded),
                                label: elementary)),
                      ),
                    );
                  },
                  itemCount: 3,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      3,
                      (index) => Container(
                            margin: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.circle,
                              size: 12,
                              color: pageNo == index
                                  ? Colors.black
                                  : Colors.blueGrey,
                            ),
                          ))),
              const Padding(
                padding: EdgeInsets.all(24),
                child: ListCars(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListCars extends StatefulWidget {
  const ListCars({super.key});

  @override
  State<ListCars> createState() => _ListCarsState();
}

class _ListCarsState extends State<ListCars> {
  final _carStream = FirebaseFirestore.instance.collection('Cars').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _carStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Connection error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading....');
        }

        var docs = snapshot.data!.docs;

        //return Text('${docs.length}');
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 320,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            if (docs[index]['Mileage'] >= 15 && docs[index]['Age'] <= 5) {
              primary = Styles.bgColor3;
            } else if (docs[index]['Mileage'] >= 15 && docs[index]['Age'] > 5) {
              primary = Styles.bgColor2;
            } else {
              primary = Styles.bgColor1;
            }

            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      child: Image.network(
                        docs[index]['url'],
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          docs[index]['Name'],
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .merge(const TextStyle(
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_gas_station,
                            ),
                            Text(
                              ' : ${docs[index]['Mileage']}km/hr',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .merge(const TextStyle(
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.timelapse),
                            Text(
                              ' : ${docs[index]['Age']}years old',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .merge(const TextStyle(
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
