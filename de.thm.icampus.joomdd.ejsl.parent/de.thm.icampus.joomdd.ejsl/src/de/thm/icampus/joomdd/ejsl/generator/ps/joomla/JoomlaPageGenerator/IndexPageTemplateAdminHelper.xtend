package de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaPageGenerator

import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedEntity.ExtendedAttribute
import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedEntity.ExtendedEntity
import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedExtension.ExtendedComponent
import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedPage.ExtendedDynamicPage
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaUtil.Slug
import org.eclipse.emf.common.util.EList
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaUtil.DatabaseQuery.Query
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaUtil.DatabaseQuery.Select
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaUtil.DatabaseQuery.Column
import de.thm.icampus.joomdd.ejsl.generator.pi.util.MappingEntity

/**
 * This class contains the templates to generate the necessary code for backend view templates (index pages).
 * 
 * @author Dieudonne Timma, Dennis Priefer
 */
class IndexPageTemplateAdminHelper extends IndexPageTemplateHelper {
    
    ExtendedDynamicPage indexpage
	ExtendedComponent  com
	String sec
	String details
	ExtendedEntity mainEntity
    String componentHelperClassName
	
	new(ExtendedDynamicPage dp, ExtendedComponent cp, String section){
		indexpage = dp
		com = cp
		sec = section
		var ExtendedDynamicPage dt = Slug.getPageForDetails(indexpage,com)
		details =  if( dt === null)"<Put the name Of DetailsPage>" else dt.name
		mainEntity = dp.extendedEntityList.get(0)
        this.componentHelperClassName = '''Com«com.name.toFirstUpper»Helper'''
	}
	
	def CharSequence genAdminControllerContructer()'''
	/**
	 * Constructor.
	 *
	 * @param   array  $config  An optional associative array of configuration settings.
	 * @return  «com.name.toFirstUpper»Controller«indexpage.name.toFirstUpper»
	 * @see     JController
	 * @since   1.6
	 * @generated
	 */
	public function __construct($config = array())
	{
	    parent::__construct($config);
	}
	'''
	
	public def genAdminControllerGetModel()'''
	/**
	 * Overwrite the  getModel.
	 * @since 1.6
	 */
	public function getModel($name = '«details.toFirstUpper»', $prefix = '«com.name.toFirstUpper»Model', $config = array())
	{
	    $model = parent::getModel($name, $prefix, array('ignore_request' => true));
	    return $model;
	}
	'''
	
	def CharSequence genAdminControllerSaveOrdering()'''
	/**
	 * save the order.
	 *
	 * @return  Integer
	 * @generated
	 */
	public function saveordering()
	{
	    $app = Factory::getApplication();
	    $ids = $app->input->get('cid', array(), 'array');
	    $model = $this->getModel('«indexpage.name.toLowerCase»');
	    $result = $model->saveOrdering($ids);
	    if ($result) {
	        echo new JsonResponse($result);
	    }
	}
	'''
	
	def CharSequence genAdminModelConstruct()'''
    	/**
    	 * Constructor.
    	 *
    	 * @param    array    An optional associative array of configuration settings.
    	 * @see        JController
    	 * @since    1.6
    	 * @generated
    	 */
    	public function __construct($config = array())
    	{
    	    if (empty($config['filter_fields'])) {
    	        $config['filter_fields'] = array(
    	            '«mainEntity.primaryKey.name»', '«indexpage.entities.get(0).name».«mainEntity.primaryKey.name»',
    	            'ordering', '«indexpage.entities.get(0).name».ordering',
    	            'state', '«indexpage.entities.get(0).name».state',
    	            'created_by', '«indexpage.entities.get(0).name».created_by',
    	            'published', '«indexpage.entities.get(0).name».published',
    	            «indexpage.allAttributeOfFilterAndColum.map[ attr | 
    	                var column = indexpage.getTextColumn(attr, com.allExtendedEntity)
    	                ''''«attr.name»', '«column»'«»'''
    	            ].join(''',
    	            ''')»
    	        );
    	    }
    	    parent::__construct($config);
    	}
	'''
	
