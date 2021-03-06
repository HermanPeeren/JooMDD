package de.thm.icampus.joomdd.ejsl.generator.ps.joomla4

import de.thm.icampus.joomdd.ejsl.eJSL.ContextLink
import de.thm.icampus.joomdd.ejsl.eJSL.ExternalLink
import de.thm.icampus.joomdd.ejsl.eJSL.InternalLink
import de.thm.icampus.joomdd.ejsl.eJSL.Link
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla4.JoomlaPageGenerator.ExternalLinkGenerator
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla4.JoomlaPageGenerator.InternalLinkGenerator
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla4.JoomlaPageGenerator.ContextLinkGenerator

/**
 * This class represents the interface between the JooMDD generator and the Joomla-specific link generator templates. 
 * 
 * @author Dennis Priefer, Dieudonne Timma Meyatchie
 */
public class LinkGeneratorHandler {

    Link link
    String sect = ''
    String compname
    String valueF
    String currentAttributeName = ''''''

    new(Link link, String section, String componentname, String vaLueFeatures) {
        newInstance(link, section, componentname, vaLueFeatures, '''''')
    }

    new(Link link, String section, String componentname, String vaLueFeatures, String currentAttributeName) {
        newInstance(link, section, componentname, vaLueFeatures, currentAttributeName)
    }

    private def newInstance(Link link, String section, String componentname, String vaLueFeatures, String currentAttributeName) {
        this.link = link
        this.currentAttributeName = currentAttributeName
        
        if (section.equalsIgnoreCase('BackendSection')) {
            sect = section            
        }
        
        compname = componentname
        valueF = vaLueFeatures
    }

    new(Link link) {
        this.link = link
    }

    public def CharSequence generateLink() {
        switch link {
            ExternalLink: {
                var ExternalLinkGenerator extern = new ExternalLinkGenerator(link)
                return extern.generateLink(sect, compname)
            }
            InternalLink: {
                if (link instanceof ContextLink) {
                    var ContextLinkGenerator intern = new ContextLinkGenerator(link, valueF, currentAttributeName)
                    return intern.generateLink(sect, compname)
                } else {
                    var InternalLinkGenerator intern = new InternalLinkGenerator(link)
                    return intern.generateLink(sect, compname)
                }
            }
        }
        return "//to do it is empty !"
    }

}
