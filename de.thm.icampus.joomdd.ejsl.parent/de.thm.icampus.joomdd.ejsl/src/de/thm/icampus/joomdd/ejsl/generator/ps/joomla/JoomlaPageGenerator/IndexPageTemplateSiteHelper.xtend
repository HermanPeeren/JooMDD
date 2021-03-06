package de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaPageGenerator

import de.thm.icampus.joomdd.ejsl.eJSL.Component
import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedEntity.ExtendedAttribute
import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedEntity.ExtendedEntity
import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedExtension.ExtendedComponent
import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedPage.ExtendedDynamicPage
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaUtil.Slug
import org.eclipse.emf.common.util.EList
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaUtil.StaticLanguage

/**
 * This class contains the templates to generate the necessary code for frontend view templates (index pages).
 * 
 * @author Dieudonne Timma, Dennis Priefer
 */
class IndexPageTemplateSiteHelper extends IndexPageTemplateHelper {
    
    ExtendedDynamicPage indexpage
	ExtendedComponent  com
	String sec
	ExtendedDynamicPage details
	ExtendedEntity mainEntity
	
	new(ExtendedDynamicPage dp, ExtendedComponent cp, String section) {
		indexpage = dp
		com = cp
		sec = section
		details = Slug.getPageForDetails(indexpage,com)
		mainEntity = dp.extendedEntityList.get(0)
	}
	
	public def CharSequence generateSiteViewDisplay() '''
	    /**
	     * Display the view
	     */
	    public function display($tpl = null)
	    {
	        $user = Factory::getUser();

	        $app = Factory::getApplication();
	        $this->params = $app->getParams('«Slug.nameExtensionBind("com", com.name).toLowerCase»');
	        $state = $this->params->get('state');
	        if (!empty($state)) {
	            $this->getModel()->setState('filter.state', $state);
	        }
	        $search = $this->params->get('search');
	        if (!empty($search)) {
	            $this->getModel()->setState('filter.search', $search);
	        }
	        $created_by = $this->params->get('created_by');
	        if (!empty($created_by)) {
	            $this->getModel()->setState('filter.search', $created_by);
	        }
	        $ordering = $this->params->get('ordering');
	        if (!empty($ordering)) {
	            $this->getModel()->setState('list.ordering', $ordering);
	        }
	        $direction = $this->params->get('direction');
	        if (!empty($direction)) {
	            $this->getModel()->setState('list.direction', $direction);
	        }
	        $start = $this->params->get('start');
	        if (!empty($start)) {
	            $this->getModel()->setState('list.start', $start);
	        }
	        $limit = $this->params->get('limit');
	        if (!empty($limit)) {
	            $this->getModel()->setState('list.limit', $limit);
	        }
	        «FOR ExtendedAttribute attr: indexpage.extendedTableColumnList»
	        $«attr.name» = $this->params->get('«attr.name»');
	        if (!empty($«attr.name»)) {
	            $this->getModel()->setState('filter.«attr.name»', $«attr.name»);
	        }
	        «ENDFOR»

	        $this->items = $this->get('Items');
	        $this->pagination = $this->get('Pagination');
	        $this->state = $this->get('State');
	        $this->filterForm    = $this->get('FilterForm');
	        $this->activeFilters = $this->get('ActiveFilters');

	        $this->params = $app->getParams('«Slug.nameExtensionBind("com", com.name).toLowerCase»');

	        // Check for errors.
	        if (count($errors = $this->get('Errors'))) {
	            throw new Exception(implode("\n", $errors));
	        }

	        $this->_prepareDocument();
	        parent::display($tpl);
	    }
	'''
	
