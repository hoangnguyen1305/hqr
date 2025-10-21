part of '../result_plate_page.dart';

class ResultPlate extends StatefulWidget {
  const ResultPlate({super.key});

  @override
  State<ResultPlate> createState() => _ResultPlateState();
}

class _ResultPlateState extends State<ResultPlate> {
  late final ResultPlateBloc _bloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ResultPlateBloc>();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_bloc.isLoadingMore) {
        _bloc.add(OnLoadMore());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultPlateBloc, ResultPlateState>(
      buildWhen:
          (pre, cur) =>
              pre.plates != cur.plates ||
              pre.hasReachedMax != cur.hasReachedMax ||
              pre.screenState != cur.screenState,
      builder: (ctx, state) {
        if (state.screenState.isLoading) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorRes.primaryColor,
                ),
                strokeWidth: 3,
              ),
            ),
          );
        }

        if (state.plates.isEmpty) {
          return Center(child: CText(text: 'Không có dữ liệu'));
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          controller: _scrollController,
          itemCount:
              state.hasReachedMax
                  ? state.plates.length
                  : state.plates.length + 1,
          separatorBuilder:
              (ctx, index) => const SizedBox(height: ConstRes.defaultVertical),
          itemBuilder: (ctx, index) {
            if (index >= state.plates.length) {
              return Center(
                child: const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorRes.primaryColor,
                    ),
                    strokeWidth: 3,
                  ),
                ),
              );
            }
            return _buildPlateItem(state.plates[index]);
          },
        );
      },
    );
  }

  Widget _buildPlateItem(PlateModel plate) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorRes.grey, width: 1),
        color: ColorRes.backgroundWhiteColor,
        borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: ConstRes.defaultVertical,
        vertical: ConstRes.defaultVertical,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: plate.plateColor,
                      borderRadius: BorderRadius.circular(
                        ConstRes.defaultRadius,
                      ),
                      border: Border.all(color: ColorRes.grey, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: ConstRes.defaultHorizontal / 2,
                      vertical: ConstRes.defaultVertical / 2,
                    ),
                    child: CText(
                      text: _formatPlate(plate.fullNumber, isCar: plate.isCar),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: ConstRes.defaultHorizontal),
              Expanded(child: CText(text: plate.province.name, maxLines: 10)),
            ],
          ),
          const SizedBox(height: ConstRes.defaultVertical),
          Row(
            children: [
              Expanded(
                child: CText(
                  text:
                      'Giá trúng đấu giá:\n${CurrencyUtils.format(plate.auctionPrice)}',
                  maxLines: 10,
                ),
              ),
              const SizedBox(width: ConstRes.defaultHorizontal),
              Expanded(
                child: CText(
                  text:
                      'Thời gian đấu giá:\n${DateTimeUtils.getFullDateTime(DateTimeUtils.getDateTime(plate.auctionStartTime))}',
                  maxLines: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPlate(String plate, {bool isCar = false}) {
    final value = plate.replaceAll('-', '').replaceAll('.', '');
    if (isCar) {
      if (value.substring(3).length > 4) {
        return '${value.substring(0, 3)}-${value.substring(3, 6)}.${value.substring(6)}';
      } else {
        return '${value.substring(0, 3)}-${value.substring(3)}';
      }
    } else {
      if (value.substring(4).length > 4) {
        return '${value.substring(0, 4)}-${value.substring(4, 7)}.${value.substring(7)}';
      } else {
        return '${value.substring(0, 4)}-${value.substring(4)}';
      }
    }
  }
}
