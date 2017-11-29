package de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaExtensionGenerator

import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedExtension.ExtendedComponent
import de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedExtension.ExtendedPageReference
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaExtensionGenerator.AbstractExtensionGenerator
import de.thm.icampus.joomdd.ejsl.generator.ps.joomla.JoomlaUtil.Slug

/**
 * This class contains the code templates for the helper class of a Joomla component
 * 
 * @author Dieudonne Timma, Dennis Priefer
 */
class ComponentHelperGenerator extends AbstractExtensionGenerator{
//	
	
	ExtendedComponent extendeComp
	new(ExtendedComponent component) {
		extendeComp = component
	}
 
    override generate() '''
		<?php
		«Slug.generateFileDoc(extendeComp)»
		
		«Slug.generateRestrictedAccess()»
		
		jimport('joomla.filesystem.file');
		
		/**
		 * «extendeComp.name.toUpperCase»  helper.
		 */
		class «extendeComp.name.toFirstUpper»Helper
		{
		    «genAddMenu»
		    «genGetAction»
		    «genUploadFile»
		}
	'''
	
    /**
     * Generate the AddSubmenu method for the backend menu
     * 
     */
    private def CharSequence genAddMenu()'''
		/**
		 * Configure the Linkbar.
		 */
		public static function addSubmenu($vName = '')
		{
		    «FOR ExtendedPageReference pg : extendeComp.backEndExtendedPagerefence.filter[t| t.extendedPage.extendedDynamicPageInstance !== null && !t.extendedPage.extendedDynamicPageInstance.isDetailsPage]»
		    JHtmlSidebar::addEntry(
		        JText::_('«Slug.nameExtensionBind("com",extendeComp.name).toUpperCase»_TITLE_«pg.extendedPage.name.toUpperCase»'),
		        'index.php?option=«Slug.nameExtensionBind("com",extendeComp.name).toLowerCase»&view=«pg.extendedPage.name.toLowerCase»',
		        $vName == '«pg.extendedPage.name.toLowerCase»');
		    «ENDFOR»
		}
		'''
    
    /**
     * Generate the template to list the actions that can be performed.
     */
 	private def genGetAction()'''
		/**
		 * Gets a list of the actions that can be performed.
		 *
		 * @return  JObject
		 * @since   1.6
		 */
		public static function getActions()
		{
		    $user = JFactory::getUser();
		    $result = new JObject;

		    $assetName = '«Slug::nameExtensionBind('com', extendeComp.name)»';
		
		    $actions = array(
		        'core.admin', 'core.manage', 'core.create', 'core.edit', 'core.edit.own', 'core.edit.state', 'core.delete');
		
		    foreach ($actions as $action)
		    {
		        $result->set($action, $user->authorise($action, $assetName));
		    }
		
		    return $result;
		}
	'''
	 /**
	  *	Content template to save a file on the server
	  */
    private def genUploadFile()'''
		/**
		 * Save a file in Server
		 * @param   $file     Array   contains the informtion of a File to upload
		 * @param   $target   String  contains the path of Directory
		 * @param   $oldName  String  contains the name of the old file
		 * @return  boolean or String
		 */
		public static function uploadFiles($file, $target, $oldname)
		{
		    $file['name'] = JFile::makeSafe($file['name']);
			$file['name'] = str_replace(' ', '_', $file['name']);
			$file['filepath'] = JPath::clean(implode(DIRECTORY_SEPARATOR, array(JPATH_ROOT, $target, $file['name'])));
			if (JFile::exists($file['filepath']))
			{
			    $index =1;
				$file["name"] = $index."_".$file["name"];
				$file['filepath'] = JPath::clean(implode(DIRECTORY_SEPARATOR, array(JPATH_ROOT, $target, $file['name'])));
				while(JFile::exists($file['filepath']))
				{
				    $index =     $index +1;
					$file["name"] = $index."_".$file["name"];
					$file['filepath'] = JPath::clean(implode(DIRECTORY_SEPARATOR, array(JPATH_ROOT, $target, $file['name'])));
				}
			}
			$object_file = new JObject($file);
		
		    if (!JFile::upload($object_file->tmp_name, $object_file->filepath))
			{
			    return false;
			}
			if(!empty($oldname))
			{
			    $pathOfold = JPath::clean(implode(DIRECTORY_SEPARATOR, array(JPATH_ROOT, $target, $oldname)));
				if(JFile::exists($pathOfold))
				{
				    JFile::delete($pathOfold);
				}
			}
			return $file['name'];
		}
	'''
	
