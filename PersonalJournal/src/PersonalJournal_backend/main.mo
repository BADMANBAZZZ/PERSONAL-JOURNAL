import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type EntryId = Nat;
  
  type JournalEntry = {
    id : EntryId;
    content : Text;
    mood : Text;
    date : Time.Time;
  };

  var entries = Buffer.Buffer<JournalEntry>(0);

  public func addEntry(content : Text, mood : Text) : async EntryId {
    let entryId = entries.size();
    let newEntry : JournalEntry = {
      id = entryId;
      content = content;
      mood = mood;
      date = Time.now();
    };
    entries.add(newEntry);
    entryId;
  };

  public query func getEntry(entryId : EntryId) : async ?JournalEntry {
    if (entryId < entries.size()) {
      ?entries.get(entryId);
    } else {
      null;
    };
  };

  public func updateEntry(entryId : EntryId, content : Text, mood : Text) : async Bool {
    if (entryId < entries.size()) {
      let entry = entries.get(entryId);
      let updatedEntry : JournalEntry = {
        id = entry.id;
        content = content;
        mood = mood;
        date = Time.now();
      };
      entries.put(entryId, updatedEntry);
      true;
    } else {
      false;
    };
  };

  public query func getAllEntries() : async [JournalEntry] {
    Buffer.toArray(entries);
  };

  //case-sensitive
  public query func getEntriesByMood(mood : Text) : async [JournalEntry] {
    let results = Buffer.Buffer<JournalEntry>(0);
    for (entry in entries.vals()) {
      if (Text.equal(entry.mood, mood)) {
        results.add(entry);
      };
    };
    Buffer.toArray(results);
  };
};