	def CharSequence genAdminModelGetListQuery() {
	    var query = new Query(com)
    	var mainSelectColumn = new Column(indexpage.entities.get(0).name, '''*''')
    	query.addToMainSelect(new Select(mainSelectColumn))
    	
	    return '''
	    /**
	     * Build an SQL query to load the list data.
	     *
	     * @return  JDatabaseQuery
	     * @since 1.6
	     * @generated
	     */
	    protected function getListQuery()
	    {
	        // Create a new query object.
	        $db = $this->getDbo();
	        $query = $db->getQuery(true);
	        $published = $this->getState('filter.state');
	        $created_by = $this->getState('filter.created_by');
	        «FOR ExtendedAttribute attr : indexpage.extendFiltersList»
	        $«attr.name» = $this->getState('filter.«attr.name»');
	        «ENDFOR»
	        $search = $this->getState('filter.search');
	        $orderCol = $this->state->get('list.ordering');
	        $orderDirn = $this->state->get('list.direction');

	        // Select the required fields from the table.
	        $query->select(
	            "distinct " .
	            $this->getState(
	                'list.select',
	                '«query.mainSelect»'
	            )
	        );
	        «query.getListQuery(indexpage, mainEntity, '''<\/br>''', true)»
	        
	        return $query;
	    }
        '''
    }    
    
    def CharSequence genAdminModelGetItem() {
        var multiValueElementList = Slug.getMultiValueElements(this.indexpage)
        
	    return '''
	    /**
	    * Method to get a single record.
	    *
	    * @param   integer  The id of the primary key.
	    *
	    * @return  mixed    Object on success, false on failure.
	    * @since   1.6
	    * @generated
	    */
	    public function getItems()
	    {
	        $items = parent::getItems();
	        «IF multiValueElementList.size > 0»
	        foreach ($items as $item) {
	           «multiValueElementList.join('''
	           
	           ''')»
	        }
	        «ENDIF»
	        return $items;
	    }
    	'''
	}

	def CharSequence genAdminModelSaveOrder()'''
	    /**
	     * Function to save the new Order of the Profile
	     *
	     * @param   Array  $dataID  content the ID in the new Ordering
	     *
	     * @return  array  including headers
	     * @generated
	     */
	    public function saveOrdering($dataID)
	    {
	        $db = Factory::getDbo();
	        $query = $db->getQuery(true);

	        $statement = 'Update #__«com.name»_«indexpage.entities.get(0).name» Set `ordering` = CASE';
	        foreach ($dataID as $order => $profileID) {
	            $statement .= ' WHEN «mainEntity.primaryKey.name» = ' . intval($profileID) . ' THEN ' . (intval($order) + 1);
	        }
	        $statement .= ' ELSE ' . 0 . ' END Where «mainEntity.primaryKey.name» IN(' . implode(',', $dataID) . ')';
	        $db->setQuery($statement);
	        $response = $db->execute();

	        if ($response) {
	            $query = $db->getQuery(true);
	            $query->select('`«mainEntity.primaryKey.name»`, `ordering`')->from('#__«com.name»_«indexpage.entities.get(0).name»');
	            $db->setQuery($query);
	            return $db->loadObjectList();
	        }
	        return false;
	    }
	'''

	def CharSequence genAdminViewDisplay()'''
	    /**
	     * loads model data into view context
	     *
	     * @param   string  $tpl  the name of the template to be used
	     *
	     * @return void
	     * @generated
	     */
	    public function display($tpl = null)
	    {
	        $this->state = $this->get('State');
	        $this->items = $this->get('Items');
	        $this->pagination = $this->get('Pagination');
	        $this->filterForm    = $this->get('FilterForm');
	        $this->activeFilters = $this->get('ActiveFilters');
	    
	        // Check for errors.
	        if (count($errors = $this->get('Errors'))) {
	            throw new Exception(implode("\n", $errors));
	        }
	        «componentHelperClassName»::addSubmenu('«indexpage.name.toLowerCase»');
	        $this->addToolbar();
	        $this->sidebar = JHtmlSidebar::render();
	        parent::display($tpl);
	    }
	'''
	
