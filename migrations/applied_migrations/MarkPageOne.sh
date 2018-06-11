#!/bin/bash

echo "Applying migration MarkPageOne"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /markPageOne               controllers.MarkPageOneController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /markPageOne               controllers.MarkPageOneController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeMarkPageOne                        controllers.MarkPageOneController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeMarkPageOne                        controllers.MarkPageOneController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "markPageOne.title = markPageOne" >> ../conf/messages.en
echo "markPageOne.heading = markPageOne" >> ../conf/messages.en
echo "markPageOne.checkYourAnswersLabel = markPageOne" >> ../conf/messages.en
echo "markPageOne.error.required = Enter markPageOne" >> ../conf/messages.en
echo "markPageOne.error.length = MarkPageOne must be 30 characters or less" >> ../conf/messages.en

echo "Adding helper line into UserAnswers"
awk '/class/ {\
     print;\
     print "  def markPageOne: Option[String] = cacheMap.getEntry[String](MarkPageOneId.toString)";\
     print "";\
     next }1' ../app/utils/UserAnswers.scala > tmp && mv tmp ../app/utils/UserAnswers.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def markPageOne: Option[AnswerRow] = userAnswers.markPageOne map {";\
     print "    x => AnswerRow(\"markPageOne.checkYourAnswersLabel\", s\"$x\", false, routes.MarkPageOneController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Moving test files from generated-test/ to test/"
rsync -avm --include='*.scala' -f 'hide,! */' ../generated-test/ ../test/
rm -rf ../generated-test/

echo "Migration MarkPageOne completed"
