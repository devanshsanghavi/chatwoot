<script setup>
import { ref, computed, onMounted, watchEffect } from 'vue';
import { useStore } from 'dashboard/composables/store';
import Copilot from 'dashboard/components-next/copilot/Copilot.vue';
import ConversationAPI from 'dashboard/api/inbox/conversation';
import { useMapGetter } from 'dashboard/composables/store';
import { useUISettings } from 'dashboard/composables/useUISettings';

const props = defineProps({
  conversationId: {
    type: [Number, String],
    required: true,
  },
  conversationInboxType: {
    type: String,
    required: true,
  },
});

const store = useStore();
const currentUser = useMapGetter('getCurrentUser');
const assistants = useMapGetter('captainTopics/getRecords');
const inboxTopic = useMapGetter('getCopilotTopic');
const { uiSettings, updateUISettings } = useUISettings();

const messages = ref([]);
const isCaptainTyping = ref(false);
const selectedTopicId = ref(null);

const activeTopic = computed(() => {
  const preferredId = uiSettings.value.preferred_captain_assistant_id;

  // If the user has selected a specific assistant, it takes first preference for Copilot.
  if (preferredId) {
    const preferredTopic = assistants.value.find(a => a.id === preferredId);
    // Return the preferred assistant if found, otherwise continue to next cases
    if (preferredTopic) return preferredTopic;
  }

  // If the above is not available, the assistant connected to the inbox takes preference.
  if (inboxTopic.value) {
    const inboxMatchedTopic = assistants.value.find(
      a => a.id === inboxTopic.value.id
    );
    if (inboxMatchedTopic) return inboxMatchedTopic;
  }
  // If neither of the above is available, the first assistant in the account takes preference.
  return assistants.value[0];
});

const setTopic = async assistant => {
  selectedTopicId.value = assistant.id;
  await updateUISettings({
    preferred_captain_assistant_id: assistant.id,
  });
};

const handleReset = () => {
  messages.value = [];
};

const sendMessage = async message => {
  // Add user message
  messages.value.push({
    id: messages.value.length + 1,
    role: 'user',
    content: message,
  });
  isCaptainTyping.value = true;

  try {
    const { data } = await ConversationAPI.requestCopilot(
      props.conversationId,
      {
        previous_history: messages.value
          .map(m => ({
            role: m.role,
            content: m.content,
          }))
          .slice(0, -1),
        message,
        assistant_id: selectedTopicId.value,
      }
    );
    messages.value.push({
      id: new Date().getTime(),
      role: 'assistant',
      content: data.message,
    });
  } catch (error) {
    // eslint-disable-next-line
    console.log(error);
  } finally {
    isCaptainTyping.value = false;
  }
};

onMounted(() => {
  store.dispatch('captainTopics/get');
});

watchEffect(() => {
  if (props.conversationId) {
    store.dispatch('getInboxCaptainTopicById', props.conversationId);
    selectedTopicId.value = activeTopic.value?.id;
  }
});
</script>

<template>
  <Copilot
    :messages="messages"
    :support-agent="currentUser"
    :is-captain-typing="isCaptainTyping"
    :conversation-inbox-type="conversationInboxType"
    :assistants="assistants"
    :active-assistant="activeTopic"
    @set-assistant="setTopic"
    @send-message="sendMessage"
    @reset="handleReset"
  />
</template>
