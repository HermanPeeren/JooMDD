/*
 * generated by iCampus (JooMDD team) 2.9.1
 */
package de.thm.icampus.joomdd.ejsl.web

import java.net.InetSocketAddress
import org.eclipse.jetty.annotations.AnnotationConfiguration
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.util.log.Slf4jLog
import org.eclipse.jetty.webapp.MetaInfConfiguration
import org.eclipse.jetty.webapp.WebAppContext
import org.eclipse.jetty.webapp.WebInfConfiguration
import org.eclipse.jetty.webapp.WebXmlConfiguration
import org.eclipse.xtext.resource.IResourceServiceProvider
import java.util.HashMap
import java.io.File
import java.util.Map
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList

/**
 * This program starts an HTTP server for testing the web integration of your DSL.
 * Just execute it and point a web browser to http://localhost:8080/
 */
class ServerLauncher {
		var static resourcesProvider = IResourceServiceProvider.Registry.INSTANCE
	
	def static void main(String[] args) { 
		val server = new Server(new InetSocketAddress('localhost', 8080))
		server.handler = new WebAppContext => [
			resourceBase = 'WebRoot'
			welcomeFiles = #["index.html"]
			contextPath = "/"
			configurations = #[
				new AnnotationConfiguration,
				new WebXmlConfiguration,
				new WebInfConfiguration,
				new MetaInfConfiguration
			]
			setAttribute(WebInfConfiguration.CONTAINER_JAR_PATTERN, '.*/de\\.thm\\.icampus\\.joomdd\\.ejsl\\.web/.*,.*\\.jar')
		]
		val log = new Slf4jLog(ServerLauncher.name)
		println(args.toString)
		try {
			
			if(resourcesProvider != null){
				var String serverPathString = args.get(0)
		resourcesProvider.contentTypeToFactoryMap.put("serverpath",serverPathString)
	    resourcesProvider.contentTypeToFactoryMap.put("mddsessions",new HashMap<String, Object>)
	    var Map<String,Object> users = resourcesProvider.contentTypeToFactoryMap.get("mddsessions") as Map<String,Object>
	    var File serverPath = new File(serverPathString)
	    resourcesProvider.contentTypeToFactoryMap.put("serverpathname",serverPath.name)
	    for(File userworkspace: serverPath.listFiles){
	    	var String username = userworkspace.name
	    	var File userfiles = new File(serverPathString+"/"+username+"/src/");
	    	if(userfiles.exists){
	    	var EList<String> resourceName = new BasicEList<String>()
	    	for(File resc: userfiles.listFiles){
	    		resourceName.add(username + "/src/"+resc.name)
	    	}
	    	
	    	users.put(username,resourceName)
	    	
	    	}
	    }
	    var File temporyFile = new File(serverPathString+ "/temporyFiles")
	    if(!temporyFile.exists){
	    	  temporyFile.createNewFile
	    }
	     
		}
		server.start
			log.info('Server started ' + server.getURI + '...')
			new Thread[
				log.info('Press enter to stop the server...')
				val key = System.in.read
				if (key !== -1) {
					server.stop
				} else {
					log.warn('Console input is not available. In order to stop the server, you need to cancel process manually.')
				}
			].start
			server.join
		} catch (Exception exception) {
			log.warn(exception.message)
			System.exit(1)
		}
	}
}
