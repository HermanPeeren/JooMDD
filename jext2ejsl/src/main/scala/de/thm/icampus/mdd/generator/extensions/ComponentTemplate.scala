package de.thm.icampus.mdd.generator.extensions

import de.thm.icampus.mdd.model.extensions.{ComponentExtension, Page}
import de.thm.icampus.mdd.generator.basic.BasicTemplate

/**
  * Created by tobias on 26.05.17.
  */
trait ComponentTemplate extends BasicTemplate with ManifestTemplate with LanguageTemplate {

  def componentPartial(component: ComponentExtension, newline: Boolean = true, indent: Int = 0) = {
    toTemplate(
      s"""
         |Component ${component.name} {
         |    ${manifestPartial(component.manifest, newline = false, indent = 1)}
         |    languages ${rep(/*component.languages*/List(), languagePartial)}
         |    sections {
         |        FrontendSection {
         |            *Pages ${rep(component.frontend.pages, shortPagePartial, sep="\n", indent=3)}
         |        }
         |        BackendSection {
         |            *Pages ${rep(component.backend.pages, shortPagePartial, sep="\n", indent=3)}
         |        }
         |    }
         |}""", newline, indent)
  }

  private def shortPagePartial(page: Page, newline: Boolean = true, indent: Int = 0) = {
    toTemplate(
      s"""
         |*Page : ${page.name}""", newline, indent)
  }
}
