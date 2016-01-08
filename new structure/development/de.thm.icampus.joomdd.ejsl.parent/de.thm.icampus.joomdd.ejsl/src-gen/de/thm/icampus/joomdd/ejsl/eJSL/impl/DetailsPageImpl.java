/**
 * generated by iCampus (JooMDD team) 2.9.1
 */
package de.thm.icampus.joomdd.ejsl.eJSL.impl;

import de.thm.icampus.joomdd.ejsl.eJSL.DetailPageField;
import de.thm.icampus.joomdd.ejsl.eJSL.DetailsPage;
import de.thm.icampus.joomdd.ejsl.eJSL.EJSLPackage;

import java.util.Collection;

import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Details Page</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link de.thm.icampus.joomdd.ejsl.eJSL.impl.DetailsPageImpl#getEditfields <em>Editfields</em>}</li>
 * </ul>
 *
 * @generated
 */
public class DetailsPageImpl extends DynamicPageImpl implements DetailsPage
{
  /**
   * The cached value of the '{@link #getEditfields() <em>Editfields</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getEditfields()
   * @generated
   * @ordered
   */
  protected EList<DetailPageField> editfields;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected DetailsPageImpl()
  {
    super();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  protected EClass eStaticClass()
  {
    return EJSLPackage.Literals.DETAILS_PAGE;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<DetailPageField> getEditfields()
  {
    if (editfields == null)
    {
      editfields = new EObjectContainmentEList<DetailPageField>(DetailPageField.class, this, EJSLPackage.DETAILS_PAGE__EDITFIELDS);
    }
    return editfields;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs)
  {
    switch (featureID)
    {
      case EJSLPackage.DETAILS_PAGE__EDITFIELDS:
        return ((InternalEList<?>)getEditfields()).basicRemove(otherEnd, msgs);
    }
    return super.eInverseRemove(otherEnd, featureID, msgs);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public Object eGet(int featureID, boolean resolve, boolean coreType)
  {
    switch (featureID)
    {
      case EJSLPackage.DETAILS_PAGE__EDITFIELDS:
        return getEditfields();
    }
    return super.eGet(featureID, resolve, coreType);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @SuppressWarnings("unchecked")
  @Override
  public void eSet(int featureID, Object newValue)
  {
    switch (featureID)
    {
      case EJSLPackage.DETAILS_PAGE__EDITFIELDS:
        getEditfields().clear();
        getEditfields().addAll((Collection<? extends DetailPageField>)newValue);
        return;
    }
    super.eSet(featureID, newValue);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eUnset(int featureID)
  {
    switch (featureID)
    {
      case EJSLPackage.DETAILS_PAGE__EDITFIELDS:
        getEditfields().clear();
        return;
    }
    super.eUnset(featureID);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public boolean eIsSet(int featureID)
  {
    switch (featureID)
    {
      case EJSLPackage.DETAILS_PAGE__EDITFIELDS:
        return editfields != null && !editfields.isEmpty();
    }
    return super.eIsSet(featureID);
  }

} //DetailsPageImpl