	def CharSequence genAdminViewAddtoolbar()'''
	    /**
	     * Add the page title and toolbar.
	     *
	     * @since 1.6
	     * @generated
	     */
	    protected function addToolbar()
	    {
	        require_once JPATH_COMPONENT . '/helpers/«com.name.toLowerCase».php';

	        $state = $this->get('State');
	        $canDo = «componentHelperClassName»::getActions($state->get('filter.category_id'));

	        JToolBarHelper::title(Text::_('«Slug.addLanguage(com.languages, newArrayList("com", com.name, "TITLE", indexpage.name), indexpage.name)»'));

	        //Check if the form exists before showing the add/edit buttons
	        $formPath = JPATH_COMPONENT_ADMINISTRATOR . '/views/«  details.toLowerCase»';
	        if (file_exists($formPath)) {
	            if ($canDo->get('core.create')) {
	                JToolBarHelper::addNew('«details.toLowerCase».add', 'JTOOLBAR_NEW');
	            }
	            if ($canDo->get('core.edit') && isset($this->items[0])) {
	                JToolBarHelper::editList('«details.toLowerCase».edit', 'JTOOLBAR_EDIT');
	            }
	        }
	        if ($canDo->get('core.edit.state')) {
	            if (isset($this->items[0]->state)) {
	                JToolBarHelper::divider();
	                JToolBarHelper::custom(
	                    '«indexpage.name.toLowerCase».publish',
	                    'publish.png',
	                    'publish_f2.png',
	                    'JTOOLBAR_PUBLISH',
	                    true
	                );
	                JToolBarHelper::custom(
	                    '«indexpage.name.toLowerCase».unpublish',
	                    'unpublish.png',
	                    'unpublish_f2.png',
	                    'JTOOLBAR_UNPUBLISH',
	                    true
	                );
	            } elseif (isset($this->items[0])) {
	                //If this component does not use state then show a direct delete button as we can not trash
	                JToolBarHelper::deleteList('', '«indexpage.name.toLowerCase».delete', 'JTOOLBAR_DELETE');
	            }
	            if (isset($this->items[0]->state)) {
	                JToolBarHelper::divider();
	                JToolBarHelper::archiveList('«indexpage.name.toLowerCase».archive', 'JTOOLBAR_ARCHIVE');
	            }
	            if (isset($this->items[0]->checked_out)) {
	                JToolBarHelper::custom(
	                    '«indexpage.name.toLowerCase».checkin',
	                    'checkin.png',
	                    'checkin_f2.png',
	                    'JTOOLBAR_CHECKIN',
	                    true
	                );
	            }
	        }
	        //Show trash and delete for components that uses the state field
	        if (isset($this->items[0]->state)) {
	            if ($state->get('filter.state') == -2 && $canDo->get('core.delete')) {
	                JToolBarHelper::deleteList('', '«indexpage.name.toLowerCase».delete', 'JTOOLBAR_EMPTY_TRASH');
	                JToolBarHelper::divider();
	            } elseif ($canDo->get('core.edit.state')) {
	                JToolBarHelper::trash('«indexpage.name.toLowerCase».trash', 'JTOOLBAR_TRASH');
	                JToolBarHelper::divider();
	            }
	        }
	        if ($canDo->get('core.admin')) {
	            JToolBarHelper::preferences('«Slug.nameExtensionBind("com",com.name).toLowerCase»');
	        }
	        JHtmlSidebar::setAction('index.php?option=«Slug.nameExtensionBind("com",com.name).toLowerCase»&view=«indexpage.name.toLowerCase»');
	    }
	'''

	def private CharSequence genAdminViewLayoutFilters()'''
	    <?php
	        echo LayoutHelper::render('joomla.searchtools.default', array('view' => $this));
	    ?>
	'''
    
