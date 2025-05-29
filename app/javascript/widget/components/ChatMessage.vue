<script>
import AgentMessage from 'widget/components/AgentMessage.vue';
import UserMessage from 'widget/components/UserMessage.vue';
import { mapGetters } from 'vuex';
import { MESSAGE_TYPE } from 'widget/helpers/constants';

export default {
  components: {
    AgentMessage,
    UserMessage,
  },
  props: {
    message: {
      type: Object,
      default: () => {},
    },
  },
  computed: {
    ...mapGetters({
      allMessages: 'conversation/getConversation',
    }),
    isUserMessage() {
      return this.message.message_type === MESSAGE_TYPE.INCOMING;
    },
    replyTo() {
      const replyTo = this.message?.content_attributes?.in_reply_to;
      return replyTo ? this.allMessages[replyTo] : null;
    },
    isHelpful() {
      return this.message?.content_attributes?.helpful || false;
    },
  },
  methods: {
    toggleHelpful(event) {
      const helpfulValue = event.target.checked;
      this.$store.dispatch('message/update', {
        email: this.message.email || '',
        messageId: this.message.id,
        submittedValues: {
          ...this.message.content_attributes,
          helpful: helpfulValue,
        },
      });
    },
  },
};
</script>

<template>
  <UserMessage
    v-if="isUserMessage"
    :id="`cwmsg-${message.id}`"
    :message="message"
    :reply-to="replyTo"
  />
  <AgentMessage
    v-else
    :id="`cwmsg-${message.id}`"
    :message="message"
    :reply-to="replyTo"
  />
  <!-- Helpful toggle -->
  <div class="helpful-toggle">
    <label>
      <input
        type="checkbox"
        :checked="isHelpful"
        @change="toggleHelpful"
      />
      Helpful?
    </label>
  </div>
</template>

<style scoped lang="scss">
.message-wrap {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  max-width: 90%;
}
.helpful-toggle {
  margin-top: 8px;
  font-size: 0.85rem;
  color: #555;
}
</style>
