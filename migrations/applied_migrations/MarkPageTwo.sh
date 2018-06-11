#!/bin/bash

echo "Applying migration MarkPageTwo"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /markPageTwo                       controllers.MarkPageTwoController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /markPageTwo                       controllers.MarkPageTwoController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeMarkPageTwo                       controllers.MarkPageTwoController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeMarkPageTwo                       controllers.MarkPageTwoController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "markPageTwo.title = markPageTwo" >> ../conf/messages.en
echo "markPageTwo.heading = markPageTwo" >> ../conf/messages.en
echo "markPageTwo.checkYourAnswersLabel = markPageTwo" >> ../conf/messages.en
echo "markPageTwo.error.required = Please give an answer for markPageTwo" >> ../conf/messages.en

echo "Adding helper line into UserAnswers"
awk '/class/ {\
     print;\
     print "  def markPageTwo: Option[Boolean] = cacheMap.getEntry[Boolean](MarkPageTwoId.toString)";\
     print "";\
     next }1' ../app/utils/UserAnswers.scala > tmp && mv tmp ../app/utils/UserAnswers.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def markPageTwo: Option[AnswerRow] = userAnswers.markPageTwo map {";\
     print "    x => AnswerRow(\"markPageTwo.checkYourAnswersLabel\", if(x) \"site.yes\" else \"site.no\", true, routes.MarkPageTwoController.onPageLoad(CheckMode).url)"; print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Moving test files from generated-test/ to test/"
rsync -avm --include='*.scala' -f 'hide,! */' ../generated-test/ ../test/
rm -rf ../generated-test/

echo "Migration MarkPageTwo completed"
