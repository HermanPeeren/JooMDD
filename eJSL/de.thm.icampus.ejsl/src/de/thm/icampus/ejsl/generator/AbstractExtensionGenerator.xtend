/**
 */
package de.thm.icampus.ejsl.generator;

import de.thm.icampus.ejsl.eJSL.Author
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.generator.IFileSystemAccess
import de.thm.icampus.ejsl.eJSL.Extension
import de.thm.icampus.ejsl.eJSL.Type
import de.thm.icampus.ejsl.eJSL.DatatypeReference
import de.thm.icampus.ejsl.eJSL.SimpleDatatypes
import de.thm.icampus.ejsl.eJSL.Parameter

abstract public class AbstractExtensionGenerator {

	@Property IFileSystemAccess fsa
	@Property String name
	@Property String path = ""
	public Extension ext

	/**
     * as the name gets prefixed with the type of the Extension, 
     * this Field should hold the unprefixed name, needed for correct naming 
     * of .php files in view and admin
     */
	@Property String noPrefixName

	/**
     * Setter for path
     * Property path will contain a trailing slash
     */
	def void setPath(String path) {
		_path = path
		if (!path.empty && !(path.endsWith("/") || path.endsWith("\\"))) {
			_path = _path.concat("/")
		}
	}

	/**
     * Get name extended path
     */
	def String getPath() {
		return _path.concat(name + "/")
	}

	/**
     * Get either name extended or raw path
     * 
     * @param raw
     * @return raw path if raw = true, name extended path otherwise 
     */
	def String getPath(boolean raw) {
		if (raw)
			return _path
		return path
	}

	/**
     * Setter for entity name.
     * 
     * @param name Name of entity
     */
	def void setName(String name) {
		_name = name
	}

	/**
     * Getter for entity name.
     */
	def String getName() {
		return _name
	}

	/**
     * Generate directory containing default joomla index.html.
     * Directory name will be prefixed by path
     * 
     * @param dirName  using '/' as directory separator
     */
	def protected generateJoomlaDirectory(String dirName) {
		var p = dirName
		while (p.endsWith("/")) {
			p = p.substring(0, p.length - 1);
		}
		generateFile(p + "/index.html", indexHtml)
	}

	def static CharSequence indexHtml() '''
		<!DOCTYPE html><title></title>
	'''

	/**
     * Generate File using fsa.
     * File name will be prefixed by path
     * 
     * @param fileName  using '/' as file separator
     * @param content   the to-be-written contents
     */
	def protected void generateFile(String fileName, CharSequence content) {
		fsa.generateFile(path + fileName, content)
	}

	/* Abstract Methods */
	/**
     * Generate content for entity. Every generated file will be 
     * placed in the directory defined by property path
     */
	def CharSequence generate(EList<Author> authors) '''
		«IF authors.size() == 0»
			<author>Auto Generated Author</author>
			<authorEmail>info@generated.com</authorEmail>
			<authorUrl>www.generated.com</authorUrl>
		«ELSE»
			«FOR author : authors»
				<author>«author.name»</author>
				«IF author.authoremail != null»
					<authorEmail>«author.authoremail»</authorEmail>
				«ENDIF»
				«IF author.authorurl != null»
					<authorUrl>«author.authorurl»</authorUrl>
				«ENDIF»
			«ENDFOR»
		«ENDIF»
	'''

	public def CharSequence generate();

	/**
     * Generate content for entity.
     * 
     * @see EntityGenerator.generate()
     * @param path Will be set using 
     */
	def void generate(String path) {
		var old_path = this.path
		this.path = path
		generate()
		this.path = old_path
	}
	
	def String getTypeName(Type typ){
		var String result = "";
		switch typ{
			DatatypeReference :{
				var DatatypeReference temptyp = typ as DatatypeReference
				result = temptyp.type.name
			}
			SimpleDatatypes:{
				var SimpleDatatypes temptyp = typ as SimpleDatatypes
				result = temptyp.type.toString
			}
		}
		return result
	}
	
	def CharSequence generateParameter(EList<Parameter>listParams)'''
		«FOR param : listParams»
		 <field
		 name="«param.name»"
		 type="«getTypeName(param.dtype)»"
		 label="«param.label »"
		 description="«param.descripton»"
		 />
		«ENDFOR»
		'''

	public def EList<ProtectedRegion> getProtectedRegions();

	public def void setProtectedRegions(EList<ProtectedRegion> myprotectedRegions)

	def Slug getSlug()

	def void setSlug(Slug slug);

	def KVPairGeneratorClient getKvPairClient();

	def void setKvPairClient(KVPairGeneratorClient e);

} // AbstractExtensionGenerator
