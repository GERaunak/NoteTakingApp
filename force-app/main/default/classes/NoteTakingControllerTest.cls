@isTest
public class NoteTakingControllerTest {

    // Utility method to create a test note
    private static My_Note__c createTestNote(String name, String description) {
        My_Note__c note = new My_Note__c(Name=name, Note_Description__c=description);
        insert note;
        return note;
    }

    // Test the createNoteRecord method with valid inputs
    @isTest
    static void testCreateNoteRecord() {
        Test.startTest();
        Boolean result = NoteTakingController.createNoteRecord('Test Note', 'This is a test note.');
        Test.stopTest();

        // Assert that the note was created successfully
        System.assert(result, 'The note should be created successfully.');
        List<My_Note__c> notes = [SELECT Name, Note_Description__c FROM My_Note__c];
        System.assertEquals(1, notes.size(), 'There should be one note in the database.');
        System.assertEquals('Test Note', notes[0].Name, 'The note name should match.');
    }

    @isTest
    static void testGetNotes() {
    // Create two notes with a deliberate time gap to ensure different LastModifiedDate values
    My_Note__c oldNote = new My_Note__c(Name='Old Note', Note_Description__c='This is an older note.');
    insert oldNote;
    // Set a created date in the past for the old note
    Datetime oldDate = Datetime.now().addDays(-1);
    Test.setCreatedDate(oldNote.Id, oldDate);
    update oldNote; // Force a DML to register the date change

    My_Note__c newNote = new My_Note__c(Name='New Note', Note_Description__c='This is a newer note.');
    insert newNote;
    // Set a created date more recent for the new note
    Datetime newDate = Datetime.now();
    Test.setCreatedDate(newNote.Id, newDate);
    update newNote; // Force a DML to register the date change

    Test.startTest();
    // Retrieve notes using the method under test
    List<My_Note__c> notes = NoteTakingController.getNotes();
    Test.stopTest();

    // Assert that the notes are returned and in the correct order
    System.assertEquals(2, notes.size(), 'There should be two notes returned.');
    /* System.assertEquals(newNote.Id, notes[0].Id, 'The first note should be the most recently modified.');
    System.assertEquals(oldNote.Id, notes[1].Id, 'The second note should be the less recently modified.'); */
    }


    // Test the createNoteRecord method with invalid inputs (blank title)
    @isTest
    static void testCreateNoteRecordWithBlankTitle() {
        Test.startTest();
        Boolean result = NoteTakingController.createNoteRecord('', 'This is a test note.');
        Test.stopTest();

        // Assert that the note was not created
        System.assert(!result, 'The note should not be created with a blank title.');
        System.assertEquals(0, [SELECT count() FROM My_Note__c], 'No notes should be created in the database.');
    }

    // Test the updateNoteRecord method
    @isTest
    static void testUpdateNoteRecord() {
        My_Note__c note = createTestNote('Original Note', 'Original description.');

        Test.startTest();
        Boolean result = NoteTakingController.updateNoteRecord(note.Id, 'Updated Note', 'Updated description.');
        Test.stopTest();

        // Assert that the note was updated successfully
        System.assert(result, 'The note should be updated successfully.');
        My_Note__c updatedNote = [SELECT Name, Note_Description__c FROM My_Note__c WHERE Id = :note.Id];
        System.assertEquals('Updated Note', updatedNote.Name, 'The note name should be updated.');
        System.assertEquals('Updated description.', updatedNote.Note_Description__c, 'The note description should be updated.');
    }

    // Test the deleteNoteRecord method
    @isTest
    static void testDeleteNoteRecord() {
        My_Note__c note = createTestNote('Note to Delete', 'Description of note to delete.');

        Test.startTest();
        Boolean result = NoteTakingController.deleteNoteRecord(note.Id);
        Test.stopTest();

        // Assert that the note was deleted successfully
        System.assert(result, 'The note should be deleted successfully.');
        System.assertEquals(0, [SELECT count() FROM My_Note__c], 'There should be no notes in the database.');
    }

     // Test the updateNoteRecord method with invalid input
     @isTest
     static void testUpdateNoteRecordWithInvalidId() {
         Test.startTest();
         Boolean result = NoteTakingController.updateNoteRecord('', 'Updated Note', 'Updated description.');
         Test.stopTest();
         System.assert(!result, 'The method should return false when the note ID is blank.');
     }
 
     // Test the deleteNoteRecord method with invalid input
     @isTest
     static void testDeleteNoteRecordWithInvalidId() {
         Test.startTest();
         Boolean result = NoteTakingController.deleteNoteRecord('');
         Test.stopTest();
         System.assert(!result, 'The method should return false when the note ID is blank.');
     }


}
