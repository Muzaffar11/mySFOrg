public class ContactSearch{
    public static List<Contact> searchForContacts(string lastname, string mailingpostal ){
    List<Contact> c = [select ID,Name from Contact where LastName = : lastname AND (MailingPostalCode = : mailingpostal OR MailingPostalCode = null) ];
        return c;
    }
}