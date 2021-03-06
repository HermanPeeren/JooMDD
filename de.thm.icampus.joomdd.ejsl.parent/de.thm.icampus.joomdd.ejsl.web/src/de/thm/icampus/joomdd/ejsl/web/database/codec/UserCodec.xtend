package de.thm.icampus.joomdd.ejsl.web.database.codec

import de.thm.icampus.joomdd.ejsl.web.database.document.User
import java.sql.Timestamp
import org.bson.BsonReader
import org.bson.BsonTimestamp
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext
import org.bson.codecs.configuration.CodecRegistry
import org.bson.types.ObjectId

/**
 * @author Wolf Rost
 */
class UserCodec implements Codec<User> {

    private CodecRegistry codecRegistry;

    new(CodecRegistry codecRegistry) {
        this.codecRegistry = codecRegistry;
    }

    override User decode(BsonReader reader, DecoderContext decoderContext)
    {
        reader.readStartDocument();
        var ObjectId id = reader.readObjectId;
        var String username = reader.readString("username");
        var String password = reader.readString("password");
        var BsonTimestamp timestamp = reader.readTimestamp("timestamp");
        reader.readEndDocument();

        var User user = new User(username, password, new Timestamp(timestamp.time));
        user.ID = id;
        return user;
    }

    override void encode(BsonWriter writer, User user, EncoderContext encoderContext) {
        writer.writeStartDocument();
        writer.writeName("username");
        writer.writeString(user.username);
        writer.writeName("password");
        writer.writeString(user.password);
        writer.writeName("timestamp");
        writer.writeTimestamp(new BsonTimestamp(user.timestamp.time));
        writer.writeEndDocument();
    }

    override Class<User> getEncoderClass() {
        return User;
    }
}