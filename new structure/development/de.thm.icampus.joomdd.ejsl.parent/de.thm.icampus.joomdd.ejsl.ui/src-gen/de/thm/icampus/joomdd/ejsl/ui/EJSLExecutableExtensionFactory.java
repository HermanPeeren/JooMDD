/*
 * generated by iCampus (JooMDD team) 2.9.1
 */
package de.thm.icampus.joomdd.ejsl.ui;

import com.google.inject.Injector;
import de.thm.icampus.joomdd.ejsl.ui.internal.EjslActivator;
import org.eclipse.xtext.ui.guice.AbstractGuiceAwareExecutableExtensionFactory;
import org.osgi.framework.Bundle;

/**
 * This class was generated. Customizations should only happen in a newly
 * introduced subclass. 
 */
public class EJSLExecutableExtensionFactory extends AbstractGuiceAwareExecutableExtensionFactory {

	@Override
	protected Bundle getBundle() {
		return EjslActivator.getInstance().getBundle();
	}
	
	@Override
	protected Injector getInjector() {
		return EjslActivator.getInstance().getInjector(EjslActivator.DE_THM_ICAMPUS_JOOMDD_EJSL_EJSL);
	}
	
}