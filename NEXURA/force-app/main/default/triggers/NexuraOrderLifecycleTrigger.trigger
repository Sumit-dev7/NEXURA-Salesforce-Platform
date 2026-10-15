trigger NexuraOrderLifecycleTrigger on Order (before update) {

    NexuraOrderLifecycleHandler.validateActivation(
        Trigger.new,
        Trigger.oldMap
    );
}