    def private CharSequence genAdminViewLayoutData(EList<ExtendedAttribute>column)'''
        <?php if (empty($this->items)) : ?>
            <div class="alert alert-no-items">
                <?php echo JText::_('JGLOBAL_NO_MATCHING_RESULTS'); ?>
            </div>
        <?php else : ?>
            <table class="table table-striped" id="«indexpage.name.toFirstUpper»List">
                <thead>
                    <tr>
                        <?php if (isset($this->items[0]) && property_exists($this->items[0], 'ordering')) : ?>
                        <th width="1%" class="nowrap center hidden-phone">
                            <?php echo HTMLHelper::_(
                                'grid.sort',
                                '<i class="icon-menu-2"></i>',
                                '«this.mainEntity.name».ordering',
                                $listDirn,
                                $listOrder,
                                null,
                                'asc',
                                'JGRID_HEADING_ORDERING'
                            ); ?>
                        </th>
                        <?php $columns++; ?>
                        <?php endif; ?>
                        <th width="1%" class="hidden-phone">
                            <input
                                type="checkbox"
                                name="checkall-toggle"
                                value=""
                                title="<?php echo JText::_('JGLOBAL_CHECK_ALL'); ?>"
                                onclick="Joomla.checkAll(this)"
                            />
                        </th>
                        <?php if (isset($this->items[0]) && property_exists($this->items[0], 'state')) : ?>
                        <th width="1%" class="nowrap center">
                            <?php echo HTMLHelper::_(
                                'grid.sort',
                                'JSTATUS',
                                '«this.mainEntity.name».state',
                                $listDirn,
                                $listOrder
                            ); ?>
                        </th>
                        <?php $columns++; ?>
                        <?php endif; ?>
                        «FOR ExtendedAttribute attr : column»
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
                    <?php foreach ($this->items as $i => $item) :
                        $ordering   = ($listOrder == '«this.mainEntity.name.toLowerCase».ordering');
                        $canCreate  = $user->authorise('core.create', '«Slug.nameExtensionBind("com", com.name).toLowerCase»');
                        $canEdit    = $user->authorise('core.edit', '«Slug.nameExtensionBind("com", com.name).toLowerCase»');
                        $canCheckin = $user->authorise('core.manage', '«Slug.nameExtensionBind("com", com.name).toLowerCase»');
                        $canChange  = $user->authorise('core.edit.state', '«Slug.nameExtensionBind("com", com.name).toLowerCase»');
                    ?>
                    <tr class="row<?php echo $i % 2; ?>">
                        <?php if (isset($this->items[0]->ordering)) : ?>
                        <td class="order nowrap center hidden-phone">
                            <?php if ($canChange) :
                                $disableClassName = '';
                                $disabledLabel    = '';
                                if (!$saveOrder) :
                                    $disabledLabel    = JText::_('JORDERINGDISABLED');
                                    $disableClassName = 'inactive tip-top';
                                endif; ?>
                            <span class="sortable-handler hasTooltip <?php echo $disableClassName?>"
                                  title="<?php echo $disabledLabel?>">
                                <i class="icon-menu"></i>
                            </span>
                            <input type="text"
                                   style="display:none"
                                   name="order[]"
                                   size="5"
                                   value="<?php echo $item->ordering;?>"
                                   class="width-20 text-area-order" />
                            <?php else : ?>
                            <span class="sortable-handler inactive" >
                                <i class="icon-menu"></i>
                            </span>
                            <?php endif; ?>
                        </td>
                        <?php endif; ?>
                        <td class="center hidden-phone">
                            <?php echo HTMLHelper::_('grid.id', $i, $item->«mainEntity.primaryKey.name»); ?>
                        </td>
                        <?php if (isset($this->items[0]->state)) : ?>
                        <td class="center">
                            <?php echo HTMLHelper::_(
                                'jgrid.published',
                                $item->state,
                                $i,
                                '«indexpage.name.toLowerCase».',
                                $canChange,
                                'cb'
                            ); ?>
                        </td>
                        <?php endif; ?>
                        «genModelAttributeReference(column, indexpage, com)»
                    </tr>
                    <?php endforeach; ?>
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
    '''
    
    def getextendedTableColumnListSize(){
    	return indexpage.extendedTableColumnList.size
    }
    
