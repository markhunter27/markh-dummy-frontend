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

package views

import play.api.data.Form
import controllers.routes
import forms.MarkPageOneFormProvider
import models.NormalMode
import views.behaviours.StringViewBehaviours
import views.html.markPageOne

class MarkPageOneViewSpec extends StringViewBehaviours {

  val messageKeyPrefix = "markPageOne"

  val form = new MarkPageOneFormProvider()()

  def createView = () => markPageOne(frontendAppConfig, form, NormalMode)(fakeRequest, messages)

  def createViewUsingForm = (form: Form[String]) => markPageOne(frontendAppConfig, form, NormalMode)(fakeRequest, messages)

  "MarkPageOne view" must {
    behave like normalPage(createView, messageKeyPrefix)

    behave like pageWithBackLink(createView)

    behave like stringPage(createViewUsingForm, messageKeyPrefix, routes.MarkPageOneController.onSubmit(NormalMode).url)
  }
}
