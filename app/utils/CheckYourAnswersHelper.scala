/*
 * Copyright 2018 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package utils

import controllers.routes
import models.CheckMode
import viewmodels.{AnswerRow, RepeaterAnswerRow, RepeaterAnswerSection}

class CheckYourAnswersHelper(userAnswers: UserAnswers) {

  def markPageTwo: Option[AnswerRow] = userAnswers.markPageTwo map {
    x => AnswerRow("markPageTwo.checkYourAnswersLabel", if(x) "site.yes" else "site.no", true, routes.MarkPageTwoController.onPageLoad(CheckMode).url)
  }

  def markPageThree: Option[AnswerRow] = userAnswers.markPageThree map {
    x => AnswerRow("markPageThree.checkYourAnswersLabel", s"markPageThree.$x", true, routes.MarkPageThreeController.onPageLoad(CheckMode).url)
  }

  def markPageFour: Option[AnswerRow] = userAnswers.markPageFour map {
    x => AnswerRow("markPageFour.checkYourAnswersLabel", s"$x", false, routes.MarkPageFourController.onPageLoad(CheckMode).url)
  }

  def markPageFive: Option[AnswerRow] = userAnswers.markPageFive map {
    x => AnswerRow("markPageFive.checkYourAnswersLabel", s"${x.field1} ${x.field2}", false, routes.MarkPageFiveController.onPageLoad(CheckMode).url)
  }

  def markPageOne: Option[AnswerRow] = userAnswers.markPageOne map {
    x => AnswerRow("markPageOne.checkYourAnswersLabel", s"$x", false, routes.MarkPageOneController.onPageLoad(CheckMode).url)
  }
}
