#!/bin/bash

echo "Applying migration MarkPageFive"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /markPageFive                       controllers.MarkPageFiveController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /markPageFive                       controllers.MarkPageFiveController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeMarkPageFive                       controllers.MarkPageFiveController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeMarkPageFive                       controllers.MarkPageFiveController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "markPageFive.title = markPageFive" >> ../conf/messages.en
echo "markPageFive.heading = markPageFive" >> ../conf/messages.en
echo "markPageFive.field1 = Field 1" >> ../conf/messages.en
echo "markPageFive.field2 = Field 2" >> ../conf/messages.en
echo "markPageFive.checkYourAnswersLabel = markPageFive" >> ../conf/messages.en
echo "markPageFive.error.field1.required = Enter field1" >> ../conf/messages.en
echo "markPageFive.error.field2.required = Enter field2" >> ../conf/messages.en
echo "markPageFive.error.field1.length = field1 must be 67 characters or less" >> ../conf/messages.en
echo "markPageFive.error.field2.length = field2 must be 12 characters or less" >> ../conf/messages.en

echo "Adding helper line into UserAnswers"
awk '/class/ {\
     print;\
     print "  def markPageFive: Option[MarkPageFive] = cacheMap.getEntry[MarkPageFive](MarkPageFiveId.toString)";\
     print "";\
     next }1' ../app/utils/UserAnswers.scala > tmp && mv tmp ../app/utils/UserAnswers.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def markPageFive: Option[AnswerRow] = userAnswers.markPageFive map {";\
     print "    x => AnswerRow(\"markPageFive.checkYourAnswersLabel\", s\"${x.field1} ${x.field2}\", false, routes.MarkPageFiveController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Moving test files from generated-test/ to test/"
rsync -avm --include='*.scala' -f 'hide,! */' ../generated-test/ ../test/
rm -rf ../generated-test/

echo "Migration MarkPageFive completed"
