/**
 * Created by yyusupov on 05.07.2022.
 */

public with sharing class MyMergeClass {

    public SObject performMerge(SObject master, SObject slave, Boolean isCloneMethod)
    {
        validateInput(master, slave);

        if (isCloneMethod)
        {
            return mergeInstancesReturnNewWithClone(master, slave);
        }
        else
        {
            mergeInstances(master, slave);
            return null;
        }
    }

    private void mergeInstances(SObject master, SObject slave)
    {
        Map<String, Object> slaveFields = slave.getPopulatedFieldsAsMap();

        try{
            for (String str : slaveFields.keySet())
            {
                if (master.get(str) == null)
                {
                    master.put(str, slave.get(str));
                }
            }
        } catch (Exception ex)
        {
            System.debug(ex);
        }
    }

    private SObject mergeInstancesReturnNewWithClone(SObject master, SObject slave)
    {
        Map<String, Object> slaveFields = slave.getPopulatedFieldsAsMap();
        SObject mergedObjectClone = master.clone(false, true, true, true);

        try{
            for (String str : slaveFields.keySet())
            {
                if (mergedObjectClone.get(str) == null)
                {
                    mergedObjectClone.put(str, slave.get(str));
                }
            }
        } catch (Exception ex)
        {
            System.debug(ex);
        }

        return mergedObjectClone;
    }

    private static void validateInput(SObject master, SObject slave)
    {
        if (master.getSObjectType() != slave.getSObjectType())
        {
            throw new MergeException('The provided instances are not same!');
        }
    }

    private class MergeException extends Exception {}
}