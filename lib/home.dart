import 'package:flutter/material.dart';

class DementiaStages extends StatelessWidget {
  final List<String> stages = [
    "Normal Outward Behavior",
    "Very Mild Changes",
    "Mild Decline",
    "Moderate Decline",
    "Moderately Severe Decline",
    "Severe Decline",
    "Very Severe Decline"
  ];

  final List<String> symptoms = [
    "When your loved one is in this early phase, he won't have any symptoms that you can spot. Only a PET scan, an imaging test that shows how the brain is working, can reveal whether he's got Dementia. As he moves into the next 6 stages, your friend or relative with Dementia will see more and more changes in his thinking and reasoning.",
    "You still might not notice anything amiss in your loved one's behavior, but he may be picking up on small differences, things that even a doctor doesn't catch. This could include forgetting a word or misplacing objects. At this stage, subtle symptoms of Dementia don't interfere with his ability to work or live independently. Keep in mind that these symptoms might not be Dementia at all, but simply normal changes from aging.",
    "It's at this point that you start to notice changes in your loved one's thinking and reasoning, such as, Forgets something he just read, Asks the same question over and over, Has more and more trouble making plans or organizing, can't remember names when meeting new people.",
    "During this period, the problems in thinking and reasoning that you noticed in stage 3 get more obvious, and new issues appear. Your friend or family member might, Forget details about himself. Have trouble putting the right date and amount on a check, Forget what month or season it is, or Have trouble cooking meals or even ordering from a menu.",
    "Your loved one might start to lose track of where he is and what time it is. He might have trouble remembering his address, phone number, or where he went to school. He could get confused about what kind of clothes to wear for the day or season. You can help by laying out his clothing in the morning. It can help him dress by himself and keep a sense of independence. If he repeats the same question, answer with an even, reassuring voice. He might be asking the question less to get an answer and more to just know you're there.",
    "As Alzheimer's progresses, your loved one might recognize faces but forget names. He might also mistake a person for someone else, for instance, thinking his wife is his mother. Delusions might a set in, such as thinking he needs to go to work even though he no longer has a job. You might need to help him go to the bathroom. It might be hard to talk, but you can still connect with him through the senses. Many people with Alzheimer's love hearing music, being read to, or looking over old photos.",
    "Many basic abilities in a person with Alzheimer's, such as eating, walking, and sitting up, fade during this period. You can stay involved by feeding your loved one with soft, easy-to-swallow food, helping him use a spoon, and making sure he drinks. This is important, as many people at this stage can no longer tell when they're thirsty."
  ];

  @override
 @override
Widget build(BuildContext context) {
  return Scaffold(
    // appBar: AppBar(
    //   title: Text("Dementia Stages"),
    // ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:Center(child: Text(
            "7 Stages of Dementia and Alzheimer's",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),),
        ),  Padding(
          padding: const EdgeInsets.all(8.0),
          child:Center(child: Text(
            "Disease",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: stages.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionTile(
                title: Text(stages[index]),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(symptoms[index]),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}

}
