/*
 * generated by iCampus (JooMDD team) 2.9.1
 */
package de.thm.icampus.joomdd.ejsl.validation.util

import java.util.Collections
import java.util.HashSet
import java.util.Arrays
import java.util.ArrayList
import java.util.Set
import java.util.Map
import java.util.HashMap

/**
 * This class contains the currently valid HTML type mappings in eJSL. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class HTMLTypeMappings {
	
	/**
	 * Insert HTML type mappings here
	 */
    public static final Map<String, HashSet<String>> HTMLTYPEMAP = {
    	val map = new HashMap<String, HashSet<String>>();
    	map.put('Integer', new HashSet(Arrays.asList('Integer')));
    	map.put('Yes_No_Buttons', new HashSet(Arrays.asList('Boolean')));
    	map.put('Textarea', new HashSet(Arrays.asList('Text', 'Short_Text', 'Integer', 'Time', 'Date', 'Datetime', 'Link', 'Image', 'File')));
    	map.put('Text_Field', new HashSet(Arrays.asList('Text', 'Short_Text', 'Integer', 'Time', 'Date', 'Datetime', 'Link', 'Image', 'File')));
    	map.put('Link', new HashSet(Arrays.asList('Text', 'Short_Text', 'Link')));
    	map.put('Datepicker', new HashSet(Arrays.asList('Time', 'Date', 'Datetime', 'Text', 'Short_Text')));
    	map.put('Imagepicker', new HashSet(Arrays.asList('Image', 'Text', 'Short_Text')));
    	map.put('Filepicker', new HashSet(Arrays.asList('File', 'Text', 'Short_Text')));
    	map.put('Editor', new HashSet(Arrays.asList('Text', 'Short_Text')));
    	return map;
    }
}