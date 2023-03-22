import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/bloc/toeic/toeic_part/toeic_part_cubit.dart';
import 'package:bke/presentation/pages/toeic_test/components/instruction_component.dart';
import 'package:bke/presentation/pages/toeic_test/toeic_do_test_page.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ToeicInstructionParam {
  final int part;
  final String title;
  final BuildContext context;
  final String imgUrl;
  ToeicInstructionParam({
    required this.part,
    required this.title,
    required this.imgUrl,
    required this.context,
  });
}

class ToeicInstructionPage extends StatefulWidget {
  const ToeicInstructionPage({
    super.key,
    required this.part,
    required this.title,
    required this.imgUrl,
  });
  final int part;
  final String title;
  final String imgUrl;

  @override
  State<ToeicInstructionPage> createState() => _ToeicInstructionPageState();
}

class _ToeicInstructionPageState extends State<ToeicInstructionPage> {
  int selectedValue = 1;
  @override
  void initState() {
    super.initState();
    context.read<ToeicPartCubit>().getPart(widget.part);
  }

  bool isReal = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              BkEAppBar(
                label: "Part ${widget.part}. ${widget.title}",
                onBackButtonPress: () => Navigator.pop(context),
              ),
              _buildMainUI(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainUI(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r))),
        child: Padding(
          padding: EdgeInsets.only(top: 20.r),
          child: Column(
            children: [
              _buildHeader(context),
              10.verticalSpace,
              InstructionComponent(
                instructionComponent: getdata(widget.part, data),
              ),
              20.verticalSpace,
              _buildOption(context),
              30.verticalSpace,
              _buildStartButton(context),
              40.verticalSpace,
              _buildLoadingIndicator(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          widget.imgUrl,
          width: 80.r,
          height: 80.r,
        ),
        20.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ToeicPartCubit, ToeicPartState>(
              builder: (context, state) {
                return Text("Số câu đã làm: ${state.total}",
                    style: AppTypography.body);
              },
            ),
            5.verticalSpace,
            BlocBuilder<ToeicPartCubit, ToeicPartState>(
              builder: (context, state) {
                return Text("Số câu chính xác: ${state.correct}",
                    style: AppTypography.body);
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return BlocBuilder<ToeicPartCubit, ToeicPartState>(
      builder: (context, state) {
        if (state.status == ToeicPartStatus.loading) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: SizedBox(
              height: 10.h,
              width: MediaQuery.of(context).size.width * 0.85,
              child: const LinearProgressIndicator(
                color: AppColor.primary,
              ),
            ),
          );
        } else {
          return 10.verticalSpace;
        }
      },
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return BlocBuilder<ToeicPartCubit, ToeicPartState>(
      builder: (context, state) {
        if (state.status == ToeicPartStatus.loading) {
          return QuizButton(
            width: MediaQuery.of(context).size.width * 0.85,
            backgroundColor: AppColor.lightGray,
            textColor: Colors.white,
            text: "Làm bài kiểm tra",
            onTap: null,
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuizButton(
                width: MediaQuery.of(context).size.width * 0.75,
                backgroundColor: AppColor.primary,
                textColor: Colors.white,
                text: "Làm bài kiểm tra",
                onTap: () {
                  context
                      .read<ToeicCubitPartOne>()
                      .getQuestions(widget.part, selectedValue);
                  if (state.status == ToeicPartStatus.done) {
                    Navigator.pushNamed(
                      context,
                      RouteName.toeicDoTest,
                      arguments: ToeicDoTestPageParam(
                        context: context,
                        isReal: isReal,
                        part: widget.part,
                        title: widget.title,
                      ),
                    ).then(
                      (value) => context
                          .read<ToeicPartCubit>()
                          .getDataFromLocal(widget.part),
                    );
                  }
                },
              ),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  activeColor: AppColor.primary,
                  value: isReal,
                  onChanged: (value) => setState(() => isReal = value!),
                ),
              )
            ],
          );
        }
      },
    );
  }

  Widget _buildOption(context) {
    List<int> items = List.generate(10, (index) => index + 1);
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Lựa chọn số câu hỏi",
            style: AppTypography.title,
          ),
          BkECustomDropdown(
            onSelected: (p0) {
              setState(() => selectedValue = p0);
            },
            items: items,
            textStyle: AppTypography.body,
          )
        ],
      ),
    );
  }

  InstructionData getdata(int part, List<InstructionData> list) {
    return list.firstWhere((element) => element.part == part);
  }
}

