#!/bin/bash

echo "Applying migration MarkPageThree"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /markPageThree               controllers.MarkPageThreeController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /markPageThree               controllers.MarkPageThreeController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeMarkPageThree               controllers.MarkPageThreeController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeMarkPageThree               controllers.MarkPageThreeController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "markPageThree.title = markPageThree" >> ../conf/messages.en
echo "markPageThree.heading = markPageThree" >> ../conf/messages.en
echo "markPageThree.option1 = Option 1" >> ../conf/messages.en
echo "markPageThree.option2 = Option 2" >> ../conf/messages.en
echo "markPageThree.checkYourAnswersLabel = markPageThree" >> ../conf/messages.en
echo "markPageThree.error.required = Please give an answer for markPageThree" >> ../conf/messages.en

echo "Adding helper line into UserAnswers"
awk '/class/ {\
     print;\
     print "  def markPageThree: Option[MarkPageThree] = cacheMap.getEntry[MarkPageThree](MarkPageThreeId.toString)";\
     print "";\
     next }1' ../app/utils/UserAnswers.scala > tmp && mv tmp ../app/utils/UserAnswers.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def markPageThree: Option[AnswerRow] = userAnswers.markPageThree map {";\
     print "    x => AnswerRow(\"markPageThree.checkYourAnswersLabel\", s\"markPageThree.$x\", true, routes.MarkPageThreeController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Moving test files from generated-test/ to test/"
rsync -avm --include='*.scala' -f 'hide,! */' ../generated-test/ ../test/
rm -rf ../generated-test/

echo "Migration MarkPageThree completed"
