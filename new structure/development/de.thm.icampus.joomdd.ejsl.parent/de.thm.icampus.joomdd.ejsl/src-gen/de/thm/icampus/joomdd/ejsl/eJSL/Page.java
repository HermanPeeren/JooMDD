/**
 * generated by iCampus (JooMDD team) 2.9.1
 */
package de.thm.icampus.joomdd.ejsl.eJSL;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Page</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link de.thm.icampus.joomdd.ejsl.eJSL.Page#getName <em>Name</em>}</li>
 *   <li>{@link de.thm.icampus.joomdd.ejsl.eJSL.Page#getParametergroups <em>Parametergroups</em>}</li>
 *   <li>{@link de.thm.icampus.joomdd.ejsl.eJSL.Page#getGlobalparameters <em>Globalparameters</em>}</li>
 *   <li>{@link de.thm.icampus.joomdd.ejsl.eJSL.Page#getLocalparameters <em>Localparameters</em>}</li>
 *   <li>{@link de.thm.icampus.joomdd.ejsl.eJSL.Page#getLinks <em>Links</em>}</li>
 * </ul>
 *
 * @see de.thm.icampus.joomdd.ejsl.eJSL.EJSLPackage#getPage()
 * @model
 * @generated
 */
public interface Page extends EObject
{
  /**
   * Returns the value of the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Name</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Name</em>' attribute.
   * @see #setName(String)
   * @see de.thm.icampus.joomdd.ejsl.eJSL.EJSLPackage#getPage_Name()
   * @model
   * @generated
   */
  String getName();

  /**
   * Sets the value of the '{@link de.thm.icampus.joomdd.ejsl.eJSL.Page#getName <em>Name</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Name</em>' attribute.
   * @see #getName()
   * @generated
   */
  void setName(String value);

  /**
   * Returns the value of the '<em><b>Parametergroups</b></em>' reference list.
   * The list contents are of type {@link de.thm.icampus.joomdd.ejsl.eJSL.ParameterGroup}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Parametergroups</em>' reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Parametergroups</em>' reference list.
   * @see de.thm.icampus.joomdd.ejsl.eJSL.EJSLPackage#getPage_Parametergroups()
   * @model
   * @generated
   */
  EList<ParameterGroup> getParametergroups();

  /**
   * Returns the value of the '<em><b>Globalparameters</b></em>' reference list.
   * The list contents are of type {@link de.thm.icampus.joomdd.ejsl.eJSL.Parameter}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Globalparameters</em>' reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Globalparameters</em>' reference list.
   * @see de.thm.icampus.joomdd.ejsl.eJSL.EJSLPackage#getPage_Globalparameters()
   * @model
   * @generated
   */
  EList<Parameter> getGlobalparameters();

  /**
   * Returns the value of the '<em><b>Localparameters</b></em>' containment reference list.
   * The list contents are of type {@link de.thm.icampus.joomdd.ejsl.eJSL.Parameter}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Localparameters</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Localparameters</em>' containment reference list.
   * @see de.thm.icampus.joomdd.ejsl.eJSL.EJSLPackage#getPage_Localparameters()
   * @model containment="true"
   * @generated
   */
  EList<Parameter> getLocalparameters();

  /**
   * Returns the value of the '<em><b>Links</b></em>' containment reference list.
   * The list contents are of type {@link de.thm.icampus.joomdd.ejsl.eJSL.Link}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Links</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Links</em>' containment reference list.
   * @see de.thm.icampus.joomdd.ejsl.eJSL.EJSLPackage#getPage_Links()
   * @model containment="true"
   * @generated
   */
  EList<Link> getLinks();

} // Page