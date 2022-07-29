/**
 * Created by yyusupov on 05.07.2022.
 */

public with sharing class DeactivateContactsUpdateTitle {

    public void DeactivateAndUpdate(List<Account> accounts)
    {
        List<Contact> toUpdateContacts = new List<Contact>();

        for (Account account : accounts)
        {
            if (!account.ActiveAccount__c)
            {
                for (Contact contact : account.Contacts)
                {
                    //deactivate contacts
                    Contact toUpdateContact = contact;
                    toUpdateContact.isActive__c = false;
                    toUpdateContact.put('Title', account.Description.substring(0, 127));
                    toUpdateContacts.add(toUpdateContact);
                }
            }
        }
        Database.update(toUpdateContacts, false);
    }
}

//Fix this
//List<Account> accounts = [SELECT Id, Active__c FROM Account]; <--- such is possible (add queries inside the code)