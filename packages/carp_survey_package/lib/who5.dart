part of survey;

/// A task representing the
/// [WHO-5 well-being index](https://www.psykiatri-regionh.dk/who-5/Pages/default.aspx).
RPOrderedTask who5Task = RPOrderedTask("who5TaskID", [
  _who5Question1,
  _who5Question2,
  _who5Question3,
  _who5Question4,
  _who5Question5,
  _completionStep,
]);

List<RPChoice> _who5Choices = [
  RPChoice.withParams("All of the time", 5),
  RPChoice.withParams("Most of the time", 4),
  RPChoice.withParams("More than half of the time", 3),
  RPChoice.withParams("Less than half of the time", 2),
  RPChoice.withParams("Some of the time", 1),
  RPChoice.withParams("At no time", 0),
];

RPChoiceAnswerFormat _choiceAnswerFormat = RPChoiceAnswerFormat.withParams(
    ChoiceAnswerStyle.SingleChoice, _who5Choices);

RPQuestionStep _who5Question1 = RPQuestionStep.withAnswerFormat(
  "who5_question1",
  "I have felt cheerful and in good spirits",
  _choiceAnswerFormat,
);

RPQuestionStep _who5Question2 = RPQuestionStep.withAnswerFormat(
  "who5_question2",
  "I have felt calm and relaxed",
  _choiceAnswerFormat,
);

RPQuestionStep _who5Question3 = RPQuestionStep.withAnswerFormat(
  "who5_question3",
  "I have felt active and vigorous",
  _choiceAnswerFormat,
);

RPQuestionStep _who5Question4 = RPQuestionStep.withAnswerFormat(
  "who5_question4",
  "I woke up feeling fresh and rested",
  _choiceAnswerFormat,
);

RPQuestionStep _who5Question5 = RPQuestionStep.withAnswerFormat(
  "who5_question5",
  "My daily life has been filled with things that interest me",
  _choiceAnswerFormat,
);

RPCompletionStep _completionStep = RPCompletionStep("completionID")
  ..title = "Finished"
  ..text = "Thank you for filling out the survey!";
