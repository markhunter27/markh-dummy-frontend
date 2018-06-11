#!/bin/bash

echo "Applying migration MarkPageSix"

echo "Adding routes to conf/app.routes"
echo "" >> ../conf/app.routes
echo "GET        /markPageSix                       controllers.MarkPageSixController.onPageLoad()" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "markPageSix.title = markPageSix" >> ../conf/messages.en
echo "markPageSix.heading = markPageSix" >> ../conf/messages.en

echo "Moving test files from generated-test/ to test/"
rsync -avm --include='*.scala' -f 'hide,! */' ../generated-test/ ../test/
rm -rf ../generated-test/

echo "Migration MarkPageSix completed"
