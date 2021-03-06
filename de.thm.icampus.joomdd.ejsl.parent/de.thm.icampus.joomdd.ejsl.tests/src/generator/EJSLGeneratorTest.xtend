package generator

import Util.TemplateLoader
import com.google.inject.Inject
import de.thm.icampus.joomdd.ejsl.eJSL.CMSExtension
import de.thm.icampus.joomdd.ejsl.eJSL.EJSLModel
import de.thm.icampus.joomdd.ejsl.eJSL.Entity
import de.thm.icampus.joomdd.ejsl.ressourceTransformator.RessourceTransformer
import de.thm.icampus.joomdd.ejsl.tests.EJSLInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static org.junit.jupiter.api.Assertions.*

@ExtendWith(InjectionExtension)
@InjectWith(EJSLInjectorProvider)

class EJSLGeneratorTest {
	@Inject	
	
	@Test
	def checkEntityMappin(){
		 var EJSLModel model = TemplateLoader.loadXMIModel("testmapping")
		 
		 var RessourceTransformer trans = new RessourceTransformer(model)
         trans.dotransformation
          var CMSExtension extensionPart = model.ejslPart as CMSExtension
         var Entity mappingTable = null
         for(Entity e : extensionPart.feature.entities)
          if(e.name.equalsIgnoreCase("usersgroups"))
             mappingTable = e
		 
         assertNotNull(mappingTable);
	}
	
	/*
	@Test
	public def checkInstallDataOfComponent(){
	    var File templateFolder = new File(TemplateLoader.getClassLoader().getResource("").getPath().replace("tests/bin","tests/testdata"))
		var EJSLModel model = TemplateLoader.loadXMIModel("Shop")
		 
		var RessourceTransformer trans = new RessourceTransformer(model)
        trans.dotransformation
         
		var Source schemaFile = null
        var Source xmlFile = null 
        var CMSExtension extensionPart = model.ejslPart as CMSExtension
         
         var ExtendedCMSExtension cmsext = new ExtendedCMSExtensionImpl(extensionPart)
         var ExtendedComponent com = cmsext.extensionsExtended.get(0).getcomponentExtended
         var ComponentGenerator compGen = new ComponentGenerator(com,null,"","")
         var indexPages = com.backEndExtendedPagerefence.map [t|
			if(t.extendedPage.extendedDynamicPageInstance !== null) t.extendedPage.extendedDynamicPageInstance
		];
		var CharSequence instalConfig = compGen.xmlContent(com,indexPages)
         var InputStream in = new ByteArrayInputStream(instalConfig.toString.getBytes());
         var boolean result = true
         try {
          xmlFile = new StreamSource(in);
         schemaFile = new StreamSource(new File(templateFolder.path +"/install.xsd"));
          var SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        var  Schema schema = schemaFactory.newSchema(schemaFile);
         var Validator validator = schema.newValidator();
         
        validator.validate(xmlFile);
        } catch (Exception e) {
           println(e.getLocalizedMessage());
           result = false
        }
         Assert.assertTrue(result)
         
	}*/
	
}
