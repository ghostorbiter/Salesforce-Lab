/**
 * Created by yyusupov on 15.07.2022.
 */

public with sharing class RandomContactAccountTriggerHandler {

    public class ResponseWrapper{
        public List<Person> results;
    }

    public class Person{
        public Name name;
    }

    public class Name{
        public String first;
        public String last;
    }

////////////////////////////////////...MAIN LOGIC...//////////////////////////////////////////////////////

    public static void handleAfterInsert(Map<Id, Account> newIdsToAccounts){
        relateContactToAccount(newIdsToAccounts.keySet());
    }

    @Future(Callout=true)
    private static void relateContactToAccount(Set<Id> accounts){
        HttpResponse response = send('gb', accounts.size());
        System.debug('response after ' + response);

        System.debug('before wrapper');
        ResponseWrapper responseWrapper = (ResponseWrapper) JSON.deserialize(response.getBody(), ResponseWrapper.class);
        System.debug('response Wrapper ' + responseWrapper);

        List<Contact> contacts = new List<Contact>();
        Integer i = 0;
        for (Id id : accounts){
            contacts.add(new Contact(FirstName = responseWrapper.results[i].name.first,
                    LastName = responseWrapper.results[i].name.last, AccountId = id));
            i++;
        }

        try{
            insert contacts;
        }catch (DmlException ex){
            System.debug(ex);
        }
    }

    public static HttpResponse send(String nat, Integer size){
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        String endPoint = 'https://randomuser.me/api/?nat='+nat+'&results='+size+'&inc=name';
        request.setEndpoint(endPoint);

        Http http = new Http();
        HttpResponse response;

        try{
            response = http.send(request);
        }catch (System.CalloutException ex){
            System.debug(ex);
        }

        System.debug(response.getBody());
        return response;
    }

}