	public def CharSequence generateSiteViewprepareDocument() '''
	/**
	 * Prepares the document
	 */
	protected function _prepareDocument()
	{
	    $app = Factory::getApplication();
	    $menus = $app->getMenu();
	    $title = null;

	    // Because the application sets a default page title,
	    // we need to get it from the menu item itself
	    $menu = $menus->getActive();
	    if ($menu) {
	        $this->params->def('page_heading', $this->params->get('page_title', $menu->title));
	    } else {
	        $this->params->def('page_heading', Text::_('«Slug.addLanguage(com.languages, newArrayList("com", com.name, indexpage.name), indexpage.name)»'));
	    }
	    $title = $this->params->get('page_title', '');
	    if (empty($title)) {
	        $title = $app->get('sitename');
	    } elseif ($app->get('sitename_pagetitles', 0) == 1) {
	        $title = Text::sprintf('JPAGETITLE', $app->get('sitename'), $title);
	    } elseif ($app->get('sitename_pagetitles', 0) == 2) {
	        $title = Text::sprintf('JPAGETITLE', $title, $app->get('sitename'));
	    }
	    $this->document->setTitle($title);

	    if ($this->params->get('menu-meta_description')) {
	        $this->document->setDescription($this->params->get('menu-meta_description'));
	    }
	
	    if ($this->params->get('menu-meta_keywords')) {
	        $this->document->setMetadata('keywords', $this->params->get('menu-meta_keywords'));
	    }
	
	    if ($this->params->get('robots')) {
	        $this->document->setMetadata('robots', $this->params->get('robots'));
	    }
	}
	'''

	public def CharSequence genViewTemplateInit()'''
		HTMLHelper::addIncludePath(JPATH_COMPONENT . '/helpers/html');
		HTMLHelper::_('bootstrap.tooltip');
		HTMLHelper::_('behavior.multiselect');
		HTMLHelper::_('formbehavior.chosen', 'select');
		
		$user = Factory::getUser();
		$userId = $user->get('id');
		$model = $this->getModel();
		$listOrder = $this->state->get('list.ordering');
		$listDirn = $this->state->get('list.direction');
		$canCreate = $user->authorise('core.create', '«Slug.nameExtensionBind("com",com.name).toLowerCase»');
		$canEdit = $user->authorise('core.edit', '«Slug.nameExtensionBind("com",com.name).toLowerCase»');
		$canCheckin = $user->authorise('core.manage', '«Slug.nameExtensionBind("com",com.name).toLowerCase»');
		$canChange = $user->authorise('core.edit.state', '«Slug.nameExtensionBind("com",com.name).toLowerCase»');
		$canDelete = $user->authorise('core.delete', '«Slug.nameExtensionBind("com",com.name).toLowerCase»');
		$columns = «extendedTableColumnListSize»;
		?>
	'''

	def getExtendedTableColumnListSize() {
		return indexpage.extendedTableColumnList.size;
	}

