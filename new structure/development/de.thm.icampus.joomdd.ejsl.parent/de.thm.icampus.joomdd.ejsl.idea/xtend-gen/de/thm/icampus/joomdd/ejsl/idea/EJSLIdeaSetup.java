/**
 * generated by iCampus (JooMDD team) 2.9.1
 */
package de.thm.icampus.joomdd.ejsl.idea;

import com.google.inject.Injector;
import de.thm.icampus.joomdd.ejsl.idea.EJSLStandaloneSetupIdea;
import org.eclipse.xtext.ISetup;
import org.eclipse.xtext.idea.extensions.EcoreGlobalRegistries;

@SuppressWarnings("all")
public class EJSLIdeaSetup implements ISetup {
  @Override
  public Injector createInjectorAndDoEMFRegistration() {
    Injector _xblockexpression = null;
    {
      EcoreGlobalRegistries.ensureInitialized();
      EJSLStandaloneSetupIdea _eJSLStandaloneSetupIdea = new EJSLStandaloneSetupIdea();
      _xblockexpression = _eJSLStandaloneSetupIdea.createInjector();
    }
    return _xblockexpression;
  }
}