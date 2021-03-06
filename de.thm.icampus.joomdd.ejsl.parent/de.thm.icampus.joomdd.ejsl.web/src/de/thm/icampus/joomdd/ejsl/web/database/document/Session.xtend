package de.thm.icampus.joomdd.ejsl.web.database.document

import java.sql.Timestamp
import org.bson.Document
import org.bson.types.ObjectId

/**
 * @author Wolf Rost
 */
class Session extends Document {
	private ObjectId userID;
	private String sessionID;
	private Timestamp timestamp;
	
	new (ObjectId userID, String sessionID, Timestamp timestamp) {
		this.userID = userID;
		this.sessionID = sessionID;
		this.timestamp = timestamp;
	}
	
	def getUserID() {
		return userID;
	}
	
	def getSessionID() {
		return sessionID
	}
	
	def getTimestamp() {
		return timestamp
	}
}
