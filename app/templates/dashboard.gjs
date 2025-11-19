import MetricsPanel from '../components/metrics-panel.gjs';
import ChartsPanel from '../components/charts-panel.gjs';

<template>
  <MetricsPanel @metrics={{@model.metrics}}/>
  <ChartsPanel @charts={{@model.charts}}/>
</template>
