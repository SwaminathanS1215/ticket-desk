import ChartCard from '../components/chart-card.gjs';
import BarChartCard from '../components/bar-chart-card.gjs';
import eq from 'ticket-desk/helpers/eq';

<template>
  <div class="flex">
     {{#each @charts as |chart|}}
      {{#if (eq chart.type "bar")}}
        <BarChartCard  @data={{chart}}/>
      {{else}}
        <ChartCard @data={{chart}}/>
      {{/if}} 
    {{/each}}
  </div>
</template>
