/**
 * Created by yyusupov on 14.07.2022.
 */

public with sharing class US112ChatterEmployeesScheduler implements Schedulable{

    private static final String BATCH_CLASS_NAME = 'US112ChatterBatch';

    public void execute(SchedulableContext param1) {
        Object batchObject = Type.forName(BATCH_CLASS_NAME).newInstance();

        if (batchObject instanceof Database.Batchable<SObject>) {
            Database.Batchable<SObject> batchClass = (Database.Batchable<SObject>) batchObject;
            Database.executeBatch(batchClass);
        }
    }
}