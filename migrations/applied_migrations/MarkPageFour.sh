#!/bin/bash

echo "Applying migration MarkPageFour"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /markPageFour               controllers.MarkPageFourController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /markPageFour               controllers.MarkPageFourController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeMarkPageFour                        controllers.MarkPageFourController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeMarkPageFour                        controllers.MarkPageFourController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "markPageFour.title = markPageFour" >> ../conf/messages.en
echo "markPageFour.heading = markPageFour" >> ../conf/messages.en
echo "markPageFour.checkYourAnswersLabel = markPageFour" >> ../conf/messages.en
echo "markPageFour.error.nonNumeric = Please give an answer for markPageFour using numbers" >> ../conf/messages.en
echo "markPageFour.error.required = Please give an answer for markPageFour" >> ../conf/messages.en
echo "markPageFour.error.wholeNumber = Please give an answer for markPageFour using whole numbers" >> ../conf/messages.en
echo "markPageFour.error.outOfRange = markPageFour must be between {0} and {1}" >> ../conf/messages.en

echo "Adding helper line into UserAnswers"
awk '/class/ {\
     print;\
     print "  def markPageFour: Option[Int] = cacheMap.getEntry[Int](MarkPageFourId.toString)";\
     print "";\
     next }1' ../app/utils/UserAnswers.scala > tmp && mv tmp ../app/utils/UserAnswers.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def markPageFour: Option[AnswerRow] = userAnswers.markPageFour map {";\
     print "    x => AnswerRow(\"markPageFour.checkYourAnswersLabel\", s\"$x\", false, routes.MarkPageFourController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Moving test files from generated-test/ to test/"
rsync -avm --include='*.scala' -f 'hide,! */' ../generated-test/ ../test/
rm -rf ../generated-test/

echo "Migration MarkPageFour completed"