	public def CharSequence genViewTemplateHead()'''
	<form
	    action="<?php echo Route::_('index.php?option=«Slug.nameExtensionBind("com",com.name).toLowerCase»&view=«indexpage.name.toLowerCase»'); ?>"
	    method="post"
	    name="adminForm"
	    id="adminForm"
	>
	    <?php
	        echo LayoutHelper::render('joomla.searchtools.default', array('view' => $this));
	    ?>
	    <?php if (empty($this->items)) : ?>
	        <div class="alert alert-no-items">
	            <?php echo JText::_('JGLOBAL_NO_MATCHING_RESULTS'); ?>
	        </div>
	    <?php else : ?>
	        <table class="table table-striped">
	            <thead>
	                <tr>
	                    <?php if ((isset($this->items[0]) && property_exists($this->items[0], 'state')) && $canEdit) : ?>
	                        <th width="1%" class="nowrap center">
	                        <?php echo HTMLHelper::_('grid.sort', 'JSTATUS', 'a.state', $listDirn, $listOrder); ?>
	                        </th>
	                        <?php $columns++;?>
	                    <?php endif; ?>
	                        «FOR ExtendedAttribute attr: indexpage.extendedTableColumnList»
	                        <th class='left'>
	                            <?php echo HTMLHelper::_(
	                                'grid.sort',
	                                '«Slug.addLanguage(com.languages, newArrayList("com", com.name, "FORM", "LBL", mainEntity.name, attr.name), attr.name)»',
	                                '«this.mainEntity.name».«attr.name»',
	                                $listDirn,
	                                $listOrder
	                            ); ?>
	                        </th>
	                        «ENDFOR»
	                </tr>
	            </thead>
	            <tbody>
	                «genViewTemplateBody()»
	            </tbody>
	            <tfoot>
	                <tr>
	                    <td colspan="<?php echo $columns;?>">
	                        <?php echo $this->pagination->getListFooter(); ?>
	                    </td>
	                </tr>
	            </tfoot>
	        </table>
	    <?php endif; ?>
	    «IF details !== null»
	    <?php if ($canCreate) : ?>
	    <a
	        href="<?php echo Route::_('index.php?option=«Slug.nameExtensionBind("com", com.name).toLowerCase»&view=«details.name.toLowerCase»edit&layout=edit&«mainEntity.primaryKey.name»=0', false, 2); ?>"
	        class="btn btn-success btn-small">
	        <i class="icon-plus"></i> <?php echo Text::_('JGLOBAL_FIELD_ADD'); ?>
	    </a>
	    <?php endif; ?>
	    «ENDIF»
	    <input type="hidden" name="task" value=""/>
	    <input type="hidden" name="boxchecked" value="0"/>
	    <input type="hidden" name="filter_order" value="<?php echo $listOrder; ?>"/>
	    <input type="hidden" name="filter_order_Dir" value="<?php echo $listDirn; ?>"/>
	    <?php echo HTMLHelper::_('form.token'); ?>
	</form>
	<script type="text/javascript">
	    jQuery(document).ready(function () {
	        jQuery('.delete-button').click(deleteItem);
	    });
	    
	    «IF details !== null»
	    function deleteItem() {
	        var item_id = jQuery(this).attr('data-item-id');
	        if (confirm("<?php echo Text::_('«Slug.addLanguage(com.languages, newArrayList("com", com.name), StaticLanguage.DELETE_MESSAGE)»'); ?>")) {
	            window.location.href = '<?php echo Route::_('index.php?option=«Slug.nameExtensionBind("com", com.name).toLowerCase»&task=«details.name.toLowerCase»edit.remove&«mainEntity.primaryKey.name»=') ?>' + item_id;
	        }
	    }
        «ENDIF»
	</script>
	'''
	
	public def CharSequence genViewTemplateBody()'''
	    <?php foreach ($this->items as $i => $item) : ?>
	        <?php $canEdit = $user->authorise('core.edit', '«Slug.nameExtensionBind("com", com.name).toLowerCase»'); ?>
	        <?php if (!$canEdit && $user->authorise('core.edit.own', '«Slug.nameExtensionBind("com", com.name).toLowerCase»')) : ?>
	            <?php $canEdit = Factory::getUser()->id == $item->created_by; ?>
	        <?php endif; ?>
	        <tr class="row<?php echo $i % 2; ?>">

	        <?php if (isset($this->items[0]->state)&& $canEdit) : ?>
	            <?php $class = ($canEdit || $canChange) ? 'active' : 'disabled'; ?>
	            <td class="center">
	                <a class="btn btn-micro <?php echo $class; ?>"
	                    «IF details !== null»
	                    href="<?php echo ($canEdit || $canChange) ? Route::_('index.php?option=«Slug.nameExtensionBind("com", com.name.toLowerCase)»&task=«details.name»edit.publish&«mainEntity.primaryKey.name»=' . $item->«mainEntity.primaryKey.name» . '&state=' .$item->state) : '#'; ?>">
	                    «ENDIF»
	                    <?php if ($item->state == 1) : ?>
	                    <i class="icon-publish"></i>
	                    <?php else : ?>
	                    <i class="icon-unpublish"></i>
	                    <?php endif; ?>
	                </a>
	            </td>
	        <?php endif; ?>
	        «genModelAttributeReference(indexpage.extendedTableColumnList, indexpage,com)»
	        </tr>
	    <?php endforeach; ?>
	'''
}