    def  CharSequence genAdminViewLayoutForm()''' 
        <form
            action="<?php echo Route::_('index.php?option=«Slug.nameExtensionBind("com", com.name).toLowerCase»&view=«indexpage.name.toLowerCase»'); ?>"
            method="post"
            name="adminForm"
            id="adminForm">
            <?php if (!empty($this->sidebar)) : ?>
            <div id="j-sidebar-container" class="span2">
                <?php echo $this->sidebar; ?>
            </div>
            <div id="j-main-container" class="span10">
            <?php else : ?>
            <div id="j-main-container">
            <?php endif;?>
                «genAdminViewLayoutFilters»
                «genAdminViewLayoutData(indexpage.extendedTableColumnList)»
                <input type="hidden" name="task" value="" />
                <input type="hidden" name="boxchecked" value="0" />
                <input type="hidden" name="filter_order" value="<?php echo $listOrder; ?>" />
                <input type="hidden" name="filter_order_Dir" value="<?php echo $listDirn; ?>" />
                <?php echo HTMLHelper::_('form.token'); ?>
            </div>
        </form>
    '''

    def CharSequence genAdminViewLayoutHeader()'''
        $user = Factory::getUser();
        $userId = $user->get('id');
        $listOrder = $this->state->get('list.ordering');
        $listDirn = $this->state->get('list.direction');
        $canOrder = $user->authorise('core.edit.state', '«Slug.nameExtensionBind("com", com.name).toLowerCase»');
        $saveOrder = $listOrder == '«this.mainEntity.name.toLowerCase».ordering';
        $model = $this->getModel();
        if ($saveOrder) {
            $saveOrderingUrl = 'index.php?option=«Slug.nameExtensionBind("com", com.name).toLowerCase»&task=«indexpage.name.toLowerCase()».saveOrderAjax&tmpl=component';
            HTMLHelper::_(
                'sortablelist.sortable',
                '«indexpage.name.toFirstUpper»List',
                'adminForm',
                strtolower($listDirn),
                $saveOrderingUrl
            );
        }
        ?>
        <script type="text/javascript">
            Joomla.orderTable = function() {
                table = document.getElementById("sortTable");
                direction = document.getElementById("directionTable");
                order = table.options[table.selectedIndex].value;
                if (order != '<?php echo $listOrder; ?>') {
                    dirn = 'asc';
                } else {
                    dirn = direction.options[direction.selectedIndex].value;
                }
                Joomla.tableOrdering(order, dirn, '');
             }
        </script>
    '''
 
    public def CharSequence genAdminModelPopulateState()'''
        /**
         * Method to auto-populate the model state.
         *
         * Note. Calling getState in this method will result in recursion.
         */
        protected function populateState($ordering = '«indexpage.entities.get(0).name».«mainEntity.primaryKey.name»', $direction = 'asc')
        {
            // Load the parameters.
            $params = ComponentHelper::getParams('«Slug.nameExtensionBind("com", com.name.toLowerCase)»');
            $this->setState('params', $params);

            // List state information.
            parent::populateState($ordering, $direction);
        }
    '''

    public def CharSequence genGetIdOfReferenceItem ()'''
        /**
         * Method to get the id of Reference
         * @param  String  $linkName    containt the name of a Attribute
         * @param  String  $attrvaluen  containt the value of a Row
         *
         * @return Integer the ID of a Row
         *
         */
        public function getIdOfReferenceItem($linkName, $attrvalue)
        {
            $dbtable = $this->entitiesRef["$linkName"]["db"];
            $attribute = $this->entitiesRef["$linkName"]["refattr"];
            $db = Factory::getDbo();
            $query = $db->getQuery(true);
            $key = $this->entitiesRef["$linkName"]["foreignPk"];
            $query->select($key)
                ->from($dbtable);
            foreach ($attribute as $index => $attributItem) {
                $query->where($attributItem . " like '".$attrvalue->$index."'");
            }

            $db->setQuery($query);
            $result = $db->loadObject();
            return intval($result->$key);
        }
    '''
}