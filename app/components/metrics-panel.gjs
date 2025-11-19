import MetricsCard from '../components/metrics-card.gjs';

<template>
  <div class="metrics-grid">
    {{#each @metrics as |metric|}}
      <MetricsCard @data={{metric}}/>
    {{/each}}
  </div>
</template>
