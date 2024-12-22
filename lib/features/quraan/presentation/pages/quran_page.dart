import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';
import 'package:fourtyninehub/features/quraan/presentation/pages/quran_details.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  void initState() {
    super.initState();
    // Fetch surah data when the page loads
    //  context.read<QuranCubit>().fetchSurah(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1EEE5),
      appBar: AppBar(
        title: const Text("Quran Page"),
      ),
      body: BlocProvider<QuranCubit>(
        create: (BuildContext context) => serviceLocator()..fetchQuranSurah(),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state.status == QuranStates.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == QuranStates.success) {
              return ListView.builder(
                itemCount: state.quranSurah?.length,
                itemBuilder: (context, index) {
                  var surah = state.quranSurah![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuranViewPage(
                            surahId: state.quranSurah![index].surahNo,
                            pageNumber: 1,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(surah.surahNameAr),
                      subtitle: Text('Surah number: ${surah.surahNo}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuranViewPage(
                              surahId: state.quranSurah![index].surahNo,
                              pageNumber: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
