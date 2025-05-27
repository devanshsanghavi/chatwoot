<script setup>
import TopicCard from './TopicCard.vue';
import { assistantsList } from 'dashboard/components-next/captain/pageComponents/emptyStates/captainEmptyStateContent.js';
</script>

<template>
  <Story
    title="Captain/Topic/TopicCard"
    :layout="{ type: 'grid', width: '700px' }"
  >
    <Variant title="Topic Card">
      <div
        v-for="(assistant, index) in assistantsList"
        :key="index"
        class="px-20 py-4 bg-white dark:bg-slate-900"
      >
        <TopicCard
          :id="assistant.id"
          :name="assistant.name"
          :description="assistant.description"
          :updated-at="assistant.updated_at || assistant.created_at"
          :created-at="assistant.created_at"
        />
      </div>
    </Variant>
  </Story>
</template>