List<InstructionData> data = [
  InstructionData(
    {
      "eng":
          "You will have to answer 10 questions. For each question, a picture will be displayed in your exam booklet. You will listen to 4 phrases which will not be written in the booklet. You will have to choose the phrase that best matches up with the picture and write the answer down on your answer sheet.",
      "vie":
          "Bạn sẽ phải trả lời 10 câu hỏi. Đối với mỗi câu hỏi, một hình ảnh sẽ được hiển thị trong tập đề thi của bạn. Bạn sẽ nghe 4 cụm từ sẽ không được viết trong tập sách. Bạn sẽ phải chọn cụm từ phù hợp nhất với hình ảnh và viết câu trả lời vào phiếu trả lời của bạn.",
    },
    1,
  ),
  InstructionData(
    {
      "eng":
          "You will have to answer 30 questions. Each question contains a sentence (phrase or question) which is only spoken out loud. You will then listen to 3 suggested answers which will not be written in the booklet. You will have to choose the answer that best fits the phrase/question and write it down on your answer sheet.",
      "vie":
          "Bạn sẽ phải trả lời 30 câu hỏi. Mỗi câu hỏi chứa một câu (cụm từ hoặc câu hỏi) chỉ được đọc to. Sau đó, bạn sẽ nghe 3 câu trả lời gợi ý sẽ không được viết trong tập sách. Bạn sẽ phải chọn câu trả lời phù hợp nhất với cụm từ/câu hỏi và viết nó vào phiếu trả lời của bạn.",
    },
    2,
  ),
  InstructionData(
    {
      "eng":
          "You will listen to 10 conversations. These conversations are always between 2 people and are relatively short (2 to 5 interventions per person on average). You will then have to answer 3 questions, which will be both spoken out loud and written in your booklet. You will be offered 4 suggested answers (only written in your booklet). You will have to choose the answer that best fits the question and write it down on your answer sheet.",
      "vie":
          "Bạn sẽ nghe 10 đoạn hội thoại. Những cuộc trò chuyện này luôn diễn ra giữa 2 người và tương đối ngắn (trung bình 2 đến 5 can thiệp cho mỗi người). Sau đó, bạn sẽ phải trả lời 3 câu hỏi, những câu hỏi này sẽ được đọc to và viết trong tập sách của bạn. Bạn sẽ được cung cấp 4 câu trả lời gợi ý (chỉ được viết trong tập sách của bạn). Bạn sẽ phải chọn câu trả lời phù hợp nhất với câu hỏi và viết nó vào phiếu trả lời của bạn.",
    },
    3,
  ),
  InstructionData(
    {
      "eng":
          "You will listen to 10 speeches. These speeches are relatively short (less than a dozen sentences on average). Just like in Exercise 3, you will have to answer 3 questions, which will be both spoken out loud and written in your booklet. You will be offered 4 possible answers (only written on your booklet). You will have to choose the answer that best fits the question and write it down on your answer sheet.",
      "vie":
          "Bạn sẽ nghe 10 bài phát biểu. Những bài phát biểu này tương đối ngắn (trung bình dưới một chục câu). Cũng giống như trong Bài tập 3, bạn sẽ phải trả lời 3 câu hỏi, sẽ được nói to và viết trong tập sách của bạn. Bạn sẽ được cung cấp 4 câu trả lời có thể (chỉ được viết trên tập sách của bạn). Bạn sẽ phải chọn câu trả lời phù hợp nhất với câu hỏi và viết nó vào phiếu trả lời của bạn.",
    },
    4,
  ),
  InstructionData(
    {
      "eng":
          "In this TOEIC practice test there are 16 questions. For each question you will see an incomplete sentence. Four words or phrases, marked A-D are given beneath each sentence. You are to choose the one word or phrase that best completes the sentence.",
      "vie":
          "Trong bài thi thử TOEIC này có 16 câu hỏi. Đối với mỗi câu hỏi, bạn sẽ thấy một câu chưa hoàn chỉnh. Bốn từ hoặc cụm từ, được đánh dấu A-D được đưa ra bên dưới mỗi câu. Bạn phải chọn một từ hoặc cụm từ tốt nhất để hoàn thành câu.",
    },
    5,
  ),
  InstructionData(
    {
      "eng":
          "In Part 6 you will read four passages of text, such as an article, a letter, a form and an e-mail. In each reading passage there will be three blanks to fill in. You will read four possible choices for each blank. You should read the entire passage to make sure you choose the correct choice in context.",
      "vie":
          "Trong Phần 6, bạn sẽ đọc bốn đoạn văn bản, chẳng hạn như một bài báo, một bức thư, một biểu mẫu và một e-mail. Trong mỗi đoạn đọc sẽ có ba chỗ trống để điền vào. Bạn sẽ đọc bốn lựa chọn có thể cho mỗi chỗ trống. Bạn nên đọc toàn bộ đoạn văn để chắc chắn rằng bạn chọn lựa chọn đúng trong ngữ cảnh.",
    },
    6,
  ),
  InstructionData(
    {
      "eng":
          "In Part 7 you will read passages in the form of letters, ads, memos, faxes, schedules, etc. The reading section has a number of single passages and 4 double passages. You will be asked 2-4 questions about each single passage, and 5 questions for each double passage. Sometimes you will be asked for specific details. Other times you will be asked about what the passage implies. In the paired passages you will also be asked to make connections between the two related texts.",
      "vie":
          "Trong Phần 7, bạn sẽ đọc các đoạn dưới dạng thư, quảng cáo, ghi nhớ, fax, lịch trình, v.v. Phần đọc có một số đoạn đơn và 4 đoạn kép. Bạn sẽ được hỏi 2-4 câu hỏi về mỗi đoạn văn đơn và 5 câu hỏi cho mỗi đoạn văn kép. Đôi khi bạn sẽ được hỏi về các chi tiết cụ thể. Những lần khác, bạn sẽ được hỏi về ý nghĩa của đoạn văn. Trong các đoạn được ghép nối, bạn cũng sẽ được yêu cầu tạo kết nối giữa hai văn bản có liên quan.",
    },
    7,
  ),
];