    def CharSequence genBootsnipJS()'''
    (function ( $ ) {
        $.fn.imagePicker = function( options ) {
            // Define plugin options
            var settings = $.extend({
                // Classes for styling the input
                class: "btn btn-success"},
            options );
            // Create an input inside each matched element
            return this.each(function() {
                $(this).children('#add').html(create_btn(this, settings));
            });
        };

        // Private function for creating the input element
        function create_btn(that, settings) {
            // var add = $(that).children('#add');
            var preview = $(that).children('#preview');
    
            if(settings.file != '') {
                var preview = create_preview(that, settings.file, settings.value, settings);
                $(that).children('#add').attr('class','hidden');
                $(that).children('#preview').html(preview);
                return;
            }
    
            // The input icon element
            var picker_btn_icon = $('<span class="">'+settings.showLabel+'</span>');
    
            // The actual file input which stays hidden
            var picker_btn_input = $('<input type="file" accept="'+ settings.accept +'" name="'+settings.name+'" />');
    
            // The actual element displayed
            var picker_btn = $('<div class="'+settings.class+' img-upload-btn"></div>')
                .append(picker_btn_icon)
                .append(picker_btn_input);

            // File load listener
            picker_btn_input.change(function(event) {
                if ($(this).prop('files')[0]) {
                    // Use FileReader to get file
                    var reader = new FileReader();

                    // Create a preview once image has loaded
                    reader.onload = function(e) {
                        var input = event.target;
                        var file = input.files[0];
                        var preview = create_preview(that, e.target.result,file.name , settings);
                        $(that).children('#add').attr('class','hidden');
                        $(that).children('#preview').removeAttr('class');
                        $(that).children('#preview').html(preview);
                    }

                    // Load image
                    reader.readAsDataURL(picker_btn_input.prop('files')[0]);
                }
            });
            return picker_btn
        };
    
        // Private function for creating a preview element
        function create_preview(that, src, filename, settings) {
            var picker_preview_image;
            // The preview image
            if(settings.fieldtype == "image") {
                picker_preview_image = $('<img src="'+src+'" class="img-responsive img-rounded" /><br/><a href="'+settings.file+'">'+filename+'</a>');
            } else {
                var format = src.split(".").getLast();
                picker_preview_image = $('<div class="imgOutline thumbnail height-80 width-80 center"style="margin-left: 40px;margin-bottom:10px;" >'+
                '<div class="height-50">'+
                '<a style="display: block; width: 100%; height: 100%" href="'+src+'">'
                '<img src="'+settings.iconpath+ format + ".png" +
                '" class="img-responsive img-rounded" style="float: right; margin: 20px"/><br/></a></div></div><a href="'+settings.file +'">'+filename+'</a>');
            }
            // The remove image button
            var picker_preview_remove = $('<button class="btn btn-danger"><span >'+settings.deleteLabel + '</span></button>');
    
            // The preview element
            var picker_preview = $('<div class="text-center"></div>')
                .append(picker_preview_image)
                .append(picker_preview_remove);
    
            // Remove image listener
            picker_preview_remove.click(function() {
                settings.file="";
                var btn = create_btn(that, settings);
                $(that).children('#preview').html('');
                $(that).children('#preview').attr('class','hidden');
                $(that).children('#add').removeAttr('class','');
                $(that).children('#add').html(btn);
            });

            return picker_preview;
        };
    }( jQuery ));

    jQuery(document).ready(function() {
        jQuery('.img-picker').each(function(){
            jQuery(this).imagePicker({name: jQuery(this).attr("name"),value: jQuery(this).attr("value"), file:jQuery(this).attr("file"), 
                deleteLabel:jQuery(this).attr("deleteLabel"), showLabel:jQuery(this).attr("showLabel"),accept:jQuery(this).attr("accept"),
                fieldtype:jQuery(this).attr("fieldtype"), iconpath:jQuery(this).attr("iconpath")
            })
        });
    });
    '''
      
    def CharSequence genBootsnipCSS()'''
		.img-upload-btn { 
		    position: relative; 
		    overflow: hidden; 
		    padding-top: 95%;
		}
		.img-upload-btn input[type=file] { 
		    position: absolute; 
		    top: 0; 
		    right: 0; 
		    max-width: 100%;
		    max-height: 100%;
		    font-size: 100px; 
		    text-align: right; 
		    filter: alpha(opacity=0); 
		    opacity: 0; 
		    outline: none; 
		    background: white; 
		    cursor: inherit; 
		    display: block; 
		}
		.img-upload-btn i { 
		    position: absolute;
		    height: 16px;
		    width: 16px;
		    top: 50%;
		    left: 50%;
		    margin-top: -8px;
		    margin-left: -8px;
		}
		.img-picker .btn .img-upload-btn{
		    height: 20px;
		}
		.img-picker .btn .btn-danger{
		    height: 30px;
		}
		.hidden {
		    visibility: hidden;
		}
		.glyphicon {
		    display: inline-block;
		    font-family: "Glyphicons Halflings";
		    font-style: normal;
		    font-weight: 400;
		    line-height: 1;
		    position: relative;
		    top: 1px;
		}
		.glyphicon-plus::before {
		    height: auto;
		    content: '+';
		    font-size: larger;
		
		}
		.carousel-inner > .item > a > img, .carousel-inner > .item > img, .img-responsive, .thumbnail a > img, .thumbnail > img {
		    display: block;
		    height: auto;
		    max-width: 100%;
		}
		.img-rounded {
		    border-radius: 6px;
		}
		.text-center {
		    text-align: center;
		    max-height: 20%;
		    max-width: 20%;
		}
	'